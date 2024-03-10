<script>
  import Logo from './assets/logo.svg'
  import List from './lib/List.svelte'
</script>

<main>
  <div>
    <a href="https://kgol.xyz" target="_blank" rel="noreferrer">
      <img src={Logo} class="logo" alt="INITRAK Logo" />
    </a>
  </div>
  <h1>INITRAK</h1>

  <div class="card">
    <List />
  </div>

  <p>
  </p>
</main>

<style>
  .logo {
    height: 6em;
    padding: 0.5em;
    will-change: filter;
    transition: filter 300ms;
  }
  .logo:hover {
    filter: drop-shadow(0 0 2em #646cffaa);
  }
  .logo.svelte:hover {
    filter: drop-shadow(0 0 2em #ff3e00aa);
  }
  .read-the-docs {
    color: #888;
  }
</style>
