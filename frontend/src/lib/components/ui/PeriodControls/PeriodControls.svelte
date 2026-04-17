<script lang="ts">
	import { FontAwesomeIcon } from '@fortawesome/svelte-fontawesome';
	import { faChevronLeft, faChevronRight } from '@fortawesome/free-solid-svg-icons';
	import Button from '../Button';
	import type { PeriodView } from '../../../types/dashboard';

	interface PeriodControlsProps {
		view: PeriodView;
		label: string;
		onPrevious: () => void;
		onNext: () => void;
		onViewChange: (view: PeriodView) => void;
	}

	let { view, label, onPrevious, onNext, onViewChange }: PeriodControlsProps = $props();
</script>

<div class="d-flex align-items-center gap-3">
	<div class="btn-group btn-group-sm" role="group" aria-label="View period">
		<Button
			type="button"
			size="sm"
			variant={view === 'month' ? 'primary' : 'outline-primary'}
			onclick={() => onViewChange('month')}
		>
			Month
		</Button>
		<Button
			type="button"
			size="sm"
			variant={view === 'year' ? 'primary' : 'outline-primary'}
			onclick={() => onViewChange('year')}
		>
			Year
		</Button>
	</div>

	<div class="d-flex align-items-center gap-2">
		<Button
			type="button"
			size="sm"
			variant="outline-secondary"
			onclick={onPrevious}
			aria-label="Previous period"
		>
			{#key view}
				<FontAwesomeIcon icon={faChevronLeft} />
			{/key}
		</Button>

		<span class="fw-medium text-nowrap" style="min-width: 9rem; text-align: center;">
			{label}
		</span>

		<Button
			type="button"
			size="sm"
			variant="outline-secondary"
			onclick={onNext}
			aria-label="Next Period"
		>
			{#key view}
				<FontAwesomeIcon icon={faChevronRight} />
			{/key}
		</Button>
	</div>
</div>
