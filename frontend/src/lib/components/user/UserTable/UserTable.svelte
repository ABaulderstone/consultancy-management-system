<script lang="ts">
	import { DataTable } from '$lib/components/ui/DataTable';
	import type { EnrichedUser } from '$lib/types/user';
	import type { ColumnDef, SortDirection, SortState } from '../../../types/data-table';

	interface UserTableProps {
		users: EnrichedUser[];
		sortState?: SortState;
		onSort?: (key: string, direction: SortDirection) => void;
		loading?: boolean;
		fetching?: boolean;
		error?: boolean;
	}

	let { users, sortState, onSort, loading, fetching, error }: UserTableProps = $props();

	const columns: ColumnDef<EnrichedUser>[] = [
		{ key: 'firstName', header: 'First Name', cell: firstNameCell, sortable: true },
		{ key: 'lastName', header: 'Last Name', cell: lastNameCell, sortable: true },
		{ key: 'email', header: 'Email', cell: emailCell, sortable: true },
		{ key: 'role', header: 'Role', cell: roleCell }
	];
</script>

{#snippet firstNameCell(user: EnrichedUser)}
	{user.firstName}
{/snippet}

{#snippet lastNameCell(user: EnrichedUser)}
	{user.lastName}
{/snippet}

{#snippet emailCell(user: EnrichedUser)}
	{user.email}
{/snippet}

{#snippet roleCell(user: EnrichedUser)}
	<span class="badge bg-{user.role === 'admin' ? 'danger' : 'secondary'}">
		{user.role}
	</span>
{/snippet}

<DataTable {columns} rows={users} {sortState} {onSort} {loading} {fetching} {error} />
