<script lang="ts">
	import { goto } from '$app/navigation';
	import { page } from '$app/state';
	import { createQuery } from '@tanstack/svelte-query';
	import { SvelteURLSearchParams } from 'svelte/reactivity';
	import Widget from '$lib/components/ui/Widget/Widget.svelte';
	import type { PeriodView } from '../../../lib/types/dashboard';
	import PeriodControls from '../../../lib/components/ui/PeriodControls/PeriodControls.svelte';
	import { ProfitSummaryChart } from '../../../lib/components/analytics/ProfitSumaryChart';
	import { analyticsApi } from '../../../lib/api/analytics';
	import RevenueShareChart from '../../../lib/components/analytics/RevenueShareChart/RevenueShareChart.svelte';

	const view = $derived((page.url.searchParams.get('view') ?? 'month') as PeriodView);

	const monthParam = $derived(
		page.url.searchParams.get('month') ??
			new Date().toLocaleDateString('en-CA', { year: 'numeric', month: '2-digit' })
	);

	const yearParam = $derived(page.url.searchParams.get('year') ?? String(new Date().getFullYear()));

	const label = $derived(
		view === 'month'
			? new Date(monthParam + '-02').toLocaleDateString('en-GB', { month: 'long', year: 'numeric' })
			: yearParam
	);

	function updateParams(updates: Record<string, string>) {
		const params = new SvelteURLSearchParams(page.url.searchParams);
		Object.entries(updates).forEach(([key, value]) => params.set(key, value));
		goto(`?${params}`, { replaceState: false, keepFocus: true, noScroll: true });
	}

	function handleViewChange(v: PeriodView) {
		updateParams({ view: v });
	}

	function handlePrevious() {
		if (view === 'month') {
			const d = new Date(monthParam + '-02');
			d.setMonth(d.getMonth() - 1);
			updateParams({
				view,
				month: d.toLocaleDateString('en-CA', { year: 'numeric', month: '2-digit' })
			});
		} else {
			updateParams({ view, year: String(Number(yearParam) - 1) });
		}
	}

	function handleNext() {
		if (view === 'month') {
			const d = new Date(monthParam + '-02');
			d.setMonth(d.getMonth() + 1);
			updateParams({
				view,
				month: d.toLocaleDateString('en-CA', { year: 'numeric', month: '2-digit' })
			});
		} else {
			updateParams({ view, year: String(Number(yearParam) + 1) });
		}
	}

	const profitQuery = createQuery(() => ({
		queryKey: ['analytics', 'profitSummary', view, view === 'month' ? monthParam : yearParam],
		queryFn: () =>
			view === 'month'
				? analyticsApi.profitSummary({ month: monthParam })
				: analyticsApi.profitSummary({ year: yearParam })
	}));

	const revenueShareQuery = createQuery(() => ({
		queryKey: ['analytics', 'revenueShare', view, view === 'month' ? monthParam : yearParam],
		queryFn: () =>
			view === 'month'
				? analyticsApi.revenueShare({ month: monthParam })
				: analyticsApi.revenueShare({ year: yearParam })
	}));
</script>

<div class="container py-4">
	<div class="d-flex justify-content-between align-items-center mb-4">
		<h1 class="h3 mb-0">Dashboard</h1>
		<PeriodControls
			{view}
			{label}
			onPrevious={handlePrevious}
			onNext={handleNext}
			onViewChange={handleViewChange}
		/>
	</div>

	<div class="row g-4">
		<div class="col-lg-6">
			<Widget
				title="Profit Summary"
				isLoading={profitQuery.isLoading}
				isFetching={profitQuery.isFetching}
				isError={profitQuery.isError}
			>
				{#if profitQuery.data}
					<ProfitSummaryChart data={profitQuery.data} {view} />
				{/if}
			</Widget>
		</div>
		<div class="col-lg-6">
			<Widget
				title="Revenue Share"
				isLoading={revenueShareQuery.isLoading}
				isFetching={revenueShareQuery.isFetching}
				isError={revenueShareQuery.isError}
			>
				{#if revenueShareQuery.data}
					<RevenueShareChart data={revenueShareQuery.data} />
				{/if}
			</Widget>
		</div>
	</div>
</div>
