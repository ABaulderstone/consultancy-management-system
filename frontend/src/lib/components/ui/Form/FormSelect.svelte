<script lang="ts">
	import type { HTMLSelectAttributes } from 'svelte/elements';

	export interface Option {
		label: string;
		value: string | number;
	}

	interface FormSelectProps extends HTMLSelectAttributes {
		error?: boolean;
		value?: string | number;
		options: Option[];
		placeholder?: string;
	}

	let {
		error = false,
		value = $bindable(''),
		options = [],
		placeholder,
		class: className,
		...rest
	}: FormSelectProps = $props();
</script>

<select class="form-select {error ? 'is-invalid' : ''} {className ?? ''}" bind:value {...rest}>
	{#if placeholder}
		<option value="" disabled selected={value === ''}>
			{placeholder}
		</option>
	{/if}

	{#each options as option (option.value)}
		<option value={option.value}>
			{option.label}
		</option>
	{/each}
</select>
