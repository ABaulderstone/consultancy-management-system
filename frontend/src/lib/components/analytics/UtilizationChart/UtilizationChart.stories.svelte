<script module lang="ts">
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import UtilizationChart from './UtilizationChart.svelte';
	import {
		mockMonthlyUtilization,
		mockYearlyUtilization,
		mockAllActualUtilization,
		mockAllProjectedUtilization
	} from '../../../mocks/utilization-report';

	const { Story } = defineMeta({
		title: 'Analytics/UtilizationChart',
		component: UtilizationChart,
		tags: ['autodocs'],
		argTypes: {
			view: { control: 'select', options: ['month', 'year'] }
		}
	});
</script>

<Story name="Monthly" args={{ data: mockMonthlyUtilization(), view: 'month' }} />

<Story name="Yearly" args={{ data: mockYearlyUtilization(), view: 'year' }} />

<Story name="All Actual" args={{ data: mockAllActualUtilization(), view: 'month' }} />

<Story name="All Projected" args={{ data: mockAllProjectedUtilization(), view: 'month' }} />

<Story name="Empty" args={{ data: [], view: 'month' }} />
