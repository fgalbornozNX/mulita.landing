<script lang="ts">
	import Inicio from "../components/Inicio.svelte";
    import Aplicaciones from "../components/Aplicaciones.svelte";
    import Nosotros from "../components/Nosotros.svelte";  

    // Este array se podría cargar desde una API genérica de mulita
    let apps = [
        {img: '/mulita.webp', alt: 'Mulita Web', titulo: 'Mulita Web', descripcion: 'Este sitio web 😊'},
        {img: '/logoHogar.png', alt: 'Logo Hogar', titulo: 'Mulita Hogar', descripcion: 'Proyecto de IoT para manejo eficiente de luces y equipos eléctricos en el hogar'},
        {img: '/caracol.png', alt: 'Logo Caracol', titulo: 'Mulita Riego', descripcion: 'Sistema simple de riego utilizando arduino y sensores de humedad'},
        {img: '/logoPetunia.png', alt: 'Logo Petuña', titulo: 'Mulita Finanzas', descripcion: 'Aplicación para control de finanzas personales y familiares'},
        {img: '/mulita.webp', alt: 'Logo Prode', titulo: 'Mulita Prode', descripcion: 'Aplicación prode (o penca) para jugar con amigos y predecir resultados deportivos'},
        {img: '/Luz_switch_on.png', alt: 'Logo Luz', titulo: 'Mulita Otro 1', descripcion: 'Aplicación para controlar interruptores de luz'},
        {img: '/temperatura.png', alt: 'Logo Temperatura', titulo: 'Mulita Otro 2', descripcion: 'Aplicación para controlar sensores de temperatura'},
    ];
</script>

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
        border: 1px solid black;
    }
</style>

<div class="container">
    <section id="Inicio"><Inicio /></section>
    <section id="Aplicaciones"><Aplicaciones {apps}/></section>
    <section id="Nosotros"><Nosotros /></section>
</div>