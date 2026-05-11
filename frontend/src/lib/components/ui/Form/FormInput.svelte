<script lang="ts">
	import type { HTMLInputAttributes } from 'svelte/elements';

	type Props = HTMLInputAttributes & {
		error?: boolean;
		value?: string | number | null;
	};

	let { error = false, value = $bindable(), class: className, ...rest }: Props = $props();
</script>

<input class="form-control {error ? 'is-invalid' : ''} {className ?? ''}" bind:value {...rest} />
