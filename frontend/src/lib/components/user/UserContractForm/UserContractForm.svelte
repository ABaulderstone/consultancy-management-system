<script lang="ts">
	import { superForm, setError } from 'sveltekit-superforms';
	import { zod4 } from 'sveltekit-superforms/adapters';

	import Form from '$lib/components/ui/Form/Form.svelte';
	import FormGroup from '$lib/components/ui/Form/FormGroup.svelte';
	import FormInput from '$lib/components/ui/Form/FormInput.svelte';
	import FormSelect from '$lib/components/ui/Form/FormSelect.svelte';
	import FormRow from '$lib/components/ui/Form/FormRow.svelte';
	import FormRadio from '$lib/components/ui/Form/FormRadio.svelte';
	import Button from '$lib/components/ui/Button/Button.svelte';

	import { createQuery } from '@tanstack/svelte-query';

	import { departmentApi } from '$lib/api/department';
	import { positionApi } from '$lib/api/position';
	import { CONTRACT_TYPE_OPTIONS, schema, type UserContractFormData } from './schema';
	import { handleFormSubmit } from '../../../utils/form';
	import type { FormHelpers } from '../../../types/form';

	const FULL_TIME_HOURS = 38;

	interface Props {
		userId: number;
		onSubmit: (data: UserContractFormData) => Promise<void>;
	}

	let { userId, onSubmit }: Props = $props();
	let formHelpers = $state<FormHelpers | undefined>(undefined);

	// -------------------------
	// DATA
	// -------------------------
	const departmentsQuery = createQuery(() => ({
		queryKey: ['departments'],
		queryFn: departmentApi.list,
		staleTime: Infinity
	}));

	const positionsQuery = createQuery(() => ({
		queryKey: ['positions'],
		queryFn: positionApi.list,
		staleTime: Infinity
	}));

	// -------------------------
	// FORM
	// -------------------------
	const defaultValues: UserContractFormData = {
		userId,

		departmentId: 0,
		positionId: 0,

		contractType: 'fullTime',

		hoursPerWeek: 38,
		fte: 0,

		rate: 0,

		startDate: '',
		endDate: ''
	};
	const form = superForm<UserContractFormData>(defaultValues, {
		validators: zod4(schema),
		SPA: true,

		onUpdate: async ({ form }) => {
			if (!form.valid) return;

			if (selectedPosition) {
				const { minSalary, maxSalary } = selectedPosition;
				const tooLow = form.data.rate < minSalary;
				const tooHigh = form.data.rate > maxSalary;

				if (tooLow || tooHigh) {
					setError(form, 'rate', `Rate must be between ${minSalary} and ${maxSalary}`);
					return;
				}
			}

			await handleFormSubmit(
				{ ...form.data, fte },
				(field, message) =>
					errors.update((current) => ({
						...current,
						[field]: [message]
					})),
				formHelpers!,
				async (data) => {
					await onSubmit(data);
				}
			);
		}
	});

	const { form: formData, errors, submitting } = form;

	const availablePositions = $derived(
		(positionsQuery.data ?? []).filter((p) => p.departmentId === $formData.departmentId)
	);

	const selectedPosition = $derived(
		(positionsQuery.data ?? []).find((p) => p.id === $formData.positionId)
	);

	const fte = $derived(
		$formData.contractType === 'fullTime'
			? 1
			: Number((($formData.hoursPerWeek ?? 0) / FULL_TIME_HOURS).toFixed(2))
	);

	$effect(() => {
		if (!$formData.positionId) return;

		const stillValid = availablePositions.some((p) => p.id === $formData.positionId);

		if (!stillValid) {
			$formData.positionId = 0;
		}
	});
</script>

<Form {form}>
	<!-- Department + Position -->
	<FormRow>
		<FormGroup label="Department" for="departmentId" error={$errors.departmentId?.[0]}>
			<FormSelect
				name="departmentId"
				bind:value={$formData.departmentId as number}
				options={(departmentsQuery.data ?? []).map((d) => ({
					label: d.name,
					value: d.id
				}))}
			/>
		</FormGroup>

		<FormGroup label="Position" for="positionId" error={$errors.positionId?.[0]}>
			<FormSelect
				name="positionId"
				bind:value={$formData.positionId}
				options={availablePositions.map((p) => ({
					label: p.title,
					value: p.id
				}))}
			/>
		</FormGroup>
	</FormRow>

	<!-- Position helper -->
	{#if selectedPosition}
		<div class="alert alert-info">
			<strong>{selectedPosition.title}</strong>
			<div>
				Salary:
				{selectedPosition.minSalary.toLocaleString()}
				-
				{selectedPosition.maxSalary.toLocaleString()}
			</div>
		</div>
	{/if}

	<!-- Contract type -->
	<FormGroup label="Contract Type">
		<FormRadio
			name="contractType"
			options={[...CONTRACT_TYPE_OPTIONS]}
			bind:value={$formData.contractType}
		/>
	</FormGroup>

	<!-- Hours -->
	{#if $formData.contractType === 'partTime'}
		<FormGroup label="Hours per week">
			<FormInput type="number" bind:value={$formData.hoursPerWeek} />
		</FormGroup>
	{/if}

	<!-- Derived FTE -->
	<FormGroup label="FTE">
		<FormInput type="number" value={fte} disabled />
	</FormGroup>

	<!-- Rate -->
	<FormGroup label="Rate" error={$errors.rate?.[0]}>
		<FormInput type="number" bind:value={$formData.rate} />
	</FormGroup>

	<!-- Dates -->
	<FormRow>
		<FormGroup label="Start date" error={$errors.startDate?.[0]}>
			<FormInput type="date" bind:value={$formData.startDate} />
		</FormGroup>

		<FormGroup label="End date" error={$errors.endDate?.[0]}>
			<FormInput type="date" bind:value={$formData.endDate} />
		</FormGroup>
	</FormRow>

	<Button type="submit" variant="primary" loading={$submitting}>Create Contract</Button>
</Form>
