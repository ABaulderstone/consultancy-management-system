<!-- src/routes/clients/+page.svelte -->
<script lang="ts">
	import { goto } from '$app/navigation';
	import { page } from '$app/state';
	import { createQuery } from '@tanstack/svelte-query';
	import { SvelteURLSearchParams } from 'svelte/reactivity';
	import Button from '../../lib/components/ui/Button';
	import Pagination from '../../lib/components/ui/Pagination';
	import { ClientList } from '../../lib/components/client/ClientList';
	import { clientsApi } from '../../lib/api/client-domain';

	const currentPage = $derived(Number(page.url.searchParams.get('page') ?? 1));
	const limit = $derived(Number(page.url.searchParams.get('limit') ?? 5));

	function updateParams(updates: Record<string, string | null>) {
		const params = new SvelteURLSearchParams(page.url.searchParams);
		Object.entries(updates).forEach(([key, value]) => {
			if (value === null) {
				params.delete(key);
			} else {
				params.set(key, value);
			}
		});
		goto(`?${params}`, { replaceState: false, keepFocus: true, noScroll: true });
	}

	function handlePageChange(newPage: number) {
		const totalPages = clientsQuery.data?.meta.pages ?? 1;
		const safePage = Math.max(1, Math.min(newPage, totalPages));
		updateParams({ page: String(safePage) });
	}

	const clientsQuery = createQuery(() => ({
		queryKey: ['clients', currentPage, limit],
		queryFn: () => clientsApi.list({ page: currentPage, limit })
	}));
</script>

<div class="container py-4">
	<div class="d-flex justify-content-between align-items-center mb-4">
		<h1 class="h3 mb-0">Clients</h1>
		<Button>Add Client</Button>
	</div>

	{#if clientsQuery.isLoading}
		<p class="text-muted">Loading…</p>
	{:else if clientsQuery.isError}
		<p class="text-danger">Something went wrong loading clients.</p>
	{:else}
		{#if clientsQuery.data}
			<Pagination
				currentPage={clientsQuery.data.meta.page}
				totalPages={clientsQuery.data.meta.pages}
				totalCount={clientsQuery.data.meta.count}
				{limit}
				onPageChange={handlePageChange}
			/>
		{/if}

		<ClientList clients={clientsQuery.data?.data ?? []} fetching={clientsQuery.isFetching} />
	{/if}
</div>
