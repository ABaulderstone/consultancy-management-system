export interface Contract {
  id: number;
  userId: number;
  title: string;
  salary: number;
  startDate: string;
  endDate: string | null;
  createdAt: string;
  updatedAt: string;
}
