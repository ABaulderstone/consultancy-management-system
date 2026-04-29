<script module lang="ts">
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import ProfitSummaryChart from './ProfitSummaryChart.svelte';
	import {
		mockMonthlyData,
		mockYearlyData,
		mockAllActualData,
		mockAllProjectedData
	} from '../../../mocks/profit-summary';

	const { Story } = defineMeta({
		title: 'Analytics/ProfitSummaryChart',
		component: ProfitSummaryChart,
		tags: ['autodocs'],
		argTypes: {
			view: { control: 'select', options: ['month', 'year'] }
		}
	});
</script>

<Story name="Monthly" args={{ data: mockMonthlyData(), view: 'month' }} />

<Story name="Yearly" args={{ data: mockYearlyData(), view: 'year' }} />

<Story name="All Actual" args={{ data: mockAllActualData(), view: 'month' }} />

<Story name="All Projected" args={{ data: mockAllProjectedData(), view: 'month' }} />

<Story name="Empty" args={{ data: [], view: 'month' }} />
