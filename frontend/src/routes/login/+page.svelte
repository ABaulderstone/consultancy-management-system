<script lang="ts">
	import { goto } from '$app/navigation';
	import { sessionApi } from '$lib/api';
	import { authStore } from '$lib/stores/auth.svelte';
	import { toast } from 'svelte-sonner';
	import LoginForm from '../../lib/components/session/LoginForm';
	import type { LoginData } from '../../lib/components/session/LoginForm/schema';

	async function handleSubmit(data: LoginData) {
		authStore.user = await sessionApi.create(data);
		goto('/');
		toast.success('Logged in');
	}
</script>

<div class="min-vh-100 d-flex align-items-center justify-content-center">
	<div class="card p-4" style="width: 100%; max-width: 400px">
		<h2 class="text-center mb-4">Login</h2>
		<LoginForm onSubmit={handleSubmit} />
	</div>
</div>
