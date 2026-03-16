<script lang="ts">
	import type { Snippet } from 'svelte';

	interface TableCellProps {
		children: Snippet;
		href?: string;
		class?: string;
	}

	let { children, href, class: className }: TableCellProps = $props();

	const isExternal = $derived(href?.startsWith('http'));
</script>

<td class="align-middle {className ?? ''}">
	{#if href}
		<a
			{href}
			class="text-decoration-none"
			target={isExternal ? '_blank' : undefined}
			rel={isExternal ? 'noreferrer' : undefined}
		>
			{@render children()}
		</a>
	{:else}
		{@render children()}
	{/if}
</td>
