<script lang="ts">
	interface PaginationProps {
		currentPage: number;
		totalPages: number;
		totalCount: number;
		limit: number;
		onPageChange: (page: number) => void;
	}

	let { currentPage, totalPages, totalCount, limit, onPageChange }: PaginationProps = $props();

	const start = $derived((currentPage - 1) * limit + 1);
	const end = $derived(Math.min(currentPage * limit, totalCount));

	const pages = $derived.by(() => {
		if (totalPages <= 7) {
			return Array.from({ length: totalPages }, (_, i) => i + 1);
		}

		const result: (number | '...')[] = [1];

		if (currentPage > 3) result.push('...');

		const rangeStart = Math.max(2, currentPage - 1);
		const rangeEnd = Math.min(totalPages - 1, currentPage + 1);

		for (let i = rangeStart; i <= rangeEnd; i++) {
			result.push(i);
		}

		if (currentPage < totalPages - 2) result.push('...');

		result.push(totalPages);

		return result;
	});
</script>

<div class="d-flex justify-content-between align-items-center mt-3">
	<span class="text-muted small">
		Showing {start}–{end} of {totalCount}
	</span>

	<nav aria-label="Page navigation">
		<ul class="pagination pagination-sm mb-0">
			<li class="page-item {currentPage === 1 ? 'disabled' : ''}">
				<button class="page-link" onclick={() => onPageChange(currentPage - 1)}> Previous </button>
			</li>

			{#each pages as page, idx (idx)}
				{#if page === '...'}
					<li class="page-item disabled">
						<span class="page-link">…</span>
					</li>
				{:else}
					<li class="page-item {page === currentPage ? 'active' : ''}">
						<button class="page-link" onclick={() => onPageChange(page)}>
							{page}
						</button>
					</li>
				{/if}
			{/each}

			<li class="page-item {currentPage >= totalPages ? 'disabled' : ''}">
				<button class="page-link" onclick={() => onPageChange(currentPage + 1)}> Next </button>
			</li>
		</ul>
	</nav>
</div>
