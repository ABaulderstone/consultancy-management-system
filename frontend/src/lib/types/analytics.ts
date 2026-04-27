export interface ProfitSummaryReport {
	date: string;
	revenue: number;
	cost: number;
	profit: number;
	projected: boolean;
}

export interface RevenueShare {
	clientName: string;
	share: number;
}

export interface UtilizationReport {
	date: string;
	assigned: number;
	available: number;
	utilization: number;
	projected: boolean;
}
