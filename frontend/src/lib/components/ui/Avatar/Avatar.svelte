<script lang="ts">
	import { FontAwesomeIcon } from '@fortawesome/svelte-fontawesome';
	import { faUser } from '@fortawesome/free-solid-svg-icons';
	import type { IconDefinition } from '@fortawesome/free-solid-svg-icons';

	interface AvatarProps {
		icon?: IconDefinition;
		size?: number;
		class?: string;
	}

	let { icon = faUser, size = 80, class: className = '' }: AvatarProps = $props();
</script>

<div
	class="rounded-circle bg-secondary d-flex align-items-center justify-content-center {className}"
	style="width: {size}px; height: {size}px; flex-shrink: 0;"
>
	<FontAwesomeIcon {icon} class="text-white fa-2x" />
</div>
