<script module lang="ts">
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import PeriodControls from './PeriodControls.svelte';
	import type { PeriodView } from '../../../types/dashboard';

	const { Story } = defineMeta({
		title: 'UI/PeriodControls',
		tags: ['autodocs']
	});

	let view = $state<PeriodView>('month');
	let date = $state(new Date());

	const label = $derived(
		view === 'month'
			? date.toLocaleDateString('en-GB', { month: 'long', year: 'numeric' })
			: date.getFullYear().toString()
	);

	function previous() {
		const d = new Date(date);
		view === 'month' ? d.setMonth(d.getMonth() - 1) : d.setFullYear(d.getFullYear() - 1);
		date = d;
	}

	function next() {
		const d = new Date(date);
		view === 'month' ? d.setMonth(d.getMonth() + 1) : d.setFullYear(d.getFullYear() + 1);
		date = d;
	}
</script>

<Story name="Month View - Static March 2024">
	{#snippet children()}
		<PeriodControls
			view="month"
			label="March 2024"
			onPrevious={() => {}}
			onNext={() => {}}
			onViewChange={() => {}}
		/>
	{/snippet}
</Story>

<Story name="Year View - Static 2024">
	{#snippet children()}
		<PeriodControls
			view="year"
			label="2024"
			onPrevious={() => {}}
			onNext={() => {}}
			onViewChange={() => {}}
		/>
	{/snippet}
</Story>

<Story name="Interactive">
	{#snippet children()}
		<PeriodControls
			{view}
			{label}
			onPrevious={previous}
			onNext={next}
			onViewChange={(v) => (view = v)}
		/>
	{/snippet}
</Story>
