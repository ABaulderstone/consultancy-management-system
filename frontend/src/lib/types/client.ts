export interface JobBreakdown {
	assigned: number;
	open: number;
	closed: number;
}

export interface EnrichedClient {
	id: number;
	name: string;
	jobsCount: number;
	firstJobDate: string | null;
	averageDayRate: number;
	totalRevenue: number;
	jobBreakdown: JobBreakdown;
}

export interface SimpleClient {
	id: number;
	name: string;
}
