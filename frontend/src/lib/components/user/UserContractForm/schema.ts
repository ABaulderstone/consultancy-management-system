import { z } from 'zod';

export const CONTRACT_TYPE_OPTIONS = [
	{
		label: 'Full Time',
		value: 'fullTime'
	},
	{
		label: 'Part Time',
		value: 'partTime'
	}
] as const;

export const schema = z
	.object({
		userId: z.number().min(1),
		departmentId: z
			.number({ error: 'Department must be selected' })
			.min(1, 'Department must be selected'),
		positionId: z
			.number({ error: 'Position must be selected' })
			.min(1, 'Position must be selected'),
		fte: z.number(),

		contractType: z.enum(['fullTime', 'partTime']),

		hoursPerWeek: z.number().optional(),

		rate: z.number({ error: 'Rate is required' }).positive('Rate must be greater than 0'),

		startDate: z
			.string()
			.min(1, 'Start date is required')
			.refine((val) => !isNaN(Date.parse(val)), 'Start date is not a valid date'),

		endDate: z.string().optional()
	})
	.refine(
		(data) => {
			if (!data.endDate) return true;
			if (isNaN(Date.parse(data.endDate))) return false;
			return new Date(data.endDate) >= new Date(data.startDate);
		},
		{
			path: ['endDate'],
			message: 'End date must be on or after start date'
		}
	);

export type UserContractFormData = z.infer<typeof schema>;
