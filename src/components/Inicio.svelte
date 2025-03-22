<script lang="ts">
    import { onMount } from "svelte";
    import gsap from "gsap";

    let imgSrc = '/mulita.webp';
    let imgAlt = 'Logo Mulita App';

    // Probando GSAP
    onMount(() => {
        var tl = gsap.timeline();
        tl.to(".logo", { duration: 1.5, y: 15, rotation: 1 })
          .to(".logo", { duration: 1.5, y: 0, rotation: 0 })
    });
</script>

<style>
    /* Estilo del logo y el título */
    .cuerpo {
        font-size: 3rem;
        font-weight: bold;
        color: #FFFFFF;
        /* margin-bottom: 2rem; /* Espacio adicional para que el título no quede tapado */
    }
    
    .logo {
        width: 60%; /* Ajusta el tamaño en función del 60% del ancho de la pantalla */
        max-width: 800px; /* Limita el tamaño máximo */
        height: auto;
        border-radius: 25%;
        margin-bottom: 0px;
    }

    .cuerpo p {
        margin-top: 0.5rem; /* Espacio entre el logo y el título */
    }
    
    /* Media query para pantallas más grandes */
    @media (min-width: 1366px) {
        .logo {
            width: 70%; /* Aún más pequeño en pantallas grandes */
        }
    }
    
    /* Media query para dispositivos móviles */
    @media (max-width: 768px) {
        .logo {
            width: 80%; /* Logo más grande en pantallas pequeñas */
        }
    }

    /* Estilo para la sección Inicio para no quedar tapada por el menú */
    .inicio-section {
        padding-bottom: 60px; /* Agrega espacio para que el menú no tape el contenido */
    }
</style>

<div class="inicio-section">
    <div class="cuerpo">
        <img class="logo" src={imgSrc} alt={imgAlt} />
        <p>Mulita App</p>
    </div>
</div>
