<script lang="ts">
	import { ProfitSummaryChart } from '../../../lib/components/analytics/ProfitSumaryChart';
	import { Widget } from '../../../lib/components/ui/Widget';
	import { mockYearlyData } from '../../../lib/mocks/profit-summary';
</script>

<main>
	<div class="container py-4">
		<!-- <div class="d-flex justify-content-between align-items-center mb-4">
		<h1 class="h3 mb-0">Dashboard</h1>
		<PeriodControls
			view={dashboardStore.view}
			label={dashboardStore.label}
			onPrevious={dashboardStore.previous}
			onNext={dashboardStore.next}
			onViewChange={dashboardStore.setView}
		/>
	</div> -->

		<div class="row g-4">
			<div class="col-lg-6">
				<Widget title="Profit Summary">
					<ProfitSummaryChart data={mockYearlyData()} view={'year'} />
				</Widget>
			</div>
		</div>
	</div>
</main>
