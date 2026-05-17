import type { PaginatedResponse } from '../types/api';
import type { EnrichedClient, SimpleClient } from '../types/client';
import { httpClient } from './client';

interface PaginationOptions {
	limit: number;
	page: number;
}

export const clientsApi = {
	list: ({ page = 1, limit = 5 }: PaginationOptions) => {
		const params = new URLSearchParams({
			page: String(page),
			limit: String(limit)
		});
		return httpClient.get<PaginatedResponse<EnrichedClient>>(`/clients?${params}`);
	},
	simpleList: () => httpClient.get<SimpleClient[]>('/clients/simple')
};
