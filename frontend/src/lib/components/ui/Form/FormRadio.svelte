<script lang="ts">
	interface Option {
		value: string;
		label: string;
	}

	interface RadioOptionProps {
		name: string;
		options: Option[];
		value?: string;
		disabled?: boolean;
		error?: boolean;
		layout?: 'horizontal' | 'vertical';
		class?: string;
	}

	let {
		name,
		options,
		value = $bindable(),
		disabled = false,
		error = false,
		layout = 'horizontal',
		class: className = ''
	}: RadioOptionProps = $props();
</script>

<div
	class="{layout === 'horizontal' ? 'd-flex flex-wrap gap-3' : 'd-flex flex-column gap-2'} {error
		? 'is-invalid'
		: ''} {className}"
>
	{#each options as option (option.value)}
		<div class="form-check">
			<input
				class="form-check-input"
				type="radio"
				id="{name}-{option.value}"
				{name}
				value={option.value}
				bind:group={value}
				{disabled}
			/>
			<label class="form-check-label" for="{name}-{option.value}">
				{option.label}
			</label>
		</div>
	{/each}
</div>
