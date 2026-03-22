import type { ApiRequestBody } from '../types/api';
import type { UserProfile } from '../types/user';
import { httpClient } from './client';

interface LoginParams extends ApiRequestBody {
	email: string;
	password: string;
}

export const sessionApi = {
	get: () => httpClient.get<UserProfile>('/session'),

	create: (params: LoginParams) => httpClient.post<UserProfile, LoginParams>('/session', params),

	destroy: () => httpClient.delete('/session')
};
