<script lang="ts">
	import Inicio from '../components/Inicio.svelte';
	import Aplicaciones from '../components/Aplicaciones.svelte';
	import Nosotros from '../components/Nosotros.svelte';
	import apps from '../appsArray.json';
</script>

<div class="container">
	<section id="Inicio"><Inicio /></section>
	<section id="Aplicaciones"><Aplicaciones {apps} /></section>
	<section id="Nosotros"><Nosotros /></section>
</div>

<style>
	* {
		margin: 0;
		padding: 0;
		box-sizing: border-box;
	}

	.container {
		text-align: center;
		height: 100%; /* Set the height for the container */
		width: 100%;
		overflow-y: scroll; /* Enable vertical scrolling */
		overflow-x: hidden; /* Disable horizontal scrolling */
		border: 1px solid black;
	}
</style>
