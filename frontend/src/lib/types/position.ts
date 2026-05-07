export type PositionResponse = {
	id: number;
	title: string;
	departmentId: number;
	minSalary: string;
	maxSalary: string;
};

export type NormalizedPositionResponse = Omit<PositionResponse, 'minSalary' | 'maxSalary'> & {
	minSalary: number;
	maxSalary: number;
};
