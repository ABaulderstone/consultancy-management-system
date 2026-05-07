<script lang="ts">
	import type { HTMLSelectAttributes } from 'svelte/elements';

	type Option = {
		label: string;
		value: number | string;
	};

	interface Props extends HTMLSelectAttributes {
		options: Option[];
		value?: number;
	}

	let { options, value = $bindable(), ...rest }: Props = $props();

	let safeValue = $derived(value ?? '');

	function handleChange(e: Event) {
		const v = (e.target as HTMLSelectElement).value;

		if (v === '') {
			value = undefined;
			return;
		}

		const num = Number(v);
		value = Number.isNaN(num) ? undefined : num;
	}
</script>

<select {...rest} bind:value={safeValue} on:change={handleChange}>
	<option value="">Select...</option>

	{#each options as option (option.value)}
		<option value={option.value}>
			{option.label}
		</option>
	{/each}
</select>
