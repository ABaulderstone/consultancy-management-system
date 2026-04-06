<script module lang="ts">
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import TimelineItem from './TimelineItem.svelte';
	import TimelineChip from './TimelineChip.svelte';
	import Badge from '$lib/components/ui/Badge/Badge.svelte';

	const { Story } = defineMeta({
		title: 'UI/Timeline/TimelineItem',
		component: TimelineItem,
		tags: ['autodocs'],
		argTypes: {
			primary: { control: 'text' },
			secondary: { control: 'text' },
			dateRange: { control: 'text' },
			active: { control: 'boolean' },
			accent: {
				control: 'select',
				options: ['primary', 'secondary', 'success', 'danger', 'warning', 'info']
			}
		}
	});
</script>

<!-- Minimal — just the required props -->
<Story name="Default" args={{ primary: 'Senior Developer', dateRange: '1 Jan 2023 → Present' }} />

<!-- With secondary line -->
<Story
	name="With Secondary"
	args={{
		primary: 'Senior Developer',
		secondary: 'Engineering',
		dateRange: '1 Jan 2023 → Present'
	}}
/>

<!-- Active record — green accent bar -->
<Story
	name="Active"
	args={{
		primary: 'Senior Developer',
		secondary: 'Engineering',
		dateRange: '1 Jan 2023 → Present',
		active: true
	}}
/>

<!-- Historical record — muted accent -->
<Story
	name="Historical"
	args={{
		primary: 'Developer',
		secondary: 'Engineering',
		dateRange: '1 Mar 2021 → 31 Dec 2022',
		active: false
	}}
/>

<!-- With aside slot — badges and a chip -->
<Story
	name="With Aside"
	args={{
		primary: 'Senior Developer',
		secondary: 'Engineering',
		dateRange: '1 Jan 2023 → Present',
		active: true
	}}
>
	{#snippet aside()}
		<Badge variant="primary" size="sm">Full Time</Badge>
		<Badge variant="success" size="sm">Current</Badge>
	{/snippet}
</Story>

<!-- With details slot — financial chips -->
<Story
	name="With Details"
	args={{
		primary: 'Senior Developer',
		secondary: 'Engineering',
		dateRange: '1 Jan 2023 → Present',
		active: true
	}}
>
	{#snippet aside()}
		<Badge variant="primary" size="sm">Full Time</Badge>
		<Badge variant="success" size="sm">Current</Badge>
	{/snippet}
	{#snippet details()}
		<TimelineChip label="Annual rate" value="$85,000/yr" />
		<TimelineChip label="FTE" value="100% FTE" />
		<TimelineChip label="Daily cost" value="$327/day" />
	{/snippet}
</Story>

<!-- Explicit accent override -->
<Story
	name="Accent Override"
	args={{
		primary: 'Contractor Engagement',
		secondary: 'Product',
		dateRange: '1 Jun 2022 → 30 Nov 2022',
		accent: 'warning'
	}}
>
	{#snippet aside()}
		<Badge variant="warning" size="sm">Contractor</Badge>
	{/snippet}
</Story>
