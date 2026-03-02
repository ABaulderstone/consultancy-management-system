import camelcaseKeys from 'camelcase-keys';

import snakecaseKeys from 'snakecase-keys';
import { ApiError } from './api-error';
import type { ApiRequestBody } from '../types/api';

const BASE_URL = '/api';

function toFormData(obj: Record<string, unknown>): FormData {
  const formData = new FormData();

  Object.entries(obj).forEach(([key, value]) => {
    const snakeKey = key.replace(
      /[A-Z]/g,
      (letter) => `_${letter.toLowerCase()}`,
    );

    if (value instanceof File || value instanceof Blob) {
      formData.append(snakeKey, value);
    } else if (value !== null && value !== undefined) {
      formData.append(snakeKey, String(value));
    }
  });

  return formData;
}

async function request<T>(
  path: string,
  options?: Omit<RequestInit, 'body'> & { body?: unknown },
): Promise<T> {
  const requestBody = options?.body
    ? JSON.stringify(
        snakecaseKeys(options.body as ApiRequestBody, {
          deep: true,
        }),
      )
    : undefined;

  const response = await fetch(BASE_URL + path, {
    ...options,
    credentials: 'include',
    headers: {
      'Content-Type': 'application/json',
      ...options?.headers,
    },
    body: requestBody,
  });
  if (!response.ok) {
    const error = camelcaseKeys(await response.json(), { deep: true });
    throw new ApiError(error);
  }
  if (response.status === 204) return undefined as T;

  const data = await response.json();

  return camelcaseKeys(data, { deep: true }) as T;
}

async function formRequest<T>(path: string, options: RequestInit) {
  const response = await fetch(BASE_URL + path, {
    ...options,
    credentials: 'include',
  });

  if (!response.ok) {
    const error = camelcaseKeys(await response.json(), { deep: true });
    throw new ApiError(error);
  }

  if (response.status === 204) return undefined as T;

  const data = await response.json();

  return camelcaseKeys(data, { deep: true }) as T;
}

export const httpClient = {
  get: <T>(path: string) => request<T>(path),

  post: <T, TBody extends ApiRequestBody = ApiRequestBody>(
    path: string,
    body: TBody,
  ) => request<T>(path, { method: 'POST', body }),

  patch: <T, TBody extends ApiRequestBody = ApiRequestBody>(
    path: string,
    body: TBody,
  ) => request<T>(path, { method: 'PATCH', body }),

  delete: <TResponse = void>(path: string) =>
    request<TResponse>(path, { method: 'DELETE' }),

  formPost: <T>(path: string, body: FormData) =>
    formRequest<T>(path, { method: 'POST', body }),

  formPatch: <T>(path: string, body: FormData) =>
    formRequest<T>(path, { method: 'PATCH', body }),
};
