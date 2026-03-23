<script lang="ts">
	import type { Snippet } from 'svelte';
	import type { BadgeVariant } from '../../../types/badge';

	type Size = 'sm' | 'md' | 'lg';

	interface BadgeProps {
		variant?: BadgeVariant;
		size?: Size;
		class?: string;
		children: Snippet;
	}

	let {
		variant = 'secondary',
		size = 'md',
		class: className = '',
		children
	}: BadgeProps = $props();

	const sizeClass: Record<Size, string> = {
		sm: 'fs-6',
		md: '',
		lg: 'fs-5'
	};
</script>

<span class="badge bg-{variant} {sizeClass[size]} {className}">
	{@render children()}
</span>
