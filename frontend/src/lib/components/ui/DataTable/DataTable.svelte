<script lang="ts" generics="T">
	import type { ColumnDef, SortDirection, SortState } from '../../../types/data-table';

	import TableHeader from './TableHeader.svelte';
	import TableRow from './TableRow.svelte';

	interface DataTableProps {
		columns: ColumnDef<T>[];
		rows: T[];
		emptyState?: string;
		class?: string;
		sortState?: SortState;
		onSort?: (key: string, direction: SortDirection) => void;
	}

	let {
		columns,
		rows,
		emptyState = 'No data to display.',
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
</script>

<div class="table-responsive {className ?? ''}">
	<table class="table table-hover">
		<TableHeader {columns} {sortState} onSort={handleSortClick} />
		<tbody>
			{#if rows.length === 0}
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
