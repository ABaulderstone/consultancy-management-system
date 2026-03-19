<script module lang="ts">
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import Pagination from './Pagination.svelte';
	import { fn } from 'storybook/test';

	const { Story } = defineMeta({
		title: 'UI/Pagination',
		component: Pagination,
		tags: ['autodocs'],
		argTypes: {
			currentPage: { control: 'number' },
			totalPages: { control: 'number' },
			totalCount: { control: 'number' },
			limit: { control: 'number' }
		},
		args: {
			onPagechange: fn()
		}
	});
</script>

<Story name="One Page" args={{ currentPage: 1, totalPages: 1, totalCount: 5, limit: 5 }} />

<Story name="Six Pages" args={{ currentPage: 3, totalPages: 6, totalCount: 30, limit: 5 }} />

<Story name="Last Page" args={{ currentPage: 7, totalPages: 7, totalCount: 35, limit: 5 }} />

<Story
	name="Twenty Pages Start"
	args={{ currentPage: 1, totalPages: 20, totalCount: 100, limit: 5 }}
/>

<Story
	name="Twenty Pages End"
	args={{ currentPage: 20, totalPages: 20, totalCount: 100, limit: 5 }}
/>

<Story
	name="Twenty Pages Middle"
	args={{ currentPage: 10, totalPages: 20, totalCount: 100, limit: 5 }}
/>
