import { ApiError } from '$lib/api';
import type { FormHelpers } from '../types/form';

export async function handleFormSubmit<T extends Record<string, unknown>>(
	data: T,
	setFieldError: (field: string, message: string) => void,
	helpers: FormHelpers,
	action: (data: T) => Promise<void>
): Promise<void> {
	try {
		await action(data);
	} catch (err) {
		if (err instanceof ApiError && err.isValidationError() && err.details) {
			Object.entries(err.details).forEach(([field, messages]) => {
				setFieldError(field, messages[0]);
			});
		} else {
			helpers.setError(err instanceof ApiError ? err.message : 'Something went wrong');
		}
	}
}
