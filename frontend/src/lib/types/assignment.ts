export interface AssignmentHistory {
	id: number;
	startDate: string;
	endDate: string | null;
	job: {
		title: string;
		client: string;
		dayRate: number;
	};
}
