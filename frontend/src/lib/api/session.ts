import type { ApiRequestBody } from '../types/api';
import type { EnrichedUser } from '../types/user';
import { httpClient } from './client';

interface LoginParams extends ApiRequestBody {
  email: string;
  password: string;
}

export const sessionApi = {
  get: () => httpClient.get<EnrichedUser>('/session'),

  create: (params: LoginParams) =>
    httpClient.post<EnrichedUser, LoginParams>('/session', params),

  destroy: () => httpClient.delete('/session'),
};
