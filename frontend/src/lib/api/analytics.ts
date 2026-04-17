import type { ProfitSummaryReport } from '../types/analytics';

import { httpClient } from './client';
interface ProfitSummaryQueryParams {
	year?: string;
	month?: string;
}
export const analyticsApi = {
	profitSummary: (queryParams: ProfitSummaryQueryParams) => {
		const params = new URLSearchParams(
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
		return httpClient.get<ProfitSummaryReport[]>(`/analytics/profit_summary?${params}`);
	}
};
