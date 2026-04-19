import type { ProfitSummaryReport, RevenueShare } from '../types/analytics';

import { httpClient } from './client';
interface ReportQueryParams {
	year?: string;
	month?: string;
}

function convertParams(queryParams: ReportQueryParams) {
	return new URLSearchParams(
		Object.entries(queryParams).reduce(
			(acc, [key, value]) => {
				if (value !== undefined) {
					acc[key] = value;
				}
				return acc;
			},
			{} as Record<string, string>
		)
	);
}

export const analyticsApi = {
	profitSummary: (queryParams: ReportQueryParams) => {
		const params = convertParams(queryParams);
		return httpClient.get<ProfitSummaryReport[]>(`/analytics/profit_summary?${params}`);
	},
	revenueShare: (queryParams: ReportQueryParams) => {
		const params = convertParams(queryParams);
		return httpClient.get<RevenueShare[]>(`/analytics/revenue_share?${params}`);
	}
};
