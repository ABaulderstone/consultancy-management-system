<script lang="ts">
  import {onMount} from 'svelte';
  import {sessionApi} from './lib/api/session';

  onMount( () => {
    sessionApi.get().then(user => console.log(user)).catch(err => console.error(err))
  })
</script>

<main>
  <h1>Hello World</h1>
</main>

<style>

</style>
