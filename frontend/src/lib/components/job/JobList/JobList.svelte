<!-- $lib/components/job/JobList.svelte -->
<script lang="ts">
	import type { JobResponse } from '../../../types/job';
	import { JobCard } from '../JobCard';

	interface JobListProps {
		jobs: JobResponse[];
		fetching: boolean;
	}

	let { jobs, fetching }: JobListProps = $props();
</script>

{#if jobs.length === 0}
	<p class="text-muted">No jobs found.</p>
{:else}
	<div class="row row-cols-1 row-cols-md-2 row-cols-xl-3 g-3" class:opacity-50={fetching}>
		{#each jobs as job (job.id)}
			<div class="col">
				<JobCard {job} />
			</div>
		{/each}
	</div>
{/if}
