<script lang="ts" generics="T extends Record<string, unknown>">
	import type { Snippet } from 'svelte';
	import type { SuperForm } from 'sveltekit-superforms';
	import type { FormHelpers } from '../../../types/form';

	interface FormProps {
		form: SuperForm<T>;
		children: Snippet;
		class?: string;
		onready?: (helpers: FormHelpers) => void;
	}

	let { form, children, class: className = '', onready }: FormProps = $props();

	let error = $state<string | undefined>(undefined);
	const enhance = $derived(form.enhance);

	const helpers: FormHelpers = {
		setError: (message: string) => (error = message),
		clearError: () => (error = undefined)
	};
	$effect(() => {
		onready?.(helpers);
	});
</script>

<form class={className} use:enhance>
	{#if error}
		<div class="alert alert-danger" role="alert">
			{error}
		</div>
	{/if}
	{@render children()}
</form>
