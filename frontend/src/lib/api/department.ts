import type { DepartmentResponse } from '../types/department';
import { httpClient } from './client';

export const departmentApi = {
	list: () => httpClient.get<DepartmentResponse[]>('/departments')
};
