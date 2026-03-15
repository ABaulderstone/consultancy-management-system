<script lang="ts">
  import type { Snippet } from 'svelte'

  interface FormGroupProps {
    children: Snippet
    label?: string
    error?: string
    col?: string
    class?: string
    for?: string
  }

  let { children, label, error, col, class: className = '', for: forAttr }: FormGroupProps = $props()
</script>

<div class="form-group {col ?? ''} {className}">
  {#if label}
    <label for={forAttr} class="form-label fw-bold">{label}</label>
  {/if}
  {@render children()}
  {#if error}
    <div class="invalid-feedback d-block">{error}</div>
  {/if}
</div>