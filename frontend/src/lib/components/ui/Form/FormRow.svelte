<script lang="ts">
  import type { Snippet } from 'svelte'

  interface FormRowProps {
    children: Snippet
    class?: string
  }

  let { children, class: className = '' }: FormRowProps = $props()
</script>

<div class="form-row {className}">
  {@render children()}
</div>