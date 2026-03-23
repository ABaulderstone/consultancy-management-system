import type { UserProfile } from '$lib/types/user';

interface AuthState {
	user: UserProfile | null;
	loading: boolean;
}

export const authStore = $state<AuthState>({
	user: null,
	loading: true
});
