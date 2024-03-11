<script>
  import { quintOut } from "svelte/easing";
  import { crossfade } from "svelte/transition";
  import { flip } from "svelte/animate";
  import { onMount } from "svelte";

  const [send, receive] = crossfade({
    fallback(node, params) {
      const style = getComputedStyle(node);
      const transform = style.transform === "none" ? "" : style.transform;

      return {
        duration: 600,
        easing: quintOut,
        css: (t) => `
					transform: ${transform} scale(${t});
					opacity: ${t}
				`,
      };
    },
  });

  let chars = [
    { name: "Alex", initiative: 6, ac: null },
    { name: "Aaron", initiative: 16, ac: null },
    { name: "Sam", initiative: 8, ac: null },
  ];

  let inputName = "";
  let inputRoll = 0;
  let inputAC = null;

  let current = null;

  function add(input) {
    const char = {
      name: inputName,
      initiative: inputRoll,
      ac: inputAC,
    };

    console.log(char);
    console.log(chars.map((a) => a.name));
    if (chars.map((a) => a.name).includes(char.name)) {
      let index = chars.findIndex((x) => x.name === char.name);
      chars[index] = char;
    } else {
      chars = [char, ...chars];
    }
    // inputName = "";
    inputRoll = 0;
    // inputAC = null;

    chars.sort((a, b) =>
      a.initiative > b.initiative ? -1 : b.initiative > a.initiative ? 1 : 0,
    );
  }

  function remove(char) {
    if (current === char.name) {
      next();
    }
    chars = chars.filter((c) => c !== char);
  }

  function previous() {
    let currIndex = chars.findIndex((x) => x.name === current);
    let newIndex;
    if (currIndex === 0) {
      newIndex = chars.length - 1;
    } else {
      newIndex = currIndex - 1;
    }
    current = chars[newIndex % chars.length].name;
  }

  function next() {
    let currIndex = chars.findIndex((x) => x.name === current);
    current = chars[(currIndex + 1) % chars.length].name;
  }

  function generate_roll() {
    inputRoll = Math.floor(Math.random() * 20);
  }
</script>

<div class="board">
  <input
    class="new-char-input new-char-name"
    placeholder="Name"
    bind:value={inputName}
    on:keydown={(event) => event.key === "Enter" && add(event.target)}
  />
  <input
    class="new-char-input new-char-roll"
    placeholder="Roll"
    bind:value={inputRoll}
    on:keydown={(event) => event.key === "Enter" && add(event.target)}
  />
  <button on:click={generate_roll}> Generate </button>
  <input
    class="new-char-input new-char-ac"
    placeholder="AC"
    bind:value={inputAC}
    on:keydown={(event) => event.key === "Enter" && add(event.target)}
  />

  <button on:click={add}> Add </button>
  <button on:click={next} style={current === null ? "" : "visibility: hidden;"}>
    START
  </button>
  <button
    on:click={previous}
    style={current === null ? "visibility: hidden;" : ""}
  >
    Prev
  </button>
  <button on:click={next} style={current === null ? "visibility: hidden;" : ""}>
    Next
  </button>

  <div class="order-list">
    <h2>Initiative</h2>
    {#each chars as char, i (char.name)}
      <label
        in:receive={{ key: char.name }}
        out:send={{ key: char.name }}
        animate:flip
        class={current === char.name ? "current" : ""}
      >
        <table style="width: 100%;">
          <tr
            ><td style="width: 70%;">{char.name}</td><td style="width: 10%;"
              >{char.initiative}</td
            ><td style="width: 10%;">{char.ac === null ? "" : char.ac}</td><td
              style="width: 10%;"
            >
              <button on:click={() => remove(char)}>x</button></td
            ></tr
          >
        </table>
      </label>
    {/each}
  </div>
</div>

<style>
  .new-char-input {
    font-size: 1.4em;
    width: 100%;
    margin: 0.5em 0 0.5em 0;
  }

  .board {
    max-width: 36em;
    margin: 0 auto;
  }

  .order-list {
    float: left;
    width: 100%;
    padding: 0 1em 0 0;
    box-sizing: border-box;
  }

  h2 {
    font-size: 2em;
    font-weight: 200;
    user-select: none;
  }

  label {
    top: 0;
    left: 0;
    display: block;
    font-size: 1em;
    line-height: 1;
    padding: 0.5em;
    margin: 0 auto 0.5em auto;
    border-radius: 2px;
    background-color: #eee;
    user-select: none;
    color: black;
  }

  label tr {
    font-size: 1.5em;
  }

  .current {
    background-color: yellow;
  }

  input {
    margin: 0;
  }

  .order-list button {
    float: right;
    height: 1em;
    box-sizing: border-box;
    padding: 0 0.5em;
    line-height: 1;
    background-color: transparent;
    border: none;
    color: rgb(170, 30, 30);
    opacity: 0;
    transition: opacity 0.2s;
  }

  label:hover button {
    opacity: 1;
  }
</style>
