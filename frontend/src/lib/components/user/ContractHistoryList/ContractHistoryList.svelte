<script lang="ts">
	import Badge from '$lib/components/ui/Badge/Badge.svelte';
	import type { ContractHistory } from '../../../types/contract';
	import { dateRange} from '../../../utils/date';
	import { Timeline, TimelineChip, TimelineItem } from '../../ui/Timeline';

	interface Props {
		contracts: ContractHistory[];
	}

	let { contracts }: Props = $props();

	const contractTypeLabel: Record<ContractHistory['contractType'], string> = {
		full_time: 'Full Time',
		part_time: 'Part Time',
		contractor: 'Contractor'
	};

	const contractTypeVariant = {
		full_time: 'primary',
		part_time: 'warning',
		contractor: 'secondary'
	} as const;



</script>

<Timeline empty={contracts.length === 0} emptyMessage="No contract history">
	{#each contracts as contract (contract.id)}
		<TimelineItem
			primary={contract.position.title}
			secondary={contract.position.department}
			dateRange={dateRange(contract)}
			active={!contract.endDate}
		>
			{#snippet aside()}
				<Badge variant={contractTypeVariant[contract.contractType]} size="sm">
					{contractTypeLabel[contract.contractType]}
				</Badge>
				{#if !contract.endDate}
					<Badge variant="success" size="sm">Current</Badge>
				{/if}
			{/snippet}

			{#snippet details()}
				<TimelineChip label="Annual rate" value="${contract.rate.toLocaleString()}/yr" />
				{#if contract.fte !== null}
					<TimelineChip label="FTE" value="{(contract.fte * 100).toFixed(0)}% FTE" />
				{/if}
				<TimelineChip label="Payable rate" value="${contract.payableRate.toLocaleString()}/yr" />
				<TimelineChip label="Daily cost" value="${contract.dailyCost.toLocaleString()}/day" />
			{/snippet}
		</TimelineItem>
	{/each}
</Timeline>