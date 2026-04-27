<script module lang="ts">
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import Card from './Card.svelte';

	const { Story } = defineMeta({
		title: 'UI/Card',
		component: Card,
		tags: ['autodocs']
	});
</script>

{#snippet header()}
	<button class="btn btn-sm btn-primary">Action</button>
{/snippet}

<Story name="Default" args={{ title: 'Card Title' }}>
	<p>This is a simple card body.</p>
</Story>

<Story name="With Header Action" args={{ title: 'Card Title', header: header }}>
	<p>Card with header action.</p>
</Story>

<Story name="Custom Content (No Title)">
	<div class="d-flex justify-content-between">
		<span>Left</span>
		<span>Right</span>
	</div>
</Story>
