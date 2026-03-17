<script lang="ts">
	import { goto } from '$app/navigation';
	import { page } from '$app/stores';
	import { createQuery } from '@tanstack/svelte-query';
	import type { SortDirection, SortState } from '../../lib/types/data-table';
	import { SvelteURLSearchParams } from 'svelte/reactivity';
	import { usersApi } from '$lib/api';
	import UserTable from '$lib/components/user/UserTable';
	import Pagination from '$lib/components/ui/Pagination';
	import Button from '../../lib/components/ui/Button';

	const currentPage = $derived(Number($page.url.searchParams.get('page') ?? 1));

	const limit = $derived(Number($page.url.searchParams.get('limit') ?? 20));
	const sortKey = $derived($page.url.searchParams.get('sort') ?? undefined);
	const sortDir = $derived(($page.url.searchParams.get('direction') ?? undefined) as SortDirection);
	const sortState = $derived<SortState | undefined>(
		sortKey && sortDir ? { key: sortKey, direction: sortDir } : undefined
	);

	function updateParams(updates: Record<string, string | null>) {
		const params = new SvelteURLSearchParams($page.url.searchParams);
		Object.entries(updates).forEach(([key, value]) => {
			if (value === null) {
				params.delete(key);
			} else {
				params.set(key, value);
			}
		});
		goto(`?${params}`, { replaceState: false, keepFocus: true, noScroll: true });
	}

	function handleSort(key: string, direction: SortDirection) {
		if (direction === null) {
			updateParams({ sort: null, direction: null, page: '1' });
		} else {
			updateParams({ sort: key, direction, page: '1' });
		}
	}

	function handlePageChange(newPage: number) {
		const totalPages = usersQuery.data?.meta.pages ?? 1;
		const safePage = Math.max(1, Math.min(newPage, totalPages));
		updateParams({ page: String(safePage) });
	}

	const usersQuery = createQuery(() => ({
		queryKey: ['users', currentPage, limit, sortKey, sortDir],
		queryFn: () => usersApi.list(currentPage, limit, sortKey, sortDir)
	}));
	$effect(() => {
		console.log('sortState on page', sortState);
		console.log('sortKey from url', sortKey);
		console.log('sortDir from url', sortDir);
	});
</script>

<div class="container py-4">
	<div class="d-flex justify-content-between align-items-center mb-4">
		<h1 class="h3 mb-0">Users</h1>
		<Button>Add User</Button>
	</div>

	<UserTable
		users={usersQuery.data?.data ?? []}
		loading={usersQuery.isLoading}
		fetching={usersQuery.isFetching}
		error={usersQuery.isError}
		{sortState}
		onSort={handleSort}
	/>
	{#if usersQuery.data}
		<Pagination
			currentPage={usersQuery.data.meta.page}
			totalPages={usersQuery.data.meta.pages}
			totalCount={usersQuery.data.meta.count}
			{limit}
			onPageChange={handlePageChange}
		/>
	{/if}
</div>
