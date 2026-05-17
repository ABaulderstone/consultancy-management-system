<script lang="ts">
	import { FontAwesomeIcon } from '@fortawesome/svelte-fontawesome';
	import {
		faBriefcase,
		faUserCheck,
		faDoorOpen,
		faLock,
		faCoins,
		faChartLine,
		faCalendar
	} from '@fortawesome/free-solid-svg-icons';
	import type { EnrichedClient } from '../../../types/client';
	import Card from '../../ui/Card';
	import { formatDate } from '../../../utils/date';
	import { formatCurrency } from '../../../utils/currency';

	interface EnrichedClientCardProps {
		client: EnrichedClient;
	}

	let { client }: EnrichedClientCardProps = $props();
</script>

<Card>
	{#snippet header()}
		<div class="d-flex justify-content-between align-items-center w-100">
			<span>{client.name}</span>
			<span class="text-muted small">
				<FontAwesomeIcon icon={faBriefcase} class="me-1" />
				{client.jobsCount} job{client.jobsCount !== 1 ? 's' : ''}
			</span>
		</div>
	{/snippet}

	<div class="row g-3">
		<div class="col-12">
			<div class="d-flex gap-4">
				<div class="text-muted small">
					<FontAwesomeIcon icon={faUserCheck} class="me-1 text-primary" />
					<span>{client.jobBreakdown.assigned} assigned</span>
				</div>
				<div class="text-muted small">
					<FontAwesomeIcon icon={faDoorOpen} class="me-1 text-success" />
					<span>{client.jobBreakdown.open} open</span>
				</div>
				<div class="text-muted small">
					<FontAwesomeIcon icon={faLock} class="me-1 text-secondary" />
					<span>{client.jobBreakdown.closed} closed</span>
				</div>
			</div>
		</div>

		<div class="col-12">
			<hr class="my-0" />
		</div>

		<div class="col-6">
			<div class="text-muted small mb-1">
				<FontAwesomeIcon icon={faCoins} class="me-1" />
				Est. revenue
			</div>
			<div class="fw-semibold">{formatCurrency(client.totalRevenue)}</div>
		</div>

		<div class="col-6">
			<div class="text-muted small mb-1">
				<FontAwesomeIcon icon={faChartLine} class="me-1" />
				Avg. day rate
			</div>
			<div class="fw-semibold">{formatCurrency(client.averageDayRate)}</div>
		</div>

		<div class="col-12">
			<div class="text-muted small">
				<FontAwesomeIcon icon={faCalendar} class="me-1" />
				Client since {formatDate(client.firstJobDate)}
			</div>
		</div>
	</div>
</Card>
