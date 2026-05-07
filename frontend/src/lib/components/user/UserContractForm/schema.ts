import { z } from 'zod';

export const CONTRACT_TYPE_OPTIONS = [
	{ label: 'Full Time', value: 'fullTime' },
	{ label: 'Part Time', value: 'partTime' }
] as const;

const contractTypeEnum = z.enum(['fullTime', 'partTime']);

// reusable helper for form inputs
const optionalNumber = z.preprocess((val) => {
	if (val === '' || val === null || val === undefined) return undefined;
	if (typeof val === 'string' && val.trim() === '') return undefined;
	return Number(val);
}, z.number().optional());

export const schema = z
	.object({
		userId: z.number(),

		departmentId: z.preprocess(
			(val) => (val === '' || val === undefined ? undefined : Number(val)),
			z.number({ error: 'Department is required' })
		),

		positionId: z.preprocess(
			(val) => (val === '' || val === undefined ? undefined : Number(val)),
			z.number({ error: 'Position is required' })
		),

		contractType: contractTypeEnum,

		hoursPerWeek: optionalNumber,

		fte: z.number(),

		rate: z.preprocess(
			(val) => (val === '' || val === undefined ? undefined : Number(val)),
			z.number().positive()
		),

		startDate: z.string().min(1),
		endDate: z.string().optional()
	})
	.refine(
		(data) => {
			if (!data.endDate) return true;
			return new Date(data.endDate) >= new Date(data.startDate);
		},
		{
			path: ['endDate'],
			message: 'End date must be after start date'
		}
	);

export type ContractFormData = z.infer<typeof schema>;
