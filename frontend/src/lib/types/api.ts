export type ApiRequestBody = Record<string, unknown>;

export interface PaginatedResponse<T> {
  data: T[];
  meta: {
    page: number;
    limit: number;
    pages: number;
    count: number;
  };
  links: {
    next: string | null;
    prev: string | null;
  };
}
