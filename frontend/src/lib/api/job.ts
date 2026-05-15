import type { PaginatedResponse } from '../types/api';
import type { JobResponse, JobStatus } from '../types/job';
import { httpClient } from './client';
interface JobListQuery {
	page?: number;
	limit?: number;
	search?: string;
	status?: JobStatus;
}
export const jobApi = {
	list: ({ page = 1, limit = 20, status, search }: JobListQuery) => {
		const params = new URLSearchParams({
			page: String(page),
			limit: String(limit)
		});
		if (status) {
			params.append('status', status);
		}
		if (search) {
			params.append('search', search);
		}
		return httpClient.get<PaginatedResponse<JobResponse>>(`/jobs?${params}`);
	}
};
