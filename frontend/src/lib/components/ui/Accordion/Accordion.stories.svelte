<script module lang="ts">
	import { defineMeta } from '@storybook/addon-svelte-csf';
	import { fn, expect, within, userEvent } from 'storybook/test';
	import Accordion from './Accordion.svelte';

	const { Story } = defineMeta({
		title: 'UI/Accordion',
		component: Accordion,
		tags: ['autodocs'],
		argTypes: {
			title: { control: 'text' },
			subtitle: { control: 'text' },
			loading: { control: 'boolean' },
			error: { control: 'boolean' },
			errorMessage: { control: 'text' },
			defaultOpen: { control: 'boolean' }
		},
		args: {
			onOpen: fn()
		}
	});

	async function playOpensOnClick({ canvasElement, args }: any) {
		const canvas = within(canvasElement);
		const button = canvas.getByRole('button', { name: /assignment history/i });

		await expect(button).toHaveAttribute('aria-expanded', 'false');
		await expect(canvas.queryByText('Content revealed')).not.toBeInTheDocument();

		await userEvent.click(button);

		await expect(button).toHaveAttribute('aria-expanded', 'true');
		await expect(canvas.getByText('Content revealed')).toBeInTheDocument();
		await expect(args.onOpen).toHaveBeenCalledTimes(1);
	}

	async function playOnOpenFiresOnce({ canvasElement, args }: any) {
		const canvas = within(canvasElement);
		const button = canvas.getByRole('button', { name: /assignment history/i });

		await userEvent.click(button); // open  → fires onOpen
		await userEvent.click(button); // close
		await userEvent.click(button); // open again → must NOT re-fire

		await expect(args.onOpen).toHaveBeenCalledTimes(1);
	}

	async function playClosesOnSecondClick({ canvasElement }: any) {
		const canvas = within(canvasElement);
		const button = canvas.getByRole('button', { name: /contract history/i });

		await userEvent.click(button);
		await expect(canvas.getByText('Hidden content')).toBeInTheDocument();

		await userEvent.click(button);
		await expect(canvas.queryByText('Hidden content')).not.toBeInTheDocument();
		await expect(button).toHaveAttribute('aria-expanded', 'false');
	}

	async function playDefaultOpenDoesNotCallOnOpen({ args }: any) {
		// onOpen is not called on mount — it's only triggered by the first user click.
		// defaultOpen simply renders the content without going through toggle().
		await expect(args.onOpen).toHaveBeenCalledTimes(0);
	}

	async function playLoadingHidesContent({ canvasElement }: any) {
		const canvas = within(canvasElement);
		await expect(canvas.getByRole('status')).toBeInTheDocument();
		await expect(canvas.queryByText('Should be hidden')).not.toBeInTheDocument();
	}

	async function playErrorHidesContent({ canvasElement }: any) {
		const canvas = within(canvasElement);
		await expect(canvas.getByText('Could not load data')).toBeInTheDocument();
		await expect(canvas.queryByText('Should be hidden')).not.toBeInTheDocument();
	}
</script>

<!-- Closed by default — the baseline state -->
<Story name="Closed" args={{ title: 'Contract History' }}>
	{#snippet children()}
		Some content inside the accordion.
	{/snippet}
</Story>

<!-- Open by default -->
<Story name="Open" args={{ title: 'Contract History', defaultOpen: true }}>
	{#snippet children()}
		Some content inside the accordion.
	{/snippet}
</Story>

<!-- With a subtitle shown next to the title -->
<Story
	name="With Subtitle"
	args={{ title: 'Contract History', subtitle: '4 records', defaultOpen: true }}
>
	{#snippet children()}
		Some content inside the accordion.
	{/snippet}
</Story>

<!-- Loading state — shown while the lazy fetch is in flight -->
<Story name="Loading" args={{ title: 'Contract History', defaultOpen: true, loading: true }}>
	{#snippet children()}
		This should not render while loading.
	{/snippet}
</Story>

<!-- Error state -->
<Story
	name="Error"
	args={{
		title: 'Contract History',
		defaultOpen: true,
		error: true,
		errorMessage: 'Failed to load contracts'
	}}
>
	{#snippet children()}
		This should not render on error.
	{/snippet}
</Story>

<!-- Clicking opens the accordion and fires onOpen exactly once -->
<Story name="Opens on Click" args={{ title: 'Assignment History' }} play={playOpensOnClick}>
	{#snippet children()}
		Content revealed
	{/snippet}
</Story>

<!-- onOpen fires only once even across multiple open/close cycles -->
<Story name="onOpen Fires Once" args={{ title: 'Assignment History' }} play={playOnOpenFiresOnce}>
	{#snippet children()}
		Content
	{/snippet}
</Story>

<!-- Toggling closed hides the content -->
<Story
	name="Closes on Second Click"
	args={{ title: 'Contract History' }}
	play={playClosesOnSecondClick}
>
	{#snippet children()}
		Hidden content
	{/snippet}
</Story>

<!-- defaultOpen does not call onOpen — it bypasses toggle() entirely -->
<Story
	name="defaultOpen Does Not Call onOpen"
	args={{ title: 'Contract History', defaultOpen: true }}
	play={playDefaultOpenDoesNotCallOnOpen}
>
	{#snippet children()}
		Pre-loaded content
	{/snippet}
</Story>

<!-- Loading state renders spinner, not children -->
<Story
	name="Loading Hides Content"
	args={{ title: 'Contract History', defaultOpen: true, loading: true }}
	play={playLoadingHidesContent}
>
	{#snippet children()}
		Should be hidden
	{/snippet}
</Story>

<!-- Error state renders the message, not children -->
<Story
	name="Error Hides Content"
	args={{
		title: 'Contract History',
		defaultOpen: true,
		error: true,
		errorMessage: 'Could not load data'
	}}
	play={playErrorHidesContent}
>
	{#snippet children()}
		Should be hidden
	{/snippet}
</Story>
