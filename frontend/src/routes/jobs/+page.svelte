<script lang="ts">
	import { goto } from '$app/navigation';
	import { page } from '$app/stores';
	import { createQuery } from '@tanstack/svelte-query';
	import { SvelteURLSearchParams } from 'svelte/reactivity';
	import Pagination from '../../lib/components/ui/Pagination';
	import Button from '../../lib/components/ui/Button';
	import { jobApi } from '../../lib/api/job';
	import type { JobStatus } from '../../lib/types/job';
	import { JobFilters } from '../../lib/components/job/JobFilters';
	import { JobList } from '../../lib/components/job/JobList';

	type JobsQueryData = Awaited<ReturnType<typeof jobApi.list>>;

	const currentPage = $derived(Number($page.url.searchParams.get('page') ?? 1));
	const limit = $derived(Number($page.url.searchParams.get('limit') ?? 20));
	const search = $derived($page.url.searchParams.get('search') ?? undefined);
	const status = $derived($page.url.searchParams.get('status') ?? undefined) as JobStatus;

	const jobsQuery = createQuery<JobsQueryData>(() => ({
		queryKey: ['jobs', currentPage, limit, search, status],
		queryFn: () => jobApi.list({ page: currentPage, limit, search, status })
	}));

	function updateParams(updates: Record<string, string | null>) {
		const params = new SvelteURLSearchParams($page.url.searchParams);
		Object.entries(updates).forEach(([key, value]) => {
			if (value === null) {
				params.delete(key);
			} else {
				params.set(key, value);
			}
		});
		goto(`?${params}`, { replaceState: false, keepFocus: true, noScroll: true });
	}

	function handleSearch(term: string) {
		updateParams({ search: term || null, page: '1' });
	}

	function handleStatusChange(value: string) {
		updateParams({ status: value || null, page: '1' });
	}

	function handlePageChange(newPage: number) {
		const totalPages = jobsQuery.data?.meta.pages ?? 1;
		const safePage = Math.max(1, Math.min(newPage, totalPages));
		updateParams({ page: String(safePage) });
	}
</script>

<div class="container py-4">
	<div class="d-flex justify-content-between align-items-center mb-4">
		<h1 class="h3 mb-0">Jobs</h1>
		<Button>Add Job</Button>
	</div>

	<JobFilters {search} {status} onSearch={handleSearch} onStatusChange={handleStatusChange} />

	{#if jobsQuery.isLoading}
		<p class="text-muted">Loading…</p>
	{:else if jobsQuery.isError}
		<p class="text-danger">Something went wrong loading jobs.</p>
	{:else if jobsQuery.data}
		<Pagination
			currentPage={jobsQuery.data.meta.page}
			totalPages={jobsQuery.data.meta.pages}
			totalCount={jobsQuery.data.meta.count}
			{limit}
			onPageChange={handlePageChange}
		/>
		<JobList fetching={jobsQuery.isFetching} jobs={jobsQuery.data?.data ?? []} />
	{/if}
</div>
