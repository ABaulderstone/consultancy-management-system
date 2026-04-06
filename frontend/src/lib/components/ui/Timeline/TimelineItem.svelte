<script lang="ts">
	import type { Snippet } from 'svelte';
	import type { BadgeVariant } from '$lib/types/badge';

	interface TimelineItemProps {
		primary: string;
		secondary?: string;
		dateRange: string;
		accent?: BadgeVariant;
		active?: boolean;
		aside?: Snippet;
		details?: Snippet;
	}

	let {
		primary,
		secondary,
		dateRange,
		accent,
		active = false,
		aside,
		details
	}: TimelineItemProps = $props();

	const resolvedAccent = $derived(accent ?? (active ? 'success' : 'secondary'));
</script>

<div class="border-start border-3 border-{resolvedAccent} ps-3">
	<div class="d-flex justify-content-between align-items-start gap-3">
		<div class="d-flex flex-column min-width-0">
			<span class="fw-medium">{primary}</span>
			{#if secondary}
				<span class="small text-muted">{secondary}</span>
			{/if}
		</div>
		{#if aside}
			<div class="d-flex align-items-center gap-2 flex-shrink-0">
				{@render aside()}
			</div>
		{/if}
	</div>

	<div class="d-flex align-items-center gap-2 mt-1 flex-wrap">
		<span class="small text-muted text-nowrap">{dateRange}</span>
		{#if details}
			<div class="d-flex align-items-center gap-2 flex-wrap">
				{@render details()}
			</div>
		{/if}
	</div>
</div>
