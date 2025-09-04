<script lang="ts">
	import Inicio from '../components/Inicio.svelte';
	import Aplicaciones from '../components/Aplicaciones.svelte';
	import Nosotros from '../components/Nosotros.svelte';
	import apps from '../appsArray.json';
	import integrantes from '../integrantesArray.json';
</script>

<div class="text-center h-full w-full overflow-y-scroll overflow-x-hidden box-border snap-y snap-mandatory">
	<section id="Inicio" class="snap-start"><Inicio /></section>
	<section id="Aplicaciones" class="snap-start"><Aplicaciones {apps} /></section>
	<section id="Nosotros" class="snap-start"><Nosotros {integrantes} /></section>
</div>