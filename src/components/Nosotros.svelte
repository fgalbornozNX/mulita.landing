<script>
	import '../global.css';
	import { onMount } from 'svelte';

	let { integrantes } = $props();

    /**
	 * @type {HTMLAudioElement}
	 */
    let easterEggAudio;
    let easterEggPlayed = false;
    
    onMount(() => {
        // Inicializar el objeto de audio
        easterEggAudio = new Audio('/cuicui.mp3');
    });
    
    function playEasterEgg() {
        if (easterEggAudio && !easterEggPlayed) {
            easterEggPlayed = true;
            easterEggAudio.play();
        }
    }
</script>

<section class="about-section">
    <div class="titulo">
        <h1>Nosotros</h1>
    </div>
   
    <div class="cards-container">
        <div class="icon-cards">
            {#each integrantes as integrante, i}
                <button class="icon-cards_item"
                    onclick={() => i === 2 && playEasterEgg()}>
                    <h2>{integrante.nombre}</h2>
                    <img src={integrante.img} alt={integrante.alt} class="integrante-foto"/>
                    <p>{@html integrante.descripcion}</p>
                    {#if i === 2}
                        <a class="eevee-ig" href="https://instagram.com/eeveeivi" aria-label="Instagram" target="_blank" rel="noopener noreferrer">
                            <svg width="32" height="32" style="enable-background:new 0 0 48 48;" version="1.1" viewBox="0 0 48 48" xml:space="preserve" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><g id="Icons"><g id="Icons_8_"><g><linearGradient gradientTransform="matrix(1 0 0 -1 0 50)" gradientUnits="userSpaceOnUse" id="SVGID_1_" x1="24" x2="24" y1="8.71714" y2="43.88022"><stop offset="0.09694" style="stop-color:#FFD879"/><stop offset="0.15387" style="stop-color:#FCCB76"/><stop offset="0.25828" style="stop-color:#F5AA6C"/><stop offset="0.39756" style="stop-color:#E9755E"/><stop offset="0.44898" style="stop-color:#E45F58"/><stop offset="0.67857" style="stop-color:#D22A9C"/><stop offset="1" style="stop-color:#6968DF"/></linearGradient><circle cx="24.00002" cy="24" r="15.34377" style="fill:url(#SVGID_1_);"/><g><path d="M23.99985,27.7154c-2.0488,0-3.7153-1.667-3.7153-3.7158s1.6665-3.7148,3.7153-3.7148      c2.0489,0,3.7159,1.666,3.7159,3.7148S26.04875,27.7154,23.99985,27.7154z M23.99985,21.2848      c-1.497,0-2.7153,1.2177-2.7153,2.7148c0,1.4971,1.2183,2.7158,2.7153,2.7158c1.4976,0,2.7159-1.2187,2.7159-2.7158      C26.71575,22.5025,25.49745,21.2848,23.99985,21.2848z" style="fill:#FFFFFF;"/></g><circle cx="28.24785" cy="19.8909" r="0.4621" style="fill:#FFFFFF;"/><g><path d="M27.19765,31.2643h-6.3955c-2.2427,0-4.0669-1.8243-4.0669-4.0665v-6.3955      c0-2.2431,1.8242-4.0673,4.0669-4.0673h6.3955c2.2427,0,4.0669,1.8242,4.0669,4.0673v6.3955      C31.26455,29.44,29.44035,31.2643,27.19765,31.2643z M20.80215,17.735c-1.6909,0-3.0669,1.3759-3.0669,3.0673v6.3955      c0,1.6905,1.376,3.0665,3.0669,3.0665h6.3955c1.6909,0,3.0669-1.376,3.0669-3.0665v-6.3955c0-1.6914-1.376-3.0673-3.0669-3.0673      H20.80215z" style="fill:#FFFFFF;"/></g></g></g></g></svg>
                            <span>@eeveeivi</span>
                        </a>
                    {/if}
                </button>
            {/each}
        </div>
    </div>
</section>

<style>
    .about-section {
        height: 100vh; /* 100% del alto de la ventana */
        width: 100%;
        box-sizing: border-box;
        position: relative;
        margin-bottom: 10px;
        padding-top: 60px; /* Añadir padding-top para compensar la barra de menú superior */
    }
    
    .titulo {
        margin-top: 60px;
        text-align: center;
    }
    
	h2 {
		font-family: PilcrowRounded-Bold;
	}

    .cards-container {
        width: 100%;
        display: flex;
        justify-content: center;
		margin-bottom: 30px;
    }
    
    .icon-cards {
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
        max-width: 1200px;
        margin: 0 auto;
    }

	.icon-cards button {
		background-color: #c1e6d1;
	}

    .icon-cards button p {
        align-items: center;
        display: flex;
        flex-direction: column;
        justify-content: center;
        text-align: start;
        margin-bottom: 0px;
    }
    
    .icon-cards_item {
        width: 300px;
        margin: 30px;
        text-align: center;
        transition: transform 0.3s ease;
    }
    
    .icon-cards_item:hover {
        transform: translateY(-10px);
    }
    
    .integrante-foto {
        max-width: 100%;
        width: 300px;
        height: auto;
        border-radius: 10px;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
    }

    .eevee-ig {
        display: flex;
        align-items: center;
        justify-content: center; /* Centra horizontalmente el contenido */
        gap: 8px; /* Espaciado entre el SVG y el texto */
        color: inherit; /* Mantiene el color del texto */
    }

    .eevee-ig span {
        display: flex;
        align-items: center;
        justify-content: center; /* Alinea horizontalmente el contenido */
        text-align: center;
    }
    
    /* Media Queries para diseño responsive */
    
    /* Pantallas grandes */
    @media screen and (max-width: 1200px) {
        .icon-cards {
            max-width: 900px;
        }
    }
    
    /* Tablets */
    @media screen and (max-width: 992px) {
        .icon-cards {
            max-width: 700px;
        }
        
        .icon-cards_item {
            width: 250px;
            margin: 20px;
        }
        
        .integrante-foto {
            width: 250px;
        }
    }
    
    /* Tablets pequeñas y móviles grandes */
    @media screen and (max-width: 768px) {
        .about-section {
            height: auto;
            min-height: 100vh;
        }
        
        .icon-cards {
            flex-direction: column;
            align-items: center;
        }
        
        .icon-cards_item {
            width: 80%;
            max-width: 400px;
            margin: 20px 0;
        }
        
        .integrante-foto {
            width: 100%;
        }
    }
    
    /* Móviles */
    @media screen and (max-width: 480px) {
        .titulo {
            margin-top: 30px;
        }
        
        .icon-cards_item {
            width: 90%;
            margin: 15px 0;
        }
        
        .about-section {
            padding-top: 40px;
        }
    }
</style>