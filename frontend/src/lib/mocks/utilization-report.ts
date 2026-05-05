import type { UtilizationReport } from '../types/analytics';

function workingDays(year: number, month: number): Date[] {
	const days: Date[] = [];
	const d = new Date(year, month - 1, 1);
	while (d.getMonth() === month - 1) {
		if (d.getDay() !== 0 && d.getDay() !== 6) days.push(new Date(d));
		d.setDate(d.getDate() + 1);
	}
	return days;
}

export function mockMonthlyUtilization(
	year = 2024,
	month = 3,
	projectedFromDay = 16
): UtilizationReport[] {
	return workingDays(year, month).map((d) => {
		const projected = d.getDate() >= projectedFromDay;

		// simulate capacity between 5–10 FTE
		const available = 5 + Math.random() * 5;

		// utilization between 50%–95%
		const utilizationPct = 50 + Math.random() * 45;
		const assigned = (available * utilizationPct) / 100;

		return {
			date: d.toISOString().split('T')[0],
			assigned: Number(assigned.toFixed(2)),
			available: Number(available.toFixed(2)),
			utilization: Number(((assigned / available) * 100).toFixed(2)),
			projected
		};
	});
}

export function mockYearlyUtilization(year = 2024): UtilizationReport[] {
	const today = new Date();

	return Array.from({ length: 12 }, (_, i) => {
		const d = new Date(year, i, 1);
		const projected = d > today;

		const available = 20 + Math.random() * 10;
		const utilizationPct = 60 + Math.random() * 30;
		const assigned = (available * utilizationPct) / 100;

		return {
			date: d.toISOString().split('T')[0],
			assigned: Number(assigned.toFixed(2)),
			available: Number(available.toFixed(2)),
			utilization: Number(((assigned / available) * 100).toFixed(2)),
			projected
		};
	});
}

export function mockAllActualUtilization(): UtilizationReport[] {
	return mockMonthlyUtilization(2024, 1, 999);
}

export function mockAllProjectedUtilization(): UtilizationReport[] {
	return mockMonthlyUtilization(2024, 3, 1);
}
