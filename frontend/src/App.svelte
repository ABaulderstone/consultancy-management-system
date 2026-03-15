<script lang="ts">
  import {onMount} from 'svelte';
  import {sessionApi} from './lib/api/session';
  import Button from './lib/components/ui/Button';

  onMount( () => {
    sessionApi.get().then(user => console.log(user)).catch(err => console.error(err))
  })
</script>

<main>
  <h1>Hello World</h1>
  <Button variant='outline-secondary'>Testing</Button>
  <Button variant='danger' loading>Danger </Button>
</main>

<style>

</style>
