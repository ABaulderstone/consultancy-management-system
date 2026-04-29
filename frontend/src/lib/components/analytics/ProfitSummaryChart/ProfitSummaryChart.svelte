<script lang="ts">
	import { onMount, onDestroy } from 'svelte';
	import {
		Chart,
		BarElement,
		LinearScale,
		CategoryScale,
		Tooltip,
		Legend,
		LineElement,
		PointElement,
		type ChartData,
		type ChartOptions,
		BarController
	} from 'chart.js';
	import type { ProfitSummaryReport } from '../../../types/analytics';

	Chart.register(
		BarController,
		BarElement,
		LineElement,
		PointElement,
		LinearScale,
		CategoryScale,
		Tooltip,
		Legend
	);

	interface Props {
		data: ProfitSummaryReport[];
		view: 'month' | 'year';
	}

	let { data, view }: Props = $props();

	let canvas: HTMLCanvasElement;
	let chart: Chart | undefined;

	function formatLabel(dateStr: string, view: 'month' | 'year') {
		const d = new Date(dateStr);
		return view === 'year'
			? d.toLocaleDateString('en-GB', { month: 'short' })
			: d.toLocaleDateString('en-GB', { day: 'numeric', month: 'short' });
	}

	function buildChartData(data: ProfitSummaryReport[], view: 'month' | 'year'): ChartData<'bar'> {
		return {
			labels: data.map((e) => formatLabel(e.date, view)),
			datasets: [
				{
					label: 'Revenue',
					data: data.map((e) => e.revenue),
					backgroundColor: 'rgba(13, 110, 253, 0.15)',
					borderColor: 'rgba(13, 110, 253, 0.6)',
					borderWidth: 1,
					stack: 'totals'
				},
				{
					label: 'Cost',
					data: data.map((e) => e.cost),
					backgroundColor: 'rgba(220, 53, 69, 0.15)',
					borderColor: 'rgba(220, 53, 69, 0.6)',
					borderWidth: 1,
					stack: 'totals'
				},
				{
					label: 'Profit',
					data: data.map((e) => (e.projected ? null : e.profit)),
					backgroundColor: 'rgba(25, 135, 84, 0.7)',
					borderColor: 'rgba(25, 135, 84, 1)',
					borderWidth: 1,
					stack: 'profit'
				},
				{
					label: 'Projected profit',
					data: data.map((e) => (e.projected ? e.profit : null)),
					backgroundColor: 'rgba(25, 135, 84, 0.25)',
					borderColor: 'rgba(25, 135, 84, 0.5)',
					borderWidth: 1,
					stack: 'profit'
				}
			]
		};
	}

	const options: ChartOptions<'bar'> = {
		responsive: true,
		maintainAspectRatio: true,
		interaction: { mode: 'index', intersect: false },
		plugins: {
			legend: { position: 'bottom', labels: { boxWidth: 12, padding: 16 } },
			tooltip: {
				callbacks: {
					label: (ctx) => ` ${ctx.dataset.label}: $${ctx.parsed.y?.toLocaleString() ?? 0}`
				}
			}
		},
		scales: {
			x: { grid: { display: false } },
			y: { ticks: { callback: (value) => `$${Number(value).toLocaleString()}` } }
		}
	};

	onMount(() => {
		chart = new Chart(canvas, { type: 'bar', data: buildChartData(data, view), options });
	});

	$effect(() => {
		if (!chart) return;
		chart.data = buildChartData(data, view);
		chart.update();
	});

	onDestroy(() => chart?.destroy());
</script>

<canvas bind:this={canvas}></canvas>
