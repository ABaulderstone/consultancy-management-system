<script lang="ts">
	import type { Snippet } from 'svelte';
	import { FontAwesomeIcon } from '@fortawesome/svelte-fontawesome';
	import {
		faChevronDown,
		faChevronUp,
		faCircleExclamation
	} from '@fortawesome/free-solid-svg-icons';

	interface AccordionProps {
		title: string;
		subtitle?: string;
		onOpen?: () => void;
		loading?: boolean;
		error?: boolean;
		errorMessage?: string;
		defaultOpen?: boolean;
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
		<h2 class="accordion-header">
			<button
				class="accordion-button {open ? '' : 'collapsed'}"
				type="button"
				onclick={toggle}
				aria-expanded={open}
			>
				<span class="me-2">{title}</span>
				{#if subtitle}
					<span class="text-muted fw-normal small">{subtitle}</span>
				{/if}
				{#key open}
					<FontAwesomeIcon
						icon={open ? faChevronUp : faChevronDown}
						class="ms-auto me-2 text-secondary"
					/>
				{/key}
			</button>
		</h2>

		{#if open}
			<div class="accordion-collapse">
				<div class="accordion-body">
					{#if loading}
						<div class="d-flex align-items-center gap-2 text-muted">
							<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"
							></span>
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
			</div>
		{/if}
	</div>
</div>

<style>
	/* suppress Bootstrap's built-in chevron — we're using FontAwesome instead */
	.accordion-button::after {
		display: none;
	}
</style>
