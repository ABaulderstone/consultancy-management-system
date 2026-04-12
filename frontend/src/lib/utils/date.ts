interface DateRange {
	startDate: string;
	endDate: string | null;
}

export function formatDate(date: string | null) {
	if (!date) return 'Present';
	return new Date(date).toLocaleDateString('en-GB', {
		day: 'numeric',
		month: 'short',
		year: 'numeric'
	});
}
export function dateRange(input: DateRange) {
	return `${formatDate(input.startDate)} → ${formatDate(input.endDate)}`;
}
