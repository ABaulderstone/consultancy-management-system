<script lang="ts">
	import type { HTMLInputAttributes } from 'svelte/elements';

	type Props = HTMLInputAttributes & {
		error?: boolean;
		value?: string | number | null | undefined;
	};

	let {
		error = false,
		value = $bindable(),
		type = 'text',
		class: className,
		...rest
	}: Props = $props();

	let safeValue = $derived(value ?? '');

	function handleInput(e: Event) {
		const el = e.target as HTMLInputElement;

		if (type === 'number') {
			value = el.value === '' ? undefined : Number(el.value);
		} else {
			value = el.value;
		}
	}
</script>

<input
	{type}
	class="form-control {error ? 'is-invalid' : ''} {className ?? ''}"
	value={safeValue}
	on:input={handleInput}
	{...rest}
/>
