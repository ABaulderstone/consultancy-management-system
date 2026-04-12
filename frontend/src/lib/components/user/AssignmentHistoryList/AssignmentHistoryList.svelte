<script lang="ts">
	import { Timeline, TimelineItem, TimelineChip } from '$lib/components/ui/Timeline';
	import Badge from '$lib/components/ui/Badge/Badge.svelte';
	import type { AssignmentHistory } from '../../../types/assignment';
	import { dateRange} from '../../../utils/date';

	interface Props {
		assignments: AssignmentHistory[];
	}

	let { assignments }: Props = $props();



</script>

<Timeline empty={assignments.length === 0} emptyMessage="No assignment history">
	{#each assignments as assignment (assignment.id)}
		<TimelineItem
			primary={assignment.job.title}
			secondary={assignment.job.client}
			dateRange={dateRange(assignment)}
			active={!assignment.endDate}
		>
			{#snippet aside()}
				{#if !assignment.endDate}
					<Badge variant="primary" size="sm">Active</Badge>
				{/if}
				<TimelineChip label="Day rate" value="${assignment.job.dayRate.toLocaleString()}/day" />
			{/snippet}
		</TimelineItem>
	{/each}
</Timeline>