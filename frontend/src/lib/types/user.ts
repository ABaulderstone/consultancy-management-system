export type Role = 'employee' | 'admin';
export type Gender = 'male' | 'female' | 'other' | 'prefer_not_to_say';
export type EmploymentStatus = 'active' | 'departed' | 'uncontracted';
export type AssignmentStatus = 'assigned' | 'bench' | null;

export interface User {
	id: number;
	email: string;
	firstName: string | null;
	lastName: string | null;
	title: string | null;
	gender: Gender | null;
	dateOfBirth: string | null;
	role: Role;
	employmentStatus: EmploymentStatus;
	assignmentStatus: AssignmentStatus;
}

export interface ContractSummary {
	contractType: 'full_time' | 'part_time' | 'contractor';
	rate: number;
	payableRate: number;
	dailyCost: number;
	fte: number | null;
	startDate: string;
	position: {
		title: string;
		department: string;
	};
}

export interface JobSummary {
	title: string;
	client: string;
	startDate: string;
	dayRate: number;
	dailyMargin: number;
}

export interface UserProfile extends User {
	currentContract: ContractSummary | null;
	currentJob: JobSummary | null;
	lifetimeUtilisation: number;
}
