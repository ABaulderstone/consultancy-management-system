<script module lang="ts">
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import DataTable from './DataTable.svelte';

	type Product = {
		id: number;
		name: string;
		category: string;
		price: number;
		stock: number;
	};

	const mockData: Product[] = [
		{ id: 1, name: 'Widget A', category: 'Widgets', price: 9.99, stock: 100 }
	];

	const { Story } = defineMeta({
		title: 'UI/DataTable',
		component: DataTable
	});
</script>

{#snippet nameCell(item: Product)}
	{item.name}
{/snippet}

{#snippet categoryCell(item: Product)}
	{item.category}
{/snippet}

{#snippet priceCell(item: Product)}
	${item.price.toFixed(2)}
{/snippet}

{#snippet stockCell(item: Product)}
	<span class="badge bg-{item.stock < 50 ? 'warning' : 'success'}">
		{item.stock}
	</span>
{/snippet}

<Story
	name="Default"
	args={{
		rows: mockData,
		columns: [
			{ key: 'name', header: 'Name', cell: nameCell, sortable: true },
			{ key: 'category', header: 'Category', cell: categoryCell, sortable: true },
			{ key: 'price', header: 'Price', cell: priceCell, sortable: true },
			{ key: 'stock', header: 'Stock', cell: stockCell }
		]
	}}
/>

<Story
	name="Sorted Ascending"
	args={{
		rows: mockData,
		sortState: { key: 'name', direction: 'asc' },
		columns: [
			{ key: 'name', header: 'Name', cell: nameCell, sortable: true },
			{ key: 'category', header: 'Category', cell: categoryCell, sortable: true },
			{ key: 'price', header: 'Price', cell: priceCell, sortable: true },
			{ key: 'stock', header: 'Stock', cell: stockCell }
		]
	}}
/>

<Story
	name="Sorted Descending"
	args={{
		rows: mockData,
		sortState: { key: 'name', direction: 'desc' },
		columns: [
			{ key: 'name', header: 'Name', cell: nameCell, sortable: true },
			{ key: 'category', header: 'Category', cell: categoryCell, sortable: true },
			{ key: 'price', header: 'Price', cell: priceCell, sortable: true },
			{ key: 'stock', header: 'Stock', cell: stockCell }
		]
	}}
/>

<Story
	name="Loading"
	args={{
		rows: [],
		loading: true,
		columns: [
			{ key: 'name', header: 'Name', cell: nameCell, sortable: true },
			{ key: 'category', header: 'Category', cell: categoryCell, sortable: true },
			{ key: 'price', header: 'Price', cell: priceCell, sortable: true },
			{ key: 'stock', header: 'Stock', cell: stockCell }
		]
	}}
/>

<Story
	name="Fetching"
	args={{
		rows: mockData,
		fetching: true,
		columns: [
			{ key: 'name', header: 'Name', cell: nameCell, sortable: true },
			{ key: 'category', header: 'Category', cell: categoryCell, sortable: true },
			{ key: 'price', header: 'Price', cell: priceCell, sortable: true },
			{ key: 'stock', header: 'Stock', cell: stockCell }
		]
	}}
/>

<Story
	name="Empty"
	args={{
		rows: [],
		columns: [
			{ key: 'name', header: 'Name', cell: nameCell, sortable: true },
			{ key: 'category', header: 'Category', cell: categoryCell, sortable: true },
			{ key: 'price', header: 'Price', cell: priceCell, sortable: true },
			{ key: 'stock', header: 'Stock', cell: stockCell }
		]
	}}
/>

<Story
	name="Error"
	args={{
		rows: [],
		error: true,
		columns: [
			{ key: 'name', header: 'Name', cell: nameCell, sortable: true },
			{ key: 'category', header: 'Category', cell: categoryCell, sortable: true },
			{ key: 'price', header: 'Price', cell: priceCell, sortable: true },
			{ key: 'stock', header: 'Stock', cell: stockCell }
		]
	}}
/>

<Story
	name="With Links"
	args={{
		rows: mockData,
		columns: [
			{
				key: 'name',
				header: 'Name',
				cell: nameCell,
				sortable: true,
				href: (item: Product) => `/products/${item.id}`
			},
			{ key: 'category', header: 'Category', cell: categoryCell, sortable: true },
			{ key: 'price', header: 'Price', cell: priceCell, sortable: true },
			{ key: 'stock', header: 'Stock', cell: stockCell }
		]
	}}
/>

<Story
	name="With External Links"
	args={{
		rows: mockData,
		columns: [
			{
				key: 'name',
				header: 'Name',
				cell: nameCell,
				sortable: true,
				href: (item: Product) => `https://example.com/products/${item.id}`
			},
			{ key: 'category', header: 'Category', cell: categoryCell, sortable: true },
			{ key: 'price', header: 'Price', cell: priceCell, sortable: true },
			{ key: 'stock', header: 'Stock', cell: stockCell }
		]
	}}
/>
