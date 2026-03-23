<script lang="ts">
	import { superForm, defaults, type ValidationErrors } from 'sveltekit-superforms';
	import { zod4 } from 'sveltekit-superforms/adapters';
	import { z } from 'zod';
	import { FontAwesomeIcon } from '@fortawesome/svelte-fontawesome';
	import { faPen, faXmark, faCheck } from '@fortawesome/free-solid-svg-icons';
	import { handleFormSubmit } from '$lib/utils/form';
	import type { FormHelpers } from '$lib/types/form';
	import type { User } from '$lib/types/user';
	import Form from '$lib/components/ui/Form/Form.svelte';
	import FormGroup from '$lib/components/ui/Form/FormGroup.svelte';
	import FormInput from '$lib/components/ui/Form/FormInput.svelte';
	import FormRow from '$lib/components/ui/Form/FormRow.svelte';
	import Button from '$lib/components/ui/Button/Button.svelte';
	import FormRadio from '../../ui/Form/FormRadio.svelte';
	import type { UpdateUserParams } from '../../../api/user';

	interface UserFormProps {
		mode: 'create' | 'edit';
		user?: User;
		onSubmit: (data: UserFormData) => Promise<void>;
	}

	const GENDER_OPTIONS = [
		{ value: 'male', label: 'Male' },
		{ value: 'female', label: 'Female' },
		{ value: 'non_binary', label: 'Non-binary' },
		{ value: 'prefer_not_to_say', label: 'Prefer not to say' }
	];

	let { mode, user, onSubmit }: UserFormProps = $props();

	let editing = $state(mode === 'create');

	const schema = z.object({
		firstName: z.string().min(1, 'First name is required'),
		lastName: z.string().min(1, 'Last name is required'),
		title: z.string().optional(),
		dateOfBirth: z.iso.datetime().optional(),
		gender: z.enum(Object.keys(GENDER_OPTIONS)).optional()
	});

	const defaultValues: UpdateUserParams = {
		firstName: user?.firstName ?? '',
		lastName: user?.lastName ?? '',
		title: user?.title ?? '',
		dateOfBirth: user?.dateOfBirth ?? ''
	};

	const form = superForm(defaultValues, {
		validators: zod4(schema),
		SPA: true,
		onUpdate: async ({ form }) => {
			if (!form.valid) return;
			await handleFormSubmit(
				form.data as UpdateUserParams,
				(field, message) =>
					errors.update(
						(current: Record<string, unknown>) =>
							({
								...current,
								[field]: [message]
							}) as ValidationErrors<UpdateUserParams>
					),
				formHelpers!,
				async (data) => {
					await onSubmit(data);
					if (mode === 'edit') editing = false;
				}
			);
		}
	});

	const { form: formData, errors, submitting } = form;

	let formHelpers = $state<FormHelpers | undefined>(undefined);

	function cancelEdit() {
		if (user) {
			$formData.firstName = user.firstName ?? '';
			$formData.lastName = user.lastName ?? '';
			$formData.title = user.title ?? '';
			$formData.dateOfBirth = user.dateOfBirth ?? '';
		}
		editing = false;
	}
</script>

<Form {form} onready={(h) => (formHelpers = h)}>
	<FormRow>
		<FormGroup label="First Name" for="firstName" error={$errors.firstName?.[0]} col="col-md-6">
			<FormInput
				id="firstName"
				name="firstName"
				bind:value={$formData.firstName}
				error={!!$errors.firstName?.[0]}
				disabled={!editing}
			/>
		</FormGroup>
		<FormGroup label="Last Name" for="lastName" error={$errors.lastName?.[0]} col="col-md-6">
			<FormInput
				id="lastName"
				name="lastName"
				bind:value={$formData.lastName}
				error={!!$errors.lastName?.[0]}
				disabled={!editing}
			/>
		</FormGroup>
	</FormRow>
	<FormGroup label="Title" for="title">
		<FormInput id="title" name="title" bind:value={$formData.title} disabled={!editing} />
	</FormGroup>
	<FormGroup label="Date of Birth" for="dateOfBirth">
		<FormInput
			id="dateOfBirth"
			name="dateOfBirth"
			type="date"
			bind:value={$formData.dateOfBirth}
			disabled={!editing}
		/>
	</FormGroup>

	<FormGroup label="Gender" for="gender" error={$errors.gender?.[0]}>
		<FormRadio
			name="gender"
			options={GENDER_OPTIONS}
			bind:value={$formData.gender}
			disabled={!editing}
			error={!!$errors.gender?.[0]}
		/>
	</FormGroup>

	{#if editing}
		<div class="d-flex gap-2 mt-3">
			<Button type="submit" variant="primary" loading={$submitting} class="flex-grow-1">
				<FontAwesomeIcon icon={faCheck} class="me-1" />
				{mode === 'create' ? 'Create User' : 'Save'}
			</Button>
			{#if mode === 'edit'}
				<Button type="button" variant="outline-secondary" onclick={cancelEdit}>
					<FontAwesomeIcon icon={faXmark} />
				</Button>
			{/if}
		</div>
	{:else}
		<div class="d-flex gap-2 mt-3">
			<Button
				type="button"
				variant="outline-primary"
				class="flex-grow-1"
				onclick={() => (editing = true)}
			>
				<FontAwesomeIcon icon={faPen} class="me-1" /> Edit
			</Button>
		</div>
	{/if}
</Form>
