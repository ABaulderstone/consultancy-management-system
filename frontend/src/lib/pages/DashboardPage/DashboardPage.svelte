<script lang="ts">

  import Button from '../../components/ui/Button';
  import Modal from '../../components/ui/Modal'




  let showModal = $state(false)
  let status = $state<'idle' | 'confirmed' | 'cancelled'>('idle')
</script>

<main>
  <h1>Hello World</h1>
  <Button variant='outline-secondary'>Testing</Button>
  <Button variant='danger' loading>Danger </Button>

  <Button variant='primary' onclick={() => showModal = true}>
    Open Modal
  </Button>

  <p>Status: {status}</p>

  <Modal
    open={showModal}
    title="Test Modal"
    confirmText="Yes do it"
    onClose={() => {
      showModal = false
      status = 'cancelled'
    }}
    onConfirm={() => {
      showModal = false
      status = 'confirmed'
    }}
  >
  CONTENT
  </Modal>
</main>
