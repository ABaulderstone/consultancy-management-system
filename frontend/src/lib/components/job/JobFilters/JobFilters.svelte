<!-- $lib/components/job/JobFilters.svelte -->
<script lang="ts">
	import FormInput from '../../ui/Form/FormInput.svelte';
	import FormSelect from '../../ui/Form/FormSelect.svelte';

	interface Props {
		search?: string;
		status?: string;
		onSearch: (term: string) => void;
		onStatusChange: (status: string) => void;
	}

	let { search = '', status = '', onSearch, onStatusChange }: Props = $props();

	let searchValue = $state(search ?? '');

	const statusOptions = [
		{ label: 'All statuses', value: '' },
		{ label: 'Open', value: 'open' },
		{ label: 'Assigned', value: 'assigned' },
		{ label: 'Available', value: 'available' },
		{ label: 'Closed', value: 'closed' }
	];

	let debounceTimer: ReturnType<typeof setTimeout>;
	function handleSearchInput(e: Event) {
		const term = (e.target as HTMLInputElement).value;
		searchValue = term;
		clearTimeout(debounceTimer);
		debounceTimer = setTimeout(() => onSearch(term), 300);
	}
</script>

<div class="d-flex gap-2 mb-3">
	<FormInput
		placeholder="Search jobs, clients or people…"
		value={searchValue}
		oninput={handleSearchInput}
	/>
	<FormSelect
		options={statusOptions}
		value={status}
		onchange={(e) => onStatusChange((e.target as HTMLSelectElement).value)}
		class="w-auto"
	/>
</div>
