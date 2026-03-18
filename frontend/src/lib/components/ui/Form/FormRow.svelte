<script lang="ts">
	import type { Snippet } from 'svelte';

	interface FormRowProps {
		children: Snippet;
		class?: string;
	}

	let { children, class: className = '' }: FormRowProps = $props();
</script>

<div class="row g-3 {className}">
	{@render children()}
</div>
