<script lang="ts">
	// TODO: SERVER SIDE AUTH INSTEAD
	// eslint-disable-next-line svelte/valid-prop-names-in-kit-pages
	export const ssr = false;

	import '../app.scss';
	import { onMount } from 'svelte';
	import { goto } from '$app/navigation';
	import { page } from '$app/state';
	import { resolve } from '$app/paths';

	import type { Snippet } from 'svelte';
	import { sessionApi } from '$lib/api/session';
	import { authStore } from '$lib/stores/auth.svelte';
	import favicon from '$lib/assets/favicon.svg';
	import { Toaster } from 'svelte-sonner';

	let { children }: { children: Snippet } = $props();

	const PUBLIC_ROUTES = ['/login'];

	onMount(async () => {
		try {
			authStore.user = await sessionApi.get();
		} catch {
			authStore.user = null;
		} finally {
			authStore.loading = false;
		}
	});
	const isPublic = $derived(PUBLIC_ROUTES.includes(page.url.pathname));
	const shouldShowSpinner = $derived(
		authStore.loading || (!authStore.user && !isPublic) || (!!authStore.user && isPublic)
	);

	$effect(() => {
		if (authStore.loading) return;
		if (!authStore.user && !isPublic) {
			goto(resolve('/login'));
		} else if (authStore.user && isPublic) {
			goto(resolve('/'));
		}
	});
</script>

<svelte:head>
	<link rel="icon" href={favicon} />
</svelte:head>

<Toaster richColors position="bottom-right" />

{#if shouldShowSpinner}
	<div class="min-vh-100 d-flex align-items-center justify-content-center">
		<div class="spinner-border" role="status"></div>
	</div>
{:else}
	{@render children()}
{/if}
