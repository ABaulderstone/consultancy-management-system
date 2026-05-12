<script lang="ts">
	import { onMount, onDestroy } from 'svelte';
	import {
		Chart,
		BarController,
		BarElement,
		LineController,
		LineElement,
		PointElement,
		LinearScale,
		CategoryScale,
		Tooltip,
		Legend,
		type ChartData,
		type ChartOptions,

	} from 'chart.js';
	import type { JobsFlowReport } from '../../../types/analytics';

	Chart.register(
		BarController,
		BarElement,
		LineController,
		LineElement,
		PointElement,
		LinearScale,
		CategoryScale,
		Tooltip,
		Legend
	);



	interface JobFlowChartProps {
		data: JobsFlowReport[];
		view: 'month' | 'year';
	}



	let { data, view }: JobFlowChartProps = $props();

	let canvas: HTMLCanvasElement;
	let chart: Chart | undefined;

	function formatLabel(dateStr: string, view: 'month' | 'year') {
		const d = new Date(dateStr);
		return view === 'year'
			? d.toLocaleDateString('en-GB', { month: 'short' })
			: d.toLocaleDateString('en-GB', { day: 'numeric', month: 'short' });
	}

	function buildChartData(data: JobsFlowReport[], view: 'month' | 'year'): ChartData {
		const actual = (val: number, projected: boolean) => (projected ? null : val);
		const projected = (val: number, isProjected: boolean) => (isProjected ? val : null);

		return {
			labels: data.map((e) => formatLabel(e.date, view)),
			datasets: [
				// Bars — started
				{
					type: 'bar' as const,
					label: 'Started',
					data: data.map((e) => actual(e.started, e.projected)),
					backgroundColor: 'rgba(25, 135, 84, 0.75)',
					borderColor: 'rgba(25, 135, 84, 1)',
					borderWidth: 1,
					borderRadius: 3,
					yAxisID: 'yBar'
				},
				{
					type: 'bar' as const,
					label: 'Started (projected)',
					data: data.map((e) => projected(e.started, e.projected)),
					backgroundColor: 'rgba(25, 135, 84, 0.3)',
					borderColor: 'rgba(25, 135, 84, 0.6)',
					borderWidth: 1,
					borderRadius: 3,
					yAxisID: 'yBar'
				},
				// Bars — finished
				{
					type: 'bar' as const,
					label: 'Finished',
					data: data.map((e) => actual(e.finished, e.projected)),
					backgroundColor: 'rgba(220, 53, 69, 0.75)',
					borderColor: 'rgba(220, 53, 69, 1)',
					borderWidth: 1,
					borderRadius: 3,
					yAxisID: 'yBar'
				},
				{
					type: 'bar' as const,
					label: 'Finished (projected)',
					data: data.map((e) => projected(e.finished, e.projected)),
					backgroundColor: 'rgba(220, 53, 69, 0.3)',
					borderColor: 'rgba(220, 53, 69, 0.6)',
					borderWidth: 1,
					borderRadius: 3,
					yAxisID: 'yBar'
				},
				// Line — active
				{
					type: 'line' as const,
					label: 'Active',
					data: data.map((e) => actual(e.active, e.projected)),
					borderColor: 'rgba(13, 110, 253, 1)',
					backgroundColor: 'transparent',
					tension: 0.3,
					pointRadius: 2,
					borderWidth: 2,
					yAxisID: 'yLine'
				},
				{
					type: 'line' as const,
					label: 'Active (projected)',
					data: data.map((e) => projected(e.active, e.projected)),
					borderColor: 'rgba(13, 110, 253, 0.5)',
					backgroundColor: 'transparent',
					borderDash: [5, 5],
					tension: 0.3,
					pointRadius: 2,
					borderWidth: 2,
					yAxisID: 'yLine'
				}
			]
		};
	}

	const options: ChartOptions = {
		responsive: true,
		interaction: { mode: 'index', intersect: false },
		plugins: {
			legend: {
				position: 'bottom',
				labels: {
					boxWidth: 12,
					padding: 16,
					// Collapse projected variants in the legend
					filter: (item) => !item.text.includes('projected')
				}
			},
			tooltip: {
				callbacks: {
					label: (ctx) => {
						const entry = data[ctx.dataIndex];
						const suffix = entry.projected ? ' (projected)' : '';
						switch (ctx.dataset.label?.replace(' (projected)', '')) {
							case 'Started': return ` Started: ${entry.started}${suffix}`;
							case 'Finished': return ` Finished: ${entry.finished}${suffix}`;
							case 'Active': return ` Active: ${entry.active}${suffix}`;
							default: return '';
						}
					},
					// Deduplicate actual/projected tooltip rows
					beforeLabel: (ctx) => {
						if (ctx.dataset.label?.includes('projected') && !data[ctx.dataIndex].projected) return null as any;
						if (!ctx.dataset.label?.includes('projected') && data[ctx.dataIndex].projected) return null as any;
					}
				}
			}
		},
		scales: {
			x: { grid: { display: false } },
			yBar: {
				type: 'linear',
				position: 'left',
				beginAtZero: true,
				ticks: { precision: 0 },
				title: { display: true, text: 'Jobs started / finished' }
			},
			yLine: {
				type: 'linear',
				position: 'right',
				beginAtZero: true,
				ticks: { precision: 0 },
				grid: { drawOnChartArea: false }, // avoid double gridlines
				title: { display: true, text: 'Active jobs' }
			}
		}
	};

	onMount(() => {
		chart = new Chart(canvas, { data: buildChartData(data, view), options } as any);
	});

	$effect(() => {
		if (!chart) return;
		chart.data = buildChartData(data, view);
		chart.update();
	});

	onDestroy(() => chart?.destroy());
</script>

<canvas bind:this={canvas}></canvas>