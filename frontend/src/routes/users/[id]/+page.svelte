<script lang="ts">
	import { page } from '$app/stores';
	import { createQuery, useQueryClient } from '@tanstack/svelte-query';
	import { toast } from 'svelte-sonner';
	import { FontAwesomeIcon } from '@fortawesome/svelte-fontawesome';
	import { faUser } from '@fortawesome/free-solid-svg-icons';
	import Card from '$lib/components/ui/Card/Card.svelte';
	import { usersApi } from '../../../lib/api/user';
	import UserForm from '../../../lib/components/user/UserForm/UserForm.svelte';
	import type { UserFormData } from '../../../lib/components/user/UserForm/schema';

	const userId = $derived(Number($page.params.id));
	const queryClient = useQueryClient();

	const userQuery = createQuery(() => ({
		queryKey: ['users', userId],
		queryFn: () => usersApi.get(userId)
	}));

	const employmentStatusVariant: Record<string, string> = {
		active: 'success',
		departed: 'secondary',
		uncontracted: 'warning'
	};

	const assignmentStatusVariant: Record<string, string> = {
		assigned: 'primary',
		bench: 'warning'
	};

	async function handleUpdate(data: UserFormData) {
		console.log('Inside handle update');
		await usersApi.update(userId, data);
		queryClient.invalidateQueries({ queryKey: ['users', userId] });
		toast.success('User updated');
	}
</script>

{#if userQuery.isLoading}
	<div class="min-vh-100 d-flex align-items-center justify-content-center">
		<div class="spinner-border" role="status"></div>
	</div>
{:else if userQuery.isError}
	<div class="container py-4">
		<div class="alert alert-danger">Failed to load user</div>
	</div>
{:else if userQuery.data}
	{@const user = userQuery.data}
	<div class="container py-4">
		<div class="d-flex align-items-center gap-2 mb-4">
			<a href="/users" class="btn btn-outline-secondary btn-sm">← Back</a>
			<h1 class="h3 mb-0">{user.firstName} {user.lastName}</h1>
		</div>

		<div class="row g-4">
			<div class="col-lg-4">
				<Card>
					<div class="d-flex flex-column align-items-center text-center mb-4">
						<div
							class="rounded-circle bg-secondary d-flex align-items-center justify-content-center mb-3"
							style="width: 80px; height: 80px;"
						>
							<FontAwesomeIcon icon={faUser} class="text-white fa-2x" />
						</div>
						<h5 class="mb-1">{user.firstName} {user.lastName}</h5>
						<p class="text-muted small mb-2">{user.email}</p>
						<div class="d-flex gap-2 flex-wrap justify-content-center">
							<span class="badge bg-{user.role === 'admin' ? 'danger' : 'secondary'}">
								{user.role}
							</span>
							<span class="badge bg-{employmentStatusVariant[user.employmentStatus]}">
								{user.employmentStatus}
							</span>
							{#if user.assignmentStatus}
								<span class="badge bg-{assignmentStatusVariant[user.assignmentStatus]}">
									{user.assignmentStatus}
								</span>
							{/if}
						</div>
					</div>

					<hr />

					<UserForm mode="edit" {user} onSubmit={handleUpdate} />
				</Card>
			</div>

			<div class="col-lg-8">
				<div class="d-flex flex-column gap-4">
					<Card title="Current Contract">
						{#if user.currentContract}
							{@const contract = user.currentContract}
							<div class="row g-3">
								<div class="col-sm-6">
									<p class="text-muted small mb-1">Position</p>
									<p class="mb-0 fw-medium">{contract.position.title}</p>
								</div>
								<div class="col-sm-6">
									<p class="text-muted small mb-1">Department</p>
									<p class="mb-0 fw-medium">{contract.position.department}</p>
								</div>
								<div class="col-sm-6">
									<p class="text-muted small mb-1">Contract Type</p>
									<p class="mb-0 fw-medium">{contract.contractType.replace('_', ' ')}</p>
								</div>
								<div class="col-sm-6">
									<p class="text-muted small mb-1">FTE</p>
									<p class="mb-0 fw-medium">{contract.fte ?? '—'}</p>
								</div>
								<div class="col-sm-6">
									<p class="text-muted small mb-1">Annual Rate</p>
									<p class="mb-0 fw-medium">${contract.rate.toLocaleString()}</p>
								</div>
								<div class="col-sm-6">
									<p class="text-muted small mb-1">Payable Rate</p>
									<p class="mb-0 fw-medium">${contract.payableRate.toLocaleString()}</p>
								</div>
								<div class="col-sm-6">
									<p class="text-muted small mb-1">Daily Cost</p>
									<p class="mb-0 fw-medium">${contract.dailyCost.toLocaleString()}</p>
								</div>
								<div class="col-sm-6">
									<p class="text-muted small mb-1">Start Date</p>
									<p class="mb-0 fw-medium">{contract.startDate}</p>
								</div>
							</div>
						{:else}
							<p class="text-muted mb-0">No active contract</p>
						{/if}
					</Card>

					<Card>
						{#snippet header()}
							<span>Current Job</span>
							{#if user.lifetimeUtilisation !== undefined}
								<span class="text-muted small fw-normal">
									Lifetime utilisation: <strong>{user.lifetimeUtilisation}%</strong>
								</span>
							{/if}
						{/snippet}

						{#if user.currentJob}
							{@const job = user.currentJob}
							<div class="row g-3">
								<div class="col-sm-6">
									<p class="text-muted small mb-1">Title</p>
									<p class="mb-0 fw-medium">{job.title}</p>
								</div>
								<div class="col-sm-6">
									<p class="text-muted small mb-1">Client</p>
									<p class="mb-0 fw-medium">{job.client}</p>
								</div>
								<div class="col-sm-6">
									<p class="text-muted small mb-1">Day Rate</p>
									<p class="mb-0 fw-medium">${job.dayRate.toLocaleString()}</p>
								</div>
								<div class="col-sm-6">
									<p class="text-muted small mb-1">Daily Margin</p>
									<p class="mb-0 fw-medium text-success">${job.dailyMargin.toLocaleString()}</p>
								</div>
								<div class="col-sm-6">
									<p class="text-muted small mb-1">Start Date</p>
									<p class="mb-0 fw-medium">{job.startDate}</p>
								</div>
							</div>
						{:else}
							<p class="text-muted mb-0">
								{user.employmentStatus === 'active' ? 'Currently on bench' : 'No active job'}
							</p>
						{/if}
					</Card>
				</div>
			</div>
		</div>
	</div>
{/if}
