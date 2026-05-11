import type { UserContractFormData } from '../components/user/UserContractForm/schema';
import type { ContractHistory, ContractType } from '../types/contract';
import { toSnakeCase } from '../utils/string';
import { httpClient } from './client';
type ContractData = Omit<UserContractFormData, 'contractType'> & { contractType: ContractType };
export const contractApi = {
	create: (data: UserContractFormData) =>
		httpClient.post<ContractHistory, ContractData>('/contracts', {
			...data,
			contractType: toSnakeCase(data.contractType) as ContractType
		})
};
