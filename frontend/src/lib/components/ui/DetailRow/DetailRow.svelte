<script lang="ts">
	import type { string } from 'zod';

	interface DetailRowProps {
		label: string;
		value: string | number | null | undefined;
		col?: string;
		labelClass?: string;
		valueClass?: string;
	}

	let { label, value, col = 'col-sm-6', labelClass = '', valueClass = '' }: DetailRowProps = $props();
</script>

<div class={col}>
	<p class="text-muted small mb-1 {labelClass}">{label}</p>
	<p class="mb-0 fw-medium {valueClass}">{value ?? '—'}</p>
</div>
