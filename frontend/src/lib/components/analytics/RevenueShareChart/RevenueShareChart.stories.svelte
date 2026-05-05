<script module lang="ts">
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import RevenueShareChart from './RevenueShareChart.svelte';
	import {
		mockBalanced,
		mockConcentrated,
		mockSingleClient,
		mockManySmall,
		mockWithOther,
		mockEmpty
	} from '../../../mocks/revenue-share';

	const { Story } = defineMeta({
		title: 'Analytics/RevenueShareChart',
		component: RevenueShareChart,
		tags: ['autodocs']
	});
</script>

<Story name="Balanced" args={{ data: mockBalanced() }} />

<Story name="Highly Concentrated" args={{ data: mockConcentrated() }} />

<Story name="Single Client" args={{ data: mockSingleClient() }} />

<Story name="Many Small Clients" args={{ data: mockManySmall() }} />

<Story name="With Other Bucket" args={{ data: mockWithOther() }} />

<Story name="Empty" args={{ data: mockEmpty() }} />
