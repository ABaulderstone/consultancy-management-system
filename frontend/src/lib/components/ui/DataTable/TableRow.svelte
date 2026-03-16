<script lang="ts" generics="T">
	import type { ColumnDef } from '../../../types/data-table';
	import TableCell from './TableCell.svelte';

	interface TableCellProps {
		row: T;
		columns: ColumnDef<T>[];
		idx: number;
	}

	let { row, columns, idx }: TableCellProps = $props();
</script>

<tr class={idx % 2 === 0 ? '' : 'table-light'}>
	{#each columns as col (col.key)}
		<TableCell href={col.href?.(row)} class={col.cellClass}>
			{@render col.cell(row)}
		</TableCell>
	{/each}
</tr>
