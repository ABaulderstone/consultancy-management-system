import type { ProfitSummaryReport } from '../types/analytics';

function workingDays(year: number, month: number): Date[] {
	const days: Date[] = [];
	const d = new Date(year, month - 1, 1);
	while (d.getMonth() === month - 1) {
		if (d.getDay() !== 0 && d.getDay() !== 6) days.push(new Date(d));
		d.setDate(d.getDate() + 1);
	}
	return days;
}

export function mockMonthlyData(
	year = 2024,
	month = 3,
	projectedFromDay = 16
): ProfitSummaryReport[] {
	return workingDays(year, month).map((d) => {
		const projected = d.getDate() >= projectedFromDay;
		const revenue = 1300 + Math.round(Math.random() * 200);
		const cost = 680 + Math.round(Math.random() * 100);
		return {
			date: d.toISOString().split('T')[0],
			revenue,
			cost,
			profit: revenue - cost,
			projected
		};
	});
}

export function mockYearlyData(year = 2024): ProfitSummaryReport[] {
	const today = new Date();
	return Array.from({ length: 12 }, (_, i) => {
		const d = new Date(year, i, 1);
		const projected = d > today;
		const revenue = 26000 + Math.round(Math.random() * 6000);
		const cost = 14000 + Math.round(Math.random() * 2000);
		return {
			date: d.toISOString().split('T')[0],
			revenue,
			cost,
			profit: revenue - cost,
			projected
		};
	});
}

export function mockAllActualData(): ProfitSummaryReport[] {
	return mockMonthlyData(2024, 1, 999);
}

export function mockAllProjectedData(): ProfitSummaryReport[] {
	return mockMonthlyData(2024, 3, 1);
}
