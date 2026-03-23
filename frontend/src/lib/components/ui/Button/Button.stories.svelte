<script module>
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import Button from './Button.svelte';

	const { Story } = defineMeta({
		title: 'UI/Button',
		component: Button,
		tags: ['autodocs'],
		argTypes: {
			variant: {
				control: 'select',
				options: [
					'primary',
					'secondary',
					'danger',
					'outline-primary',
					'outline-secondary',
					'outline-danger'
				]
			},
			size: {
				control: 'select',
				options: ['sm', 'lg']
			},
			loading: { control: 'boolean' },
			disabled: { control: 'boolean' }
		}
	});
</script>

<Story name="Primary" args={{ variant: 'primary' }}>
	{#snippet children()}
		Primary Button
	{/snippet}
</Story>

<Story name="Secondary" args={{ variant: 'secondary' }}>
	{#snippet children()}
		Secondary Button
	{/snippet}
</Story>

<Story name="Danger" args={{ variant: 'danger' }}>
	{#snippet children()}
		Danger Button
	{/snippet}
</Story>

<Story name="Outline Primary" args={{ variant: 'outline-primary' }}>
	{#snippet children()}
		Outline Primary
	{/snippet}
</Story>

<Story name="Outline Secondary" args={{ variant: 'outline-secondary' }}>
	{#snippet children()}
		Outline Secondary
	{/snippet}
</Story>

<Story name="Small" args={{ variant: 'primary', size: 'sm' }}>
	{#snippet children()}
		Small Button
	{/snippet}
</Story>

<Story name="Large" args={{ variant: 'primary', size: 'lg' }}>
	{#snippet children()}
		Large Button
	{/snippet}
</Story>

<Story name="Loading" args={{ variant: 'primary', loading: true }}>
	{#snippet children()}
		Loading
	{/snippet}
</Story>

<Story name="Disabled" args={{ variant: 'primary', disabled: true }}>
	{#snippet children()}
		Disabled
	{/snippet}
</Story>
