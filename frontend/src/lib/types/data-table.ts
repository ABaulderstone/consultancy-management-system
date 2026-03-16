import type { Snippet } from 'svelte';

export type SortDirection = 'asc' | 'desc' | null;

export interface SortState {
	key: string;
	direction: SortDirection;
}

export interface ColumnDef<T> {
	key: string;
	header: string;
	cell: Snippet<[T]>;
	headerClass?: string;
	cellClass?: string;
	href?: (row: T) => string;
	sortable?: boolean;
}
