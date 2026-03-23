import { z } from 'zod';
export const GENDER_OPTIONS = [
	{ value: 'male', label: 'Male' },
	{ value: 'female', label: 'Female' },
	{ value: 'non_binary', label: 'Non-binary' },
	{ value: 'prefer_not_to_say', label: 'Prefer not to say' }
];

export const schema = z.object({
	firstName: z.string().min(1, 'First name is required'),
	lastName: z.string().min(1, 'Last name is required'),
	title: z.string().optional(),
	dateOfBirth: z.iso.date().optional(),
	gender: z.enum(GENDER_OPTIONS.map((opt) => opt.value)).optional()
});
export type UserFormData = z.infer<typeof schema>;
