<script lang="ts">
  import type { Snippet } from 'svelte'
  import Button from '../Button'

  interface ModalProps {
    open: boolean
    title?: string
    confirmText?: string
    showClose?: boolean
    loading?: boolean
    onClose?: () => void
    onConfirm?: () => void
    children: Snippet
    footer?: Snippet
  }

  let {
    open,
    title,
    confirmText = 'Confirm',
    showClose = true,
    loading = false,
    onClose,
    onConfirm,
    children,
    footer
  }: ModalProps = $props()

  let dialog: HTMLDialogElement

  $effect(() => {
    if (!dialog) return
    if (open) {
      dialog.showModal()
    } else {
      dialog.close()
    }
  })
</script>

<dialog
  bind:this={dialog}
  class="modal"
  onclose={onClose}
  onclick={(e) => e.target === dialog && onClose?.()}
>
  <div class="modal-dialog" role="document">
    <div class="modal-content">

      {#if title || showClose}
        <div class="modal-header">
          {#if title}
            <h5 class="modal-title">{title}</h5>
          {/if}
          {#if showClose}
            <button
              type="button"
              class="btn-close"
              aria-label="Close"
              onclick={onClose}
            ></button>
          {/if}
        </div>
      {/if}

      <div class="modal-body">
        {@render children()}
      </div>

      <div class="modal-footer">
        {#if footer}
          {@render footer()}
        {:else}
          {#if showClose}
            <Button variant="outline-secondary" onclick={onClose}>
              Cancel
            </Button>
          {/if}
          {#if onConfirm}
            <Button variant="primary" onclick={onConfirm} {loading}>
              {confirmText}
            </Button>
          {/if}
        {/if}
      </div>

    </div>
  </div>
</dialog>

<style>
dialog.modal {
  display: block;
  border: none;
  padding: 0;
  background: transparent;

  &:not([open]) {
    display: none;
  }

  &::backdrop {
    background-color: rgba(0, 0, 0, 0.5);
  }
}
</style>