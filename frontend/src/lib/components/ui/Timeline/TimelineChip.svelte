<script lang="ts">
	interface TimelineChipProps {
		label: string;
		value: string;
	}

	let { label, value }: TimelineChipProps = $props();
</script>

<span class="chip small text-nowrap" title={label}>{value}</span>

<style>
	.chip {
		background: var(--bs-tertiary-bg);
		border: 1px solid var(--bs-border-color-translucent);
		border-radius: var(--bs-border-radius);
		padding: 0.1rem 0.45rem;
	}
</style>
