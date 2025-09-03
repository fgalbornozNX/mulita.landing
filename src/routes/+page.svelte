<script lang="ts">
	import Inicio from '../components/Inicio.svelte';
	import Aplicaciones from '../components/Aplicaciones.svelte';
	import Nosotros from '../components/Nosotros.svelte';
	import apps from '../appsArray.json';
	import integrantes from '../integrantesArray.json';
</script>

<div class="text-center h-full w-full overflow-y-scroll overflow-x-hidden box-border">
	<section id="Inicio"><Inicio /></section>
	<section id="Aplicaciones"><Aplicaciones {apps} /></section>
	<section id="Nosotros"><Nosotros {integrantes} /></section>
</div>