import { httpClient } from './client';
import type { EnrichedUser } from '../types/user';
import type { PaginatedResponse, ApiRequestBody } from '../types/api';
import type { SortDirection } from '../types/data-table';

export interface CreateUserParams extends ApiRequestBody {
	firstName: string;
	lastName: string;
	dateOfBirth?: string;
	gender?: string;
}

export interface UpdateUserParams extends ApiRequestBody {
	firstName?: string;
	lastName?: string;
	dateOfBirth?: string;
	gender?: string;
	title?: string;
}

export const usersApi = {
	list: (page = 1, limit = 20, sort?: string, direction?: SortDirection) => {
		const params = new URLSearchParams({
			page: String(page),
			limit: String(limit)
		});
		if (sort && direction) {
			params.append('sort', sort);
			params.append('direction', direction);
		}
		return httpClient.get<PaginatedResponse<EnrichedUser>>(`/users?${params}`);
	},

	get: (id: number) => httpClient.get<EnrichedUser>(`/users/${id}`),

	getCurrent: () => httpClient.get<EnrichedUser>('/users/current'),

	create: (params: CreateUserParams) =>
		httpClient.post<EnrichedUser, CreateUserParams>('/users', params),

	update: (id: number, params: UpdateUserParams) =>
		httpClient.patch<EnrichedUser, UpdateUserParams>(`/users/${id}`, params),

	delete: (id: number) => httpClient.delete(`/users/${id}`)
};
