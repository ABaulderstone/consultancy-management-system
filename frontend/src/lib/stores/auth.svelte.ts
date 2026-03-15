import type { EnrichedUser } from '$lib/types/user';

interface AuthState {
	user: EnrichedUser | null;
	loading: boolean;
}

export const authStore = $state<AuthState>({
	user: null,
	loading: true
});
