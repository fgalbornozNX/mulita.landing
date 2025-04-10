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
            threshold: 0.6 // Se considera "visible" cuando al menos el 60% de la sección está en pantalla
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

<div class="container">
    <div class="menu">
        <button class:selected={activeSection === 'Inicio'} onclick={() => setActiveSection('Inicio')}>
            Inicio
        </button>
        <button
            class:selected={activeSection === 'Aplicaciones'}
            onclick={() => setActiveSection('Aplicaciones')}
        >
            Aplicaciones
        </button>
        <button
            class:selected={activeSection === 'Nosotros'}
            onclick={() => setActiveSection('Nosotros')}
        >
            Nosotros
        </button>
    </div>
</div>
{@render children()}

<style>
    @font-face {
        font-family: 'PilcrowRounded-Bold';
        src:
            url('/fonts/PilcrowRounded-Bold.woff') format('woff'),
            url('/fonts/PilcrowRounded-Bold.ttf') format('truetype');
        font-weight: 700;
        font-display: swap;
        font-style: normal;
    }
    
    * {
        font-family: PilcrowRounded-Bold;
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }
    
    .menu {
        position: fixed;
        top: 0; /* Cambiado de bottom a top */
        right: 0;
        width: 100%;
        display: flex;
        flex-direction: row;
        justify-content: flex-end; /* Alinea los botones a la derecha */
        gap: 10px;
        background-color: rgba(52, 50, 51, 0.9); /* Fondo semi-transparente */
        padding: 10px 20px; /* Más padding a los lados para dar espacio */
        z-index: 1000; /* Asegura que siempre esté por encima */
    }
    
    /* Ajustes para los botones */
    .menu button {
		background-color: rgba(52, 50, 51, 0.9); /* Fondo semi-transparente */
        /* background-color: var(--secondary-background); */
        color: #ffffff;
        border: none;
        padding: 12px 20px;
        font-size: 1.4rem;
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
    
    /* Evitar que el contenido quede tapado */
    .container {
        padding-top: 60px; /* Cambiado de padding-bottom a padding-top */
    }
    
    /* Estilos para pantallas pequeñas */
    @media (max-width: 768px) {
        .menu {
            flex-wrap: wrap; /* Permitir que los botones bajen si no entran */
            padding: 10px;
        }
        
        .menu button {
            min-width: 100px; /* Botones más pequeños */
            font-size: 1rem;
        }
    }
    
    @media (max-width: 370px) {
        .menu {
            flex-wrap: nowrap; /* Permitir que los botones bajen si no entran */
            padding: 1px;
        }
        
        .menu button {
            min-width: 75px; /* Botones más pequeños */
            font-size: 0.8rem;
        }
        
        .menu button.selected {
            transform: scale(1.05);
        }
    }
</style>