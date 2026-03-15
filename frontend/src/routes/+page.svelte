<script>
	import { onMount } from 'svelte';
	import { sessionApi } from '../lib/api/session';
	import Button from '../lib/components/ui/Button';
	import Modal from '../lib/components/ui/Modal';

	onMount(() => {
		sessionApi
			.get()
			.then((user) => console.log(user))
			.catch((err) => console.error(err));
	});
	let showModal = $state(false);
	let status = $state('idle');
</script>

<main>
	<h1>Hello World</h1>
	<Button variant="outline-secondary">Testing</Button>
	<Button variant="danger" loading>Danger</Button>

	<Button variant="primary" onclick={() => (showModal = true)}>Open Modal</Button>

	<p>Status: {status}</p>

	<Modal
		open={showModal}
		title="Test Modal"
		confirmText="Yes do it"
		onClose={() => {
			showModal = false;
			status = 'cancelled';
		}}
		onConfirm={() => {
			showModal = false;
			status = 'confirmed';
		}}
	>
		Are you sure you want to do the thing?
	</Modal>
</main>
