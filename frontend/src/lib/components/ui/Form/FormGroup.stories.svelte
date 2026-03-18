<script module>
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import FormGroup from './FormGroup.svelte';
	import FormInput from './FormInput.svelte';
	import FormRow from './FormRow.svelte';

	const { Story } = defineMeta({
		title: 'UI/Form/FormGroup',
		component: FormGroup,
		tags: ['autodocs'],
		argTypes: {
			label: { control: 'text' },
			error: { control: 'text' },
			col: { control: 'text' }
		}
	});
</script>

<Story name="Default" args={{ label: 'Email', for: 'email' }}>
	{#snippet children()}
		<FormInput id="email" type="email" placeholder="Enter email..." />
	{/snippet}
</Story>

<Story name="With Error" args={{ label: 'Email', for: 'email', error: 'Email is required' }}>
	{#snippet children()}
		<FormInput id="email" type="email" placeholder="Enter email..." error={true} />
	{/snippet}
</Story>

<Story name="Without Label" args={{}}>
	{#snippet children()}
		<FormInput type="text" placeholder="No label..." />
	{/snippet}
</Story>

<Story name="With Column" args={{ label: 'First Name', for: 'firstName', col: 'col-md-6' }}>
	{#snippet children()}
		<FormInput id="firstName" type="text" placeholder="Enter first name..." />
	{/snippet}
</Story>

<Story name="In a Row">
	{#snippet children()}
		<FormRow>
			{#snippet children()}
				<FormGroup label="First Name" for="firstName" col="col-md-4">
					{#snippet children()}
						<FormInput id="firstName" type="text" placeholder="First name..." />
					{/snippet}
				</FormGroup>
				<FormGroup label="Last Name" for="lastName" col="col-md-4">
					{#snippet children()}
						<FormInput id="lastName" type="text" placeholder="Last name..." />
					{/snippet}
				</FormGroup>
			{/snippet}
		</FormRow>
	{/snippet}
</Story>
