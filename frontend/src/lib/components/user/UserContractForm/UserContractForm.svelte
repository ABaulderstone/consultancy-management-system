<script lang="ts">
	import { superForm } from 'sveltekit-superforms';
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
	import { CONTRACT_TYPE_OPTIONS, schema, type ContractFormData } from './schema';

	type ContractFormState = {
		userId: number;
		departmentId?: number;
		positionId?: number;
		contractType: 'fullTime' | 'partTime';
		hoursPerWeek: number;
		rate?: number;
		startDate: string;
		endDate?: string;
	};
	const FULL_TIME_HOURS = 38;

	interface Props {
		userId: number;
		onSubmit: (data: ContractFormData) => Promise<void>;
	}

	let { userId, onSubmit }: Props = $props();

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
	const form = superForm<ContractFormState>(
		{
			userId,
			departmentId: undefined,
			positionId: undefined,
			contractType: 'fullTime',
			hoursPerWeek: 38,
			rate: undefined,
			startDate: '',
			endDate: ''
		},
		{
			validators: zod4(schema),
			SPA: true
		}
	);

	const { form: formData, errors, submitting } = form;

	// -------------------------
	// DERIVED DATA
	// -------------------------
	const availablePositions = $derived(
		(positionsQuery.data ?? []).filter((p) => p.departmentId === $formData.departmentId)
	);

	const selectedPosition = $derived(
		(positionsQuery.data ?? []).find((p) => p.id === $formData.positionId)
	);

	const fte = $derived(
		$formData.contractType === 'fullTime' ? 1 : ($formData.hoursPerWeek ?? 0) / FULL_TIME_HOURS
	);
	// -------------------------
	// SAFE RESET: position invalidation
	// -------------------------
	$effect(() => {
		if (!$formData.positionId) return;

		const stillValid = availablePositions.some((p) => p.id === $formData.positionId);

		if (!stillValid) {
			$formData.positionId = undefined;
		}
	});

	// -------------------------
	// HANDLER
	// -------------------------
	async function submit() {
		if (selectedPosition && $formData.rate) {
			const tooLow = $formData.rate < selectedPosition.minSalary;

			const tooHigh = $formData.rate > selectedPosition.maxSalary;

			if (tooLow || tooHigh) {
				errors.update((e) => ({
					...e,
					rate: [
						`Rate must be between ${selectedPosition.minSalary} and ${selectedPosition.maxSalary}`
					]
				}));
				return;
			}
		}

		const parsed = schema.safeParse({
			...$formData,
			fte
		});

		if (!parsed.success) {
			console.log(parsed.error.flatten());
			return;
		}

		await onSubmit(parsed.data);
	}
</script>

<Form {form}>
	<!-- Department + Position -->
	<FormRow>
		<FormGroup label="Department" for="departmentId">
			<FormSelect
				name="departmentId"
				bind:value={$formData.departmentId}
				options={(departmentsQuery.data ?? []).map((d) => ({
					label: d.name,
					value: d.id
				}))}
			/>
		</FormGroup>

		<FormGroup label="Position" for="positionId">
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
		<FormGroup label="Start date">
			<FormInput type="date" bind:value={$formData.startDate} />
		</FormGroup>

		<FormGroup label="End date">
			<FormInput type="date" bind:value={$formData.endDate} />
		</FormGroup>
	</FormRow>

	<!-- Submit -->
	<Button type="button" variant="primary" onclick={submit} loading={$submitting}>
		Create Contract
	</Button>
</Form>
