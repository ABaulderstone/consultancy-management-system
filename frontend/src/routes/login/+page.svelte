<script lang="ts">
	import { resolve } from '$app/paths';

	import { goto } from '$app/navigation';
	import { superForm } from 'sveltekit-superforms';
	import { z } from 'zod/v4';
	import { zod4 } from 'sveltekit-superforms/adapters';

	import { sessionApi } from '$lib/api';
	import { authStore } from '$lib/stores/auth.svelte';
	import Form from '$lib/components/ui/Form/Form.svelte';
	import FormGroup from '$lib/components/ui/Form/FormGroup.svelte';
	import FormInput from '$lib/components/ui/Form/FormInput.svelte';
	import Button from '$lib/components/ui/Button/Button.svelte';
	import type { FormHelpers } from '../../lib/types/form';
	import { handleFormSubmit } from '../../lib/utils/form';
	import { toast } from 'svelte-sonner';

	const schema = z.object({
		email: z.email(),
		password: z.string().min(1, 'Password is required')
	});

	type LoginData = z.infer<typeof schema>;
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
				async (data) => {
					authStore.user = await sessionApi.create(data);
					goto(resolve('/'));
					toast.success('Logged in');
				}
			);
		}
	});
	const { form: formData, errors, submitting } = form;
</script>

<div class="min-vh-100 d-flex align-items-center justify-content-center">
	<div class="card p-4" style="width: 100%; max-width: 400px">
		<h2 class="text-center mb-4">Login</h2>

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
	</div>
</div>
