<script lang="ts">
	import { DataTable } from '$lib/components/ui/DataTable';
	import type { User } from '$lib/types/user';
	import { FontAwesomeIcon } from '@fortawesome/svelte-fontawesome';
	import type { ColumnDef, SortDirection, SortState } from '../../../types/data-table';
	import { faUser } from '@fortawesome/free-solid-svg-icons';
	import Badge from '../../ui/Badge';

	interface UserTableProps {
		users: User[];
		sortState?: SortState;
		onSort?: (key: string, direction: SortDirection) => void;
		loading?: boolean;
		fetching?: boolean;
		error?: boolean;
	}

	let { users, sortState, onSort, loading, fetching, error }: UserTableProps = $props();

	const columns: ColumnDef<User>[] = [
		{ key: 'profile', header: '', cell: profileCell, href: (user) => '/users/' + user.slug },
		{ key: 'firstName', header: 'First Name', cell: firstNameCell, sortable: true },
		{ key: 'lastName', header: 'Last Name', cell: lastNameCell, sortable: true },
		{ key: 'email', header: 'Email', cell: emailCell, sortable: true },
		{ key: 'role', header: 'Role', cell: roleCell }
	];
</script>

{#snippet profileCell(user: User)}
	<FontAwesomeIcon icon={faUser} />
{/snippet}

{#snippet firstNameCell(user: User)}
	{user.firstName}
{/snippet}

{#snippet lastNameCell(user: User)}
	{user.lastName}
{/snippet}

{#snippet emailCell(user: User)}
	{user.email}
{/snippet}

{#snippet roleCell(user: User)}
	<Badge variant={user.role === 'admin' ? 'danger' : 'secondary'}>
		{user.role}
	</Badge>
{/snippet}

<DataTable {columns} rows={users} {sortState} {onSort} {loading} {fetching} {error} />
