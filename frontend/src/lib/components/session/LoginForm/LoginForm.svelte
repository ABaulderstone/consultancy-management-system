<script lang="ts">
	import { superForm } from 'sveltekit-superforms';
	import type { FormHelpers } from '../../../types/form';
	import { schema, type LoginData } from './schema';
	import { zod4 } from 'sveltekit-superforms/adapters';
	import { handleFormSubmit } from '../../../utils/form';
	import Form from '../../ui/Form/Form.svelte';
	import FormGroup from '../../ui/Form/FormGroup.svelte';
	import FormInput from '../../ui/Form/FormInput.svelte';
	import Button from '../../ui/Button';

	interface LoginFormProps {
		onSubmit: (data: LoginData) => void;
	}
	let { onSubmit }: LoginFormProps = $props();

	const defaultValues: LoginData = { email: '', password: '' };
	let formHelpers = $state<FormHelpers | undefined>(undefined);

	const form = superForm(defaultValues, {
		validators: zod4(schema),
		SPA: true,
		onUpdate: async ({ form }) => {
			if (!form.valid) return;
			await handleFormSubmit(
				form.data as LoginData,
				(field, message) =>
					errors.update((current: Record<string, unknown>) => ({
						...current,
						[field]: [message]
					})),
				formHelpers!,
				async (data) => await onSubmit(data)
			);
		}
	});
	const { form: formData, errors, submitting } = form;
</script>

<Form {form} onready={(helpers) => (formHelpers = helpers)}>
	<FormGroup label="Email" for="email" error={$errors.email?.[0]}>
		<FormInput
			id="email"
			name="email"
			type="email"
			placeholder="Enter email"
			bind:value={$formData.email}
			error={!!$errors.email?.[0]}
		/>
	</FormGroup>
	<FormGroup label="Password" for="password" error={$errors.password?.[0]}>
		<FormInput
			id="password"
			name="password"
			type="password"
			placeholder="Enter password"
			bind:value={$formData.password}
			error={!!$errors.password?.[0]}
		/>
	</FormGroup>
	<Button type="submit" loading={$submitting} class="w-100 mt-2">Login</Button>
</Form>
