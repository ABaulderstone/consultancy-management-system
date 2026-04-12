<script module lang="ts">
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import TimelineChip from './TimelineChip.svelte';

	const { Story } = defineMeta({
		title: 'UI/Timeline/TimelineChip',
		component: TimelineChip,
		tags: ['autodocs'],
		argTypes: {
			label: { control: 'text' },
			value: { control: 'text' }
		}
	});
</script>

<Story name="Default" args={{ label: 'Annual rate', value: '$85,000/yr' }} />

<Story name="Day Rate" args={{ label: 'Day rate', value: '$650/day' }} />

<Story name="FTE" args={{ label: 'FTE', value: '80% FTE' }} />
