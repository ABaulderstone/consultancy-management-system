export interface ApiErrorDetails {
  [field: string]: string[];
}

export interface ApiErrorResponse {
  status: number;
  error: string;
  message: string;
  path: string;
  timestamp: string;
  details?: ApiErrorDetails;
}

export class ApiError extends Error {
  status: number;
  details?: ApiErrorDetails;

  constructor(response: ApiErrorResponse) {
    super(response.message);
    this.name = 'ApiError';
    this.status = response.status;
    this.details = response.details;
  }

  isValidationError(): boolean {
    return this.status === 422;
  }

  isUnauthorized(): boolean {
    return this.status === 401;
  }

  isForbidden(): boolean {
    return this.status === 403;
  }
}
