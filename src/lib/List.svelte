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
    { name: "Alex", initiative: 100, modifier: 0, ac: null },
    { name: "Aaron", initiative: 100, modifier: 0, ac: null },
    { name: "Sam", initiative: 100, modifier: 0, ac: null },
  ];

  let inputName = "";
  let inputRoll = 0;
  let inputAC = null;
  let modifier = 0;

  let current = null;

  function sort_chars() {
    chars.sort((a, b) =>
      a.initiative > b.initiative ? -1 : b.initiative > a.initiative ? 1 : 0,
    );
  }

  function add(input) {
    const char = {
      name: inputName,
      // For some reason JS recasts inputRoll as a string when bound to a text field input
      // This breaks the numeric sorting and makes it alpha sorting
      // But the linter does not know this is happening and thus complains about the use of this function >:(
      // @ts-ignore
      initiative: parseInt(inputRoll),
      modifier: parseInt(modifier),
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
    modifier = 0;
    // inputAC = null;

    sort_chars();
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
    inputRoll = Math.floor(Math.random() * 20) + parseInt(modifier);
  }

  function reroll_all() {
    for (let i = 0; i < chars.length; i++) {
      chars[i].initiative = Math.floor(Math.random() * 20) + chars[i].modifier;
    }
    sort_chars();
  }

function LOAD_wolves_of_welton_1() {
  chars = [
    { name: "Alex", initiative: 100, modifier: 0, ac: null },
    { name: "Aaron", initiative: 100, modifier: 0, ac: null },
    { name: "Sam", initiative: 100, modifier: 0, ac: null },
    { name: "Wolf 1", initiative: 0, modifier: 2, ac: 13 },
    { name: "Wolf 2", initiative: 0, modifier: 2, ac: 13 },
    { name: "Wolf 3", initiative: 0, modifier: 2, ac: 13 },
    { name: "Wolf 4", initiative: 0, modifier: 2, ac: 13 },
    { name: "Wolf 5", initiative: 0, modifier: 2, ac: 13 },
    { name: "Wolf 6", initiative: 0, modifier: 2, ac: 13 },
    { name: "Wolf 7", initiative: 0, modifier: 2, ac: 13 },
    { name: "Wolf 8", initiative: 0, modifier: 2, ac: 13 },
    { name: "Sheep 1", initiative: 0, modifier: 0, ac: 10 },
    { name: "Sheep 2", initiative: 0, modifier: 0, ac: 10 },
    { name: "Sheep 3", initiative: 0, modifier: 0, ac: 10 },
    { name: "Sheep 4", initiative: 0, modifier: 0, ac: 10 },
    { name: "Sheep 5", initiative: 0, modifier: 0, ac: 10 },
    { name: "Sheep 6", initiative: 0, modifier: 0, ac: 10 },
    { name: "Sheep 7", initiative: 0, modifier: 0, ac: 10 },
    { name: "Sheep 8", initiative: 0, modifier: 0, ac: 10 },
    { name: "Shepard 1", initiative: 0, modifier: 0, ac: 10 },
    { name: "Shepard 2", initiative: 0, modifier: 0, ac: 10 },
  ];
}

  function LOAD_wolves_of_welton_2() {
    chars = [
      { name: "Alex", initiative: 100, modifier: 0, ac: null },
      { name: "Aaron", initiative: 100, modifier: 0, ac: null },
      { name: "Sam", initiative: 100, modifier: 0, ac: null },
      { name: "Wolf 1", initiative: 0, modifier: 2, ac: 13 },
      { name: "Wolf 2", initiative: 0, modifier: 2, ac: 13 },
      { name: "Wolf 3", initiative: 0, modifier: 2, ac: 13 },
      { name: "Wolf 4", initiative: 0, modifier: 2, ac: 13 },
      { name: "Wolf 5", initiative: 0, modifier: 2, ac: 13 },
      { name: "Wolf 6", initiative: 0, modifier: 2, ac: 13 },
      { name: "Wolf 7 - Pup Guard", initiative: 0, modifier: 2, ac: 13 },
      { name: "Wolf 8 - Pup Guard", initiative: 0, modifier: 2, ac: 13 },
      { name: "Blaze", initiative: 0, modifier: 2, ac: 14 },
      { name: "Bolt", initiative: 0, modifier: 2, ac: 14 },
    ];
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
  <input
    class="new-char-input new-char-mod"
    placeholder="Modifier"
    bind:value={modifier}
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
  <hr />
  <div class="order-list">
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

  <button on:click={reroll_all}> RE-ROLL ALL </button>
  <hr />
  <h2>Load Prerolled Encounter</h2>
  <button on:click={LOAD_wolves_of_welton_1}> Wolves of Welton 1 </button>
  <button on:click={LOAD_wolves_of_welton_2}> Wolves of Welton 2 </button>
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
    padding: 1em 0 0 0;
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
