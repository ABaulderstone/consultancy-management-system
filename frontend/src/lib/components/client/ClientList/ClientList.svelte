<script lang="ts">
	import type { EnrichedClient } from '../../../types/client';

	import { EnrichedClientCard } from '../EnrichedClientCard';

	interface Props {
		clients: EnrichedClient[];
		fetching: boolean;
	}

	let { clients, fetching }: Props = $props();
</script>

{#if clients.length === 0}
	<p class="text-muted">No clients found.</p>
{:else}
	<div class="d-flex flex-column gap-3" class:opacity-50={fetching}>
		{#each clients as client (client.id)}
			<EnrichedClientCard {client} />
		{/each}
	</div>
{/if}
