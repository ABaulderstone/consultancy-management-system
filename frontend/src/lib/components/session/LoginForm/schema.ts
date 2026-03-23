import { z } from 'zod';

export const schema = z.object({
	email: z.email(),
	password: z.string().min(1, 'Password is required')
});

export type LoginData = z.infer<typeof schema>;
