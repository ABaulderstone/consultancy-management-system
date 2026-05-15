<script lang="ts">
	import type { HTMLSelectAttributes } from 'svelte/elements';

	type Option = {
		label: string;
		value: number | string;
	};

	interface Props extends HTMLSelectAttributes {
		options: Option[];
		value?: number | string;
	}

	let { options, value = $bindable(), ...rest }: Props = $props();
</script>

<select {...rest} bind:value>
	<option value="">Select...</option>

	{#each options as option (option.value)}
		<option value={option.value}>
			{option.label}
		</option>
	{/each}
</select>
