<script lang="ts" generics="T">
	import { FontAwesomeIcon } from '@fortawesome/svelte-fontawesome';
	import type { ColumnDef, SortDirection, SortState } from '../../../types/data-table';

	import TableHeader from './TableHeader.svelte';
	import TableRow from './TableRow.svelte';
	import { faCircleExclamation } from '@fortawesome/free-solid-svg-icons';

	interface DataTableProps {
		columns: ColumnDef<T>[];
		rows: T[];
		emptyState?: string;
		errorState?: string;
		sortState?: SortState;
		class?: string;
		loading?: boolean;
		fetching?: boolean;
		error?: boolean;
		onSort?: (key: string, direction: SortDirection) => void;
	}

	let {
		columns,
		rows,
		emptyState = 'No data to display.',
		errorState = 'Something went wrong.',
		loading,
		fetching,
		error,
		class: className,
		sortState,
		onSort
	}: DataTableProps = $props();

	function handleSortClick(key: string) {
		if (!onSort) return;
		const current = sortState?.key === key ? sortState.direction : null;
		const next: SortDirection = current === null ? 'asc' : current === 'asc' ? 'desc' : null;
		onSort(key, next);
	}
	$effect(() => {
		console.log('sortState in TableHeader', sortState);
	});
</script>

<div class="table-responsive position-relative {className ?? ''}">
	{#if fetching && !loading && !error}
		<div
			class="position-absolute top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center"
			style="background: rgba(255,255,255,0.6); z-index: 10;"
		>
			<div class="spinner-border text-secondary" role="status"></div>
		</div>
	{/if}
	<table class="table table-hover">
		<TableHeader {columns} {sortState} onSort={handleSortClick} />
		<tbody>
			{#if loading}
				<tr>
					<td colspan={columns.length} class="text-center py-5">
						<div class="spinner-border text-secondary" role="status"></div>
					</td>
				</tr>
			{:else if error}
				<tr>
					<td colspan={columns.length} class="text-center py-4">
						<div class="text-danger">
							<FontAwesomeIcon icon={faCircleExclamation} class="me-2" />
							{errorState}
						</div>
					</td>
				</tr>
			{:else if rows.length === 0}
				<tr>
					<td colspan={columns.length} class="text-center text-muted py-4">
						{emptyState}
					</td>
				</tr>
			{:else}
				{#each rows as row, idx (idx)}
					<TableRow {row} {columns} {idx} />
				{/each}
			{/if}
		</tbody>
	</table>
</div>
