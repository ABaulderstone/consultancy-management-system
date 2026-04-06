<script lang="ts">
	import type { Snippet } from 'svelte';

	interface TimelineProps {
		children: Snippet;
		emptyMessage?: string;
		empty?: boolean;
	}

	let { children, emptyMessage = 'No records found', empty = false }: TimelineProps = $props();
</script>

{#if empty}
	<p class="text-muted small mb-0">{emptyMessage}</p>
{:else}
	<div class="d-flex flex-column gap-3">
		{@render children()}
	</div>
{/if}
