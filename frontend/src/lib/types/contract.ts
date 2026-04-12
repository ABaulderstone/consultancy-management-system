export type ContractType = 'full_time' | 'part_time' | 'contractor';

export interface ContractHistory {
	id: number;
	contractType: ContractType;
	rate: number;
	payableRate: number;
	dailyCost: number;
	fte: number | null;
	startDate: string;
	endDate: string | null;
	position: {
		title: string;
		department: string;
	};
}
