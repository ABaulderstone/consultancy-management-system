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
	import Avatar from '../../../lib/components/ui/Avatar';
	import Badge from '../../../lib/components/ui/Badge';
	import type { BadgeVariant } from '../../../lib/types/badge';
	import DetailRow from '../../../lib/components/ui/DetailRow';

	const userId = $derived(Number($page.params.id));
	const queryClient = useQueryClient();

	const userQuery = createQuery(() => ({
		queryKey: ['users', userId],
		queryFn: () => usersApi.get(userId)
	}));

	const employmentStatusVariant: Record<string, BadgeVariant> = {
		active: 'success',
		departed: 'secondary',
		uncontracted: 'warning'
	};

	const assignmentStatusVariant: Record<string, BadgeVariant> = {
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
						<Avatar />
						<h5 class="mb-1">{user.firstName} {user.lastName}</h5>
						<p class="text-muted small mb-2">{user.email}</p>

						<div class="d-flex gap-2 flex-wrap justify-content-center">
							<Badge variant={user.role === 'admin' ? 'danger' : 'secondary'}>
								{user.role}
							</Badge>

							<Badge variant={employmentStatusVariant[user.employmentStatus]}>
								{user.employmentStatus}
							</Badge>
							{#if user.assignmentStatus}
								<Badge variant={assignmentStatusVariant[user.assignmentStatus]}>
									{user.assignmentStatus}
								</Badge>
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
								<DetailRow label="Position" value={contract.position.title} />
								<DetailRow label="Department" value={contract.position.department} />
								<DetailRow label="Contract Type" value={contract.contractType.replace('_', ' ')} />
								<DetailRow label="FTE" value={contract.fte} />
								<DetailRow label="Annual Rate" value="${contract.rate.toLocaleString()}" />
								<DetailRow label="Payable Rate" value="${contract.payableRate.toLocaleString()}" />
								<DetailRow label="Daily Cost" value="${contract.dailyCost.toLocaleString()}" />
								<DetailRow label="Start Date" value={contract.startDate} />
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
							{@const marginClass =
								job.dailyMargin > 200
									? 'text-success'
									: job.dailyMargin > 100
										? 'text-warning'
										: 'text-danger'}
							<div class="row g-3">
								<DetailRow label="Title" value={job.title} />
								<DetailRow label="Client" value={job.client} />
								<DetailRow label="Day Rate" value="${job.dayRate.toLocaleString()}" />
								<DetailRow
									label="Daily Margin"
									valueClass={marginClass}
									value="${job.dailyMargin.toLocaleString()}"
								/>
								<DetailRow label="Start Date" value={job.startDate} />
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
