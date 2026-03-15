<script lang="ts">
  import type { HTMLInputAttributes } from 'svelte/elements'

  interface FormInputProps extends HTMLInputAttributes {
    error?: boolean
    value: unknown
  }

  let { error = false, value = $bindable(), class: className, ...rest }: FormInputProps = $props()
</script>

<input
  class="form-control {error ? 'is-invalid' : ''} {className ?? ''}"
  bind:value
  {...rest}
/>