<script module lang="ts">
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import Widget from './Widget.svelte';

	const { Story } = defineMeta({
		title: 'UI/Widget',
		component: Widget,
		tags: ['autodocs'],
		argTypes: {
			isLoading: { control: 'boolean' },
			isFetching: { control: 'boolean' },
			isError: { control: 'boolean' }
		}
	});
</script>

<!-- Header actions -->
{#snippet headerActions()}
	<button class="btn btn-sm btn-outline-secondary"> View all </button>
{/snippet}

<!-- Default content -->
{#snippet revenueContent()}
	<div class="fs-4 fw-semibold">$12,340</div>
{/snippet}

{#snippet usersContent()}
	<div class="fs-4 fw-semibold">1,245</div>
{/snippet}

{#snippet emptyContent()}
	<div class="text-muted">No data available</div>
{/snippet}

<!-- ✅ Default -->
<Story name="Default" args={{ title: 'Revenue', children: revenueContent }} />

<!-- 🔄 Loading -->
<Story name="Loading" args={{ title: 'Revenue', isLoading: true }} />

<!-- ⚠️ Error -->
<Story name="Error" args={{ title: 'Revenue', isError: true }} />

<!-- 🔁 Fetching -->
<Story
	name="Fetching"
	args={{
		title: 'Revenue',
		isFetching: true,
		children: revenueContent
	}}
/>

<!-- 🧩 With Header Actions -->
<Story
	name="With Header Actions"
	args={{
		title: 'Users',
		children: usersContent,
		headerContent: headerActions
	}}
/>

<!-- 🔁 Fetching + Header Actions -->
<Story
	name="Fetching with Actions"
	args={{
		title: 'Users',
		isFetching: true,
		children: usersContent,
		headerContent: headerActions
	}}
/>

<!-- 📉 Empty -->
<Story name="Empty" args={{ title: 'Sales', children: emptyContent }} />
