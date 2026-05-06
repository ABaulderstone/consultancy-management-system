<script lang="ts">
	import type { Snippet } from 'svelte';
	import { FontAwesomeIcon } from '@fortawesome/svelte-fontawesome';
	import {
		faChevronDown,
		faChevronUp,
		faCircleExclamation
	} from '@fortawesome/free-solid-svg-icons';
	import Button from '../Button';

	interface AccordionProps {
		title: string;
		subtitle?: string;
		onOpen?: () => void;
		loading?: boolean;
		error?: boolean;
		errorMessage?: string;
		defaultOpen?: boolean;
		action?: {
			label: string;
			loading?: boolean;
			onClick: () => void;
		};
		children: Snippet;
	}

	let {
		title,
		subtitle,
		onOpen,
		loading = false,
		error = false,
		errorMessage = 'Failed to load data',
		defaultOpen = false,
		action,
		children
	}: AccordionProps = $props();

	// svelte-ignore state_referenced_locally
	let open = $state(defaultOpen);
	// svelte-ignore state_referenced_locally
	let hasOpened = $state(defaultOpen);

	function toggle() {
		open = !open;
		if (open && !hasOpened) {
			hasOpened = true;
			onOpen?.();
		}
	}
</script>

<div class="accordion">
	<div class="accordion-item">
		<div
			class="d-flex align-items-center px-3 py-2 accordion-header {open
				? 'accordion-header--open'
				: ''}"
		>
			<button
				class="btn btn-link text-start text-decoration-none p-0 flex-grow-1 fw-medium"
				type="button"
				onclick={toggle}
				aria-expanded={open}
			>
				<span class="me-2">{title}</span>
				{#if subtitle}
					<span class="text-muted fw-normal small">{subtitle}</span>
				{/if}
			</button>

			<div class="d-flex align-items-center gap-2">
				{#if action}
					<Button
						variant="outline-primary"
						size="sm"
						loading={action.loading}
						onclick={action.onClick}
					>
						{action.label}
					</Button>
				{/if}
				<button
					type="button"
					class="btn btn-link p-0 text-secondary"
					onclick={toggle}
					tabindex="-1"
					aria-hidden="true"
				>
					{#key open}
						<FontAwesomeIcon icon={open ? faChevronUp : faChevronDown} />
					{/key}
				</button>
			</div>
		</div>

		{#if open}
			<div class="accordion-body">
				{#if loading}
					<div class="d-flex align-items-center gap-2 text-muted">
						<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
						<span class="small">Loading…</span>
					</div>
				{:else if error}
					<div class="d-flex align-items-center gap-2 text-danger small">
						<FontAwesomeIcon icon={faCircleExclamation} />
						{errorMessage}
					</div>
				{:else}
					{@render children()}
				{/if}
			</div>
		{/if}
	</div>
</div>

<style>
	.accordion-header {
		background-color: #dce8f8;
		border-radius: 4px;
		background-color: transparent;
	}
	.accordion-header--open {
		background-color: #dce8f8;
	}

	.accordion-button::after {
		display: none;
	}
</style>
