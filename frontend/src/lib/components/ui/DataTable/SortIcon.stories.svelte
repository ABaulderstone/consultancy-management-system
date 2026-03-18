<script module>
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import SortIcon from './SortIcon.svelte';

	const { Story } = defineMeta({
		title: 'UI/DataTable/SortIcon',
		component: SortIcon,
		tags: ['autodocs'],
		argTypes: {
			colKey: { control: 'text' }
		}
	});
</script>

<Story name="Unsorted" args={{ colKey: 'name' }} />

<Story name="Ascending" args={{ colKey: 'name', sortState: { key: 'name', direction: 'asc' } }} />

<Story name="Descending" args={{ colKey: 'name', sortState: { key: 'name', direction: 'desc' } }} />

<Story
	name="Different Column"
	args={{ colKey: 'name', sortState: { key: 'email', direction: 'asc' } }}
/>
