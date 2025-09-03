<script lang="ts">
    import { onDestroy, onMount } from 'svelte';
    import '../global.css';

    let { children } = $props();

    const sections = ['Inicio', 'Aplicaciones', 'Nosotros'];
    let observer: IntersectionObserver;
    let activeSection = $state('Inicio'); // Variable para la sección activa

    // Función para cambiar la sección activa
    function setActiveSection(section: string) {
        activeSection = section;
        const element = document.getElementById(section);
        if (element) {
            element.scrollIntoView({ behavior: 'smooth' });
        }
    }
    onMount(() => {
        const options = {
            root: null,
            rootMargin: '0px',
            threshold: window.innerWidth <= 768 ? 0.3 : 0.6 // Se considera "visible" cuando al menos el X% de la sección está en pantalla
        };
        observer = new IntersectionObserver((entries) => {
            for (const entry of entries) {
                if (entry.isIntersecting) {
                    const id = entry.target.id;
                    if (sections.includes(id)) {
                        activeSection = id;
                    }
                }
            }
        }, options);
        // Observar cada sección
        for (const id of sections) {
            const sectionEl = document.getElementById(id);
            if (sectionEl) {
                observer.observe(sectionEl);
            }
        }
    });
    onDestroy(() => {
        if (observer) observer.disconnect();
    });
</script>

<svelte:head>
    <link rel="preload" href="/fonts/PilcrowRounded-Bold.woff" as="font" type="font/woff" crossorigin="anonymous">
</svelte:head>


<div class="fixed top-0 right-0 w-[100vw] flex flex-row h-[min(8vh,60px)] min-h-[45px] menu md:justify-end">
    <button class:selected={activeSection === 'Inicio'}         onclick={() => setActiveSection('Inicio')}>Inicio</button>
    <button class:selected={activeSection === 'Aplicaciones'}   onclick={() => setActiveSection('Aplicaciones')}>Aplicaciones</button>
    <button class:selected={activeSection === 'Nosotros'}       onclick={() => setActiveSection('Nosotros')}>Nosotros</button>
</div>
{@render children()}


<style>
    @font-face {
        font-family: 'PilcrowRounded-Bold';
        src:
            url('/fonts/PilcrowRounded-Bold.woff') format('woff'),
            url('/fonts/PilcrowRounded-Bold.ttf') format('truetype');
        font-weight: 700;
        font-display: block;
        font-style: normal;
    }
    
    * {
        font-family: PilcrowRounded-Bold;
        box-sizing: border-box;
    }
    
    .menu {
        /* justify-content: flex-end; /* Alinea los botones a la derecha */
        gap: 10px;
        background-color: rgba(52, 50, 51, 0.82);/* Fondo semi-transparente */
        padding: 10px 20px; /* Más padding a los lados para dar espacio */
        z-index: 1000; /* Asegura que siempre esté por encima */
    }
    
    /* Ajustes para los botones */
    .menu button {
        background-color: transparent;
        color: var(--text-color);
        border: none;
        outline: none;
        font-size: min(1.4rem, 5vh);
        line-height: 1;
        cursor: pointer;
        transition:
			background-color 0.3s ease,
            transform 0.3s ease;
        border-radius: 12px;
        min-width: 140px;
    }
    
    /* Cuando se selecciona una sección */
    .menu button.selected {
        color: var(--secondary-color);
        transform: scale(1.3);
    }
    
    /* Estilos para pantallas pequeñas */
    @media (max-width: 768px) {
        .menu {
            flex-direction: row;
            justify-content: center; /* Centrar los botones horizontalmente */
            padding: 10px;
            width: 100%;
        }
        
        .menu button {
            flex: 1; /* Hace que cada botón ocupe una parte proporcional del espacio disponible */
            min-width: unset; /* Elimina el ancho mínimo fijo */
        }
    }

    @media (max-width: 480px) {
        .menu {
            justify-content: space-between; /* Distribuye los botones uniformemente */
        }
        
        .menu button {
            font-size: clamp(2.4vw, 4.6vw, 1.4rem); /* Texto adaptable */
        }
        
        .menu button.selected {
            transform: unset; /* elimina el escalado del botón en pantalla pequeñas */
        }
    }
</style>