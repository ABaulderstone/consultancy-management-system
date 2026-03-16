<script lang="ts" generics="T">
	import type { ColumnDef, SortState } from '../../../types/data-table';

	import SortIcon from './SortIcon.svelte';

	interface Props {
		columns: ColumnDef<T>[];
		sortState?: SortState;
		onSort?: (key: string) => void;
	}

	let { columns, sortState, onSort }: Props = $props();

	function getAriaSortValue(col: ColumnDef<T>) {
		if (!col.sortable || sortState?.key !== col.key) return undefined;
		if (sortState.direction === 'asc') return 'ascending';
		if (sortState.direction === 'desc') return 'descending';
		return 'none';
	}
</script>

<thead class="table-light">
	<tr>
		{#each columns as col (col.key)}
			<th
				scope="col"
				class="text-uppercase fw-medium small {col.headerClass ?? ''} {col.sortable
					? 'user-select-none'
					: ''}"
				style={col.sortable ? 'cursor: pointer' : ''}
				aria-sort={getAriaSortValue(col)}
				onclick={col.sortable ? () => onSort?.(col.key) : undefined}
			>
				{col.header}
				{#if col.sortable}
					<SortIcon colKey={col.key} {sortState} />
				{/if}
			</th>
		{/each}
	</tr>
</thead>
