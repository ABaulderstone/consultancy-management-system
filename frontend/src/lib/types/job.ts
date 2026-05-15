export type JobStatus = 'open' | 'assigned' | 'closed' | 'available';

export interface JobAssignment {
	id: number;
	startDate: string;
	user: {
		name: string | null;
	};
}

export interface JobClient {
	name: string;
}

export interface JobResponse {
	id: number;
	title: string;
	startDate: string;
	endDate: string | null;
	dayRate: number;
	client: JobClient;
	assignment: JobAssignment | null;
}
