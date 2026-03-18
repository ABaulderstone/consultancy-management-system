<script module>
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import FormInput from './FormInput.svelte';

	const { Story } = defineMeta({
		title: 'UI/Form/FormInput',
		component: FormInput,
		tags: ['autodocs'],
		argTypes: {
			type: {
				control: 'select',
				options: ['text', 'email', 'password', 'number', 'date']
			},
			error: { control: 'boolean' },
			disabled: { control: 'boolean' },
			placeholder: { control: 'text' }
		}
	});
</script>

<Story name="Default" args={{ type: 'text', placeholder: 'Enter text...' }} />

<Story name="With Value" args={{ type: 'text', value: 'Some value' }} />

<Story name="Email" args={{ type: 'email', placeholder: 'Enter email...' }} />

<Story name="Password" args={{ type: 'password', placeholder: 'Enter password...' }} />

<Story name="Error" args={{ type: 'text', placeholder: 'Enter text...', error: true }} />

<Story name="Disabled" args={{ type: 'text', value: 'Disabled value', disabled: true }} />
