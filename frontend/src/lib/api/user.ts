import { httpClient } from './client';
import type { User, UserProfile } from '../types/user';
import type { PaginatedResponse, ApiRequestBody } from '../types/api';
import type { SortDirection } from '../types/data-table';
import { toSnakeCase } from '../utils/string';

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
			params.append('sort', toSnakeCase(sort));
			params.append('direction', direction);
		}
		return httpClient.get<PaginatedResponse<User>>(`/users?${params}`);
	},

	get: (slug: string) => httpClient.get<UserProfile>(`/users/${slug}`),

	getCurrent: () => httpClient.get<UserProfile>('/users/current'),

	create: (params: CreateUserParams) => httpClient.post<User, CreateUserParams>('/users', params),

	update: (id: number, params: UpdateUserParams) =>
		httpClient.patch<UserProfile, UpdateUserParams>(`/users/${id}`, params),

	delete: (id: number) => httpClient.delete(`/users/${id}`)
};
