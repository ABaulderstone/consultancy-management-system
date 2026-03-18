<script module>
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import Modal from './Modal.svelte';
	import Button from '../Button/Button.svelte';
	import { fn } from 'storybook/test';

	const { Story } = defineMeta({
		title: 'UI/Modal',
		component: Modal,
		argTypes: {
			open: { control: 'boolean' },
			title: { control: 'text' },
			confirmText: { control: 'text' },
			showClose: { control: 'boolean' },
			loading: { control: 'boolean' }
		},
		args: {
			onClose: fn(),
			onConfirm: fn()
		}
	});
</script>

{#snippet customFooter()}
	<Button variant="outline-secondary">Cancel</Button>
	<Button variant="danger">Delete</Button>
	<Button variant="primary">Save</Button>
{/snippet}

{#snippet modalContent()}
	Modal with a custom footer.
{/snippet}

<Story name="Default" args={{ open: true, title: 'Modal Title', confirmText: 'Confirm' }}>
	{#snippet children()}
		Modal body content goes here.
	{/snippet}
</Story>

<Story name="No Title" args={{ open: true }}>
	{#snippet children()}
		Modal without a title.
	{/snippet}
</Story>

<Story
	name="Loading Confirm"
	args={{ open: true, title: 'Saving...', confirmText: 'Save', loading: true }}
>
	{#snippet children()}
		Saving your changes.
	{/snippet}
</Story>

<Story
	name="No Close Button"
	args={{ open: true, title: 'Required Action', showClose: false, confirmText: 'Accept' }}
>
	{#snippet children()}
		You must accept to continue.
	{/snippet}
</Story>

<Story
	name="Delete Confirmation"
	args={{ open: true, title: 'Delete User', confirmText: 'Delete' }}
>
	{#snippet children()}
		Are you sure you want to delete this user? This action cannot be undone.
	{/snippet}
</Story>

<Story
	name="Custom Footer"
	args={{ open: true, title: 'Custom Footer', children: modalContent, footer: customFooter }}
/>

<Story name="Closed" args={{ open: false, title: 'Hidden Modal' }}>
	{#snippet children()}
		This should not be visible.
	{/snippet}
</Story>
