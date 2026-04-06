<script module lang="ts">
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import Timeline from './Timeline.svelte';
	import TimelineItem from './TimelineItem.svelte';
	import TimelineChip from './TimelineChip.svelte';
	import Badge from '$lib/components/ui/Badge/Badge.svelte';

	const { Story } = defineMeta({
		title: 'UI/Timeline/Timeline',
		component: Timeline,
		tags: ['autodocs'],
		argTypes: {
			empty: { control: 'boolean' },
			emptyMessage: { control: 'text' }
		}
	});
</script>

<!-- Empty state -->
<Story name="Empty" args={{ empty: true }} />

<Story name="Empty Custom Message" args={{ empty: true, emptyMessage: 'No contract history' }} />

<!-- Multiple items showing gap spacing and accent transitions -->
<Story name="Multiple Items">
	{#snippet children()}
		<TimelineItem
			primary="Senior Developer"
			secondary="Engineering"
			dateRange="1 Jan 2023 → Present"
			active={true}
		>
			{#snippet aside()}
				<Badge variant="primary" size="sm">Full Time</Badge>
				<Badge variant="success" size="sm">Current</Badge>
			{/snippet}
			{#snippet details()}
				<TimelineChip label="Annual rate" value="$85,000/yr" />
				<TimelineChip label="Daily cost" value="$327/day" />
			{/snippet}
		</TimelineItem>

		<TimelineItem primary="Developer" secondary="Engineering" dateRange="1 Mar 2021 → 31 Dec 2022">
			{#snippet aside()}
				<Badge variant="primary" size="sm">Full Time</Badge>
			{/snippet}
			{#snippet details()}
				<TimelineChip label="Annual rate" value="$70,000/yr" />
				<TimelineChip label="Daily cost" value="$269/day" />
			{/snippet}
		</TimelineItem>

		<TimelineItem
			primary="Junior Developer"
			secondary="Engineering"
			dateRange="15 Sep 2019 → 28 Feb 2021"
		>
			{#snippet aside()}
				<Badge variant="primary" size="sm">Full Time</Badge>
			{/snippet}
			{#snippet details()}
				<TimelineChip label="Annual rate" value="$55,000/yr" />
				<TimelineChip label="Daily cost" value="$212/day" />
			{/snippet}
		</TimelineItem>
	{/snippet}
</Story>

<!-- Single item — no awkward spacing issues -->
<Story name="Single Item">
	{#snippet children()}
		<TimelineItem
			primary="Senior Developer"
			secondary="Engineering"
			dateRange="1 Jan 2023 → Present"
			active={true}
		>
			{#snippet aside()}
				<Badge variant="success" size="sm">Current</Badge>
			{/snippet}
		</TimelineItem>
	{/snippet}
</Story>
