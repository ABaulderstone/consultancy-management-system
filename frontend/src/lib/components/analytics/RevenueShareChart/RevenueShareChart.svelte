<script lang="ts">
	import { onMount, onDestroy } from 'svelte';
	import {
		Chart,
		ArcElement,
		Tooltip,
		Legend,
		PieController,
		type ChartData,
		type ChartOptions
	} from 'chart.js';
	import type { RevenueShare } from '../../../types/analytics';

	Chart.register(PieController, ArcElement, Tooltip, Legend);

	interface Props {
		data: RevenueShare[];
	}

	let { data }: Props = $props();

	let canvas: HTMLCanvasElement;
	let chart: Chart | undefined;

	function buildChartData(data: RevenueShare[]): ChartData<'pie'> {
		return {
			labels: data.map((d) => d.clientName),
			datasets: [
				{
					data: data.map((d) => d.share),
					backgroundColor: generateColors(data.length),
					borderWidth: 1
				}
			]
		};
	}

	// TODO: Consider attaching color when client is created so reports are always consistent
	function generateColors(count: number): string[] {
		const base = ['#0d6efd', '#198754', '#dc3545', '#ffc107', '#6f42c1', '#20c997', '#fd7e14'];

		return Array.from({ length: count }, (_, i) => base[i % base.length]);
	}

	const options: ChartOptions<'pie'> = {
		responsive: true,
		plugins: {
			legend: {
				position: 'bottom',
				labels: {
					generateLabels: (chart) => {
						const data = chart.data;
						return data.labels!.map((label, i) => {
							const value = data.datasets[0].data[i] as number;
							return {
								text: `${label} (${value.toFixed(1)}%)`,
								fillStyle: (data.datasets[0].backgroundColor as string[])[i],
								index: i
							};
						});
					}
				}
			},
			tooltip: {
				callbacks: {
					label: (ctx) => ` ${ctx.label}: ${ctx.parsed.toFixed(2)}%`
				}
			}
		}
	};

	onMount(() => {
		chart = new Chart(canvas, {
			type: 'pie',
			data: buildChartData(data),
			options
		});
	});

	$effect(() => {
		if (!chart) return;
		chart.data = buildChartData(data);
		chart.update();
	});

	onDestroy(() => chart?.destroy());
</script>

<canvas bind:this={canvas}></canvas>
