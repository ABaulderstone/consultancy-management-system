export type Role = 'employee' | 'admin';
export type Gender = 'male' | 'female' | 'other' | 'prefer_not_to_say';

export interface EnrichedUser {
	id: number;
	email: string;
	firstName: string;
	lastName: string;
	title: string | null;
	gender: Gender | null;
	dateOfBirth: string | null;
	age: number | null;
	role: Role;
}
