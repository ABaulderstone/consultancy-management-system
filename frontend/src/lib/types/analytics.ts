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
