import { httpClient } from './client';
import type { EnrichedUser } from '../types/user';
import type { PaginatedResponse, ApiRequestBody } from '../types/api';

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
  list: (page = 1, limit = 20) =>
    httpClient.get<PaginatedResponse<EnrichedUser>>(
      `/users?page=${page}&limit=${limit}`,
    ),

  get: (id: number) => httpClient.get<EnrichedUser>(`/users/${id}`),

  getCurrent: () => httpClient.get<EnrichedUser>('/users/current'),

  create: (params: CreateUserParams) =>
    httpClient.post<EnrichedUser, CreateUserParams>('/users', params),

  update: (id: number, params: UpdateUserParams) =>
    httpClient.patch<EnrichedUser, UpdateUserParams>(`/users/${id}`, params),

  delete: (id: number) => httpClient.delete(`/users/${id}`),
};
