<script lang="ts">
	import type { HTMLButtonAttributes } from 'svelte/elements';

	interface ButtonProps extends HTMLButtonAttributes {
		variant?:
			| 'primary'
			| 'secondary'
			| 'danger'
			| 'outline-primary'
			| 'outline-secondary'
			| 'outline-danger';
		size?: 'sm' | 'lg';
		loading?: boolean;
	}

	let {
		variant = 'primary',
		size,
		loading = false,
		disabled,
		children,
		class: className,
		...rest
	}: ButtonProps = $props();
</script>

<button
	class="btn btn-{variant} {size ? `btn-${size}` : ''} {className ?? ''}"
	disabled={disabled || loading}
	{...rest}
>
	{#if loading}
		<span class="spinner-border spinner-border-sm me-2" role="status"></span>
	{/if}
	{@render children?.()}
</button>
