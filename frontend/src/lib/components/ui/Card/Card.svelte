<script lang="ts">
	import type { Snippet } from 'svelte';

	interface CardProps {
		title?: string;
		header?: Snippet;
		children: Snippet;
		class?: string;
	}

	let { title, header, children, class: className = '' }: CardProps = $props();
</script>

<div class="card {className}">
	{#if title || header}
		<div class="card-header d-flex justify-content-between align-items-center fw-semibold">
			{#if title}
				<span>{title}</span>
			{/if}
			{#if header}
				{@render header()}
			{/if}
		</div>
	{/if}
	<div class="card-body">
		{@render children()}
	</div>
</div>
