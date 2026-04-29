<script lang="ts">
	import { onMount, onDestroy } from 'svelte';
	import {
		Chart,
		LineController,
		LineElement,
		PointElement,
		LinearScale,
		CategoryScale,
		Tooltip,
		Legend,
		Filler,
		type ChartData,
		type ChartOptions
	} from 'chart.js';
	import type { UtilizationReport } from '../../../types/analytics';

	Chart.register(
		LineController,
		LineElement,
		PointElement,
		LinearScale,
		CategoryScale,
		Tooltip,
		Legend,
		Filler
	);

	interface Props {
		data: UtilizationReport[];
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

	function buildChartData(data: UtilizationReport[], view: 'month' | 'year'): ChartData<'line'> {
		return {
			labels: data.map((e) => formatLabel(e.date, view)),
			datasets: [
				{
					label: 'Utilization',
					data: data.map((e) => (e.projected ? null : e.utilization)),
					borderColor: 'rgba(13, 110, 253, 1)',
					backgroundColor: 'rgba(13, 110, 253, 0.1)',
					tension: 0.3,
					fill: true,
					pointRadius: 2
				},
				{
					label: 'Projected',
					data: data.map((e) => (e.projected ? e.utilization : null)),
					borderColor: 'rgba(13, 110, 253, 0.5)',
					backgroundColor: 'rgba(13, 110, 253, 0.05)',
					borderDash: [5, 5],
					tension: 0.3,
					fill: true,
					pointRadius: 2
				}
			]
		};
	}

	const options: ChartOptions<'line'> = {
		responsive: true,
		interaction: { mode: 'index', intersect: false },
		plugins: {
			legend: { position: 'bottom', labels: { boxWidth: 12, padding: 16 } },
			tooltip: {
				callbacks: {
					label: (ctx) => {
						const entry = data[ctx.dataIndex];
						return ` Utilization: ${entry.utilization.toFixed(2)}% (${entry.assigned} / ${entry.available} FTE)`;
					}
				}
			}
		},
		scales: {
			x: { grid: { display: false } },
			y: {
				min: 0,
				max: 100,
				ticks: {
					callback: (value) => `${value}%`
				}
			}
		}
	};

	onMount(() => {
		chart = new Chart(canvas, {
			type: 'line',
			data: buildChartData(data, view),
			options
		});
		console.log(data);
	});

	$effect(() => {
		if (!chart) return;
		chart.data = buildChartData(data, view);
		chart.update();
	});

	onDestroy(() => chart?.destroy());
</script>

<canvas bind:this={canvas}></canvas>
