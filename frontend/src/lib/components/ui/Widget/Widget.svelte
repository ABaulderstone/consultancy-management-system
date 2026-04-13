<script lang="ts">
	import type { Snippet } from 'svelte';
	import Card from '../Card';

	interface WidgetProps {
		title?: string;

		isLoading?: boolean;
		isFetching?: boolean;
		isError?: boolean;

		headerContent?: Snippet;
		children: Snippet;
		class?: string;
	}

	let {
		title,
		isLoading = false,
		isFetching = false,
		isError = false,
		headerContent,
		children,
		class: className = ''
	}: WidgetProps = $props();
</script>

<Card {title} class={className}>
	{#snippet header()}
		<div class="d-flex align-items-center gap-2">
			{#if isFetching && !isLoading}
				<span class="spinner-border spinner-border-sm"></span>
			{/if}

			{#if headerContent}
				{@render headerContent()}
			{/if}
		</div>
	{/snippet}

	{#if isLoading}
		<div class="text-center py-4">
			<div class="spinner-border"></div>
		</div>
	{:else if isError}
		<div class="text-danger py-4">Something went wrong</div>
	{:else}
		{@render children()}
	{/if}
</Card>
