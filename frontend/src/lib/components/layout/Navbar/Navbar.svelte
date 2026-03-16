<script lang="ts">
	import { goto } from '$app/navigation';
	import { page } from '$app/state';
	import { toast } from 'svelte-sonner';
	import { authStore } from '$lib/stores/auth.svelte';
	import { sessionApi } from '$lib/api/session';
	import type { Role } from '$lib/types/user';
	import { resolve } from '$app/paths';

	interface NavLink {
		label: string;
		to: string;
	}

	function getNavLinks(role: Role | undefined): NavLink[] {
		if (!role) return [];

		switch (role) {
			case 'admin':
				return [
					{ label: 'Users', to: '/users' },
					{ label: 'Dashboard', to: '/' }
				];
			case 'employee':
				return [{ label: 'Dashboard', to: '/' }];
			default:
				return [];
		}
	}
	let expanded = $state(false);
	const navLinks = $derived(getNavLinks(authStore.user?.role));

	const handleLogout = async () => {
		try {
			await sessionApi.destroy();
			authStore.user = null;
			toast.success('Successfully logged out');
			goto(resolve('/login'));
		} catch {
			toast.error('Failed to logout');
		}
	};
</script>

<nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom">
	<div class="container">
		<a class="navbar-brand fw-semibold" href={resolve('/')}> HR App </a>

		<button
			class="navbar-toggler"
			type="button"
			data-bs-toggle="collapse"
			data-bs-target="#navbarNav"
			aria-controls="navbarNav"
			aria-expanded="false"
			aria-label="Toggle navigation"
			onclick={() => (expanded = !expanded)}
		>
			<span class="navbar-toggler-icon"></span>
		</button>

		<div class="collapse navbar-collapse {expanded ? 'show' : ''}" id="navbarNav">
			<ul class="navbar-nav me-auto">
				{#each navLinks as link (link.to)}
					<li class="nav-item">
						<a
							class="nav-link {page.url.pathname === link.to ? 'active' : ''}"
							href={link.to}
							onclick={() => (expanded = false)}
						>
							{link.label}
						</a>
					</li>
				{/each}
			</ul>

			<div class="d-flex align-items-center gap-3">
				{#if authStore.user}
					<span class="text-muted small">
						{authStore.user.firstName}
						{authStore.user.lastName}
					</span>
					<button class="btn btn-outline-secondary btn-sm" onclick={handleLogout}> Logout </button>
				{/if}
			</div>
		</div>
	</div>
</nav>
