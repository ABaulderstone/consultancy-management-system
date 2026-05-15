<!-- $lib/components/job/JobCard.svelte -->
<script lang="ts">
	import type { BadgeVariant } from '../../../types/badge';
	import type { JobResponse } from '../../../types/job';
	import { formatDate } from '../../../utils/date';
	import Badge from '../../ui/Badge';
	import Card from '../../ui/Card';

	interface JobCardProps {
		job: JobResponse;
	}

	let { job }: JobCardProps = $props();

	const statusLabel = $derived(job.assignment ? 'assigned' : job.endDate ? 'closed' : 'open');
	const statusVariant = $derived<BadgeVariant>(
		statusLabel === 'assigned' ? 'primary' : statusLabel === 'closed' ? 'secondary' : 'success'
	);
</script>

<Card>
	{#snippet header()}
		<div class="d-flex justify-content-between align-items-start w-100">
			<div>
				<p class="mb-0 fw-semibold">{job.title}</p>
				<p class="mb-0 text-muted small">{job.client.name}</p>
			</div>
			<Badge variant={statusVariant}>{statusLabel}</Badge>
		</div>
	{/snippet}

	<div class="d-flex flex-column gap-2">
		<p class="mb-0 small text-muted">
			{formatDate(job.startDate)} — {formatDate(job.endDate)}
		</p>

		<p class="mb-0 fw-semibold">
			${job.dayRate.toLocaleString()}
			<span class="fw-normal text-muted small">/ day</span>
		</p>

		{#if job.assignment}
			<hr class="my-1" />
			<div class="d-flex align-items-center gap-2">
				<div
					class="rounded-circle bg-secondary flex-shrink-0"
					style="width: 28px; height: 28px;"
					aria-hidden="true"
				></div>
				<span class="small">{job.assignment.user.name ?? 'Unknown'}</span>
			</div>
		{/if}
	</div>
</Card>
