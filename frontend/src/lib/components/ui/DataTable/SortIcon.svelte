<script lang="ts">
	import { FontAwesomeIcon } from '@fortawesome/svelte-fontawesome';
	import { faSort, faSortUp, faSortDown } from '@fortawesome/free-solid-svg-icons';
	import type { SortState } from '../../../types/data-table';

	interface SortIconProps {
		colKey: string;
		sortState?: SortState;
	}

	let { colKey, sortState }: SortIconProps = $props();

	const icon = $derived(
		sortState?.key !== colKey || sortState.direction === null
			? faSort
			: sortState.direction === 'asc'
				? faSortUp
				: faSortDown
	);
</script>

<span class="ms-1 small">
	<FontAwesomeIcon {icon} />
</span>
