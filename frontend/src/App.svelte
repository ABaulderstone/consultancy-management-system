
<script lang="ts">
  import { Router, Route } from 'svelte-routing'
  import { Toaster } from 'svelte-sonner'
  import LoginPage from './lib/pages/LoginPage';
  import DashboardPage from './lib/pages/DasboardPage';

</script>

<Toaster richColors position="bottom-right" />

<Router>
  <Route path="/login" component={LoginPage} />
  <Route path="/" component={DashboardPage as any} />

</Router>
