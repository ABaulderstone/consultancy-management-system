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
		// eslint-disable-next-line svelte/prefer-svelte-reactivity
		const d = new Date(date);
		// eslint-disable-next-line @typescript-eslint/no-unused-expressions
		view === 'month' ? d.setMonth(d.getMonth() - 1) : d.setFullYear(d.getFullYear() - 1);
		date = d;
	}

	function next() {
		// eslint-disable-next-line svelte/prefer-svelte-reactivity
		const d = new Date(date);

		// eslint-disable-next-line @typescript-eslint/no-unused-expressions
		view === 'month' ? d.setMonth(d.getMonth() + 1) : d.setFullYear(d.getFullYear() + 1);
		date = d;
	}
</script>

// eslint-disable-next-line @typescript-eslint/no-unused-expressions
<Story name="Month View - Static March 2024">
	<PeriodControls
		view="month"
		label="March 2024"
		onPrevious={() => {}}
		onNext={() => {}}
		onViewChange={() => {}}
	/>
</Story>

<Story name="Year View - Static 2024">
	<PeriodControls
		view="year"
		label="2024"
		onPrevious={() => {}}
		onNext={() => {}}
		onViewChange={() => {}}
	/>
</Story>

<Story name="Interactive">
	<PeriodControls
		{view}
		{label}
		onPrevious={previous}
		onNext={next}
		onViewChange={(v) => (view = v)}
	/>
</Story>
