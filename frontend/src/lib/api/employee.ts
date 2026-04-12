import type { AssignmentHistory } from '../types/assignment';
import type { ContractHistory } from '../types/contract';
import { httpClient } from './client';

export const employeeApi = {
	getContractHistory(slug: string) {
		return httpClient.get<ContractHistory[]>(`/users/${slug}/contracts`);
	},
	getAssignmentHistory(slug: string) {
		return httpClient.get<AssignmentHistory[]>(`/users/${slug}/assignments`);
	}
};
