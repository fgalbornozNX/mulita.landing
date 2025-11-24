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
            //easterEggPlayed = true; // Evitar que se reproduzca más de una vez
            easterEggAudio.currentTime = 0;
            easterEggAudio.play();
        }
    }
</script>

<section class="nosotros-section">
    <div class="cuerpo">
        <h1>Nosotros</h1>

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
    </div>
</section>

<style>
    .nosotros-section {
        width: 100%;
        min-height: 100vh;
        display: flex;
        align-items: center;
        padding: 2rem 0;
    }

    .cuerpo {
        width: 100%;
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 2rem;
    }
    
	h2 {
		font-family: PilcrowRounded-Bold;
        color: var(--text-color);
        margin-bottom: 1rem;
        font-size: 1.5rem;
	}

    .cards-container {
        width: 100%;
        display: flex;
        justify-content: center;
		margin-top: 3rem;
    }
    
    .icon-cards {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
        gap: 2rem;
        width: 100%;
        padding: 1rem;
    }

	.icon-cards_item {
        background: linear-gradient(135deg, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0.05) 100%);
        backdrop-filter: blur(10px);
        border: 1px solid rgba(255,255,255,0.1);
        border-radius: 20px;
        padding: 2rem;
        text-align: center;
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        position: relative;
        overflow: hidden;
        box-shadow: 
            0 8px 32px rgba(0,0,0,0.1),
            0 2px 8px rgba(0,0,0,0.05);
        cursor: pointer;
    }

    .icon-cards_item::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 3px;
        background: linear-gradient(90deg, var(--primary-color) 0%, var(--secondary-color) 100%);
        transform: scaleX(0);
        transition: transform 0.3s ease;
        transform-origin: left;
    }

    .icon-cards_item:hover::before {
        transform: scaleX(1);
    }

    .icon-cards_item:hover {
        transform: translateY(-12px) scale(1.02);
        box-shadow: 
            0 20px 40px rgba(0,0,0,0.15),
            0 8px 16px rgba(0,0,0,0.1);
        border-color: rgba(var(--primary-color), 0.3);
        background: linear-gradient(135deg, rgba(255,255,255,0.15) 0%, rgba(255,255,255,0.08) 100%);
    }

    .icon-cards_item p {
        color: var(--text-color);
        line-height: 1.6;
        margin: 1rem 0 0 0;
        font-size: 0.95rem;
        opacity: 0.9;
    }
    
    .integrante-foto {
        width: 200px;
        height: 200px;
        object-fit: cover;
        border-radius: 50%;
        border: 4px solid rgba(255,255,255,0.1);
        box-shadow: 
            0 8px 25px rgba(0,0,0,0.15),
            inset 0 1px 0 rgba(255,255,255,0.1);
        transition: all 0.3s ease;
        margin: 0 auto 1.5rem auto;
        display: block;
    }

    /* Ajustes específicos de posición para cada foto */
    .integrante-foto[src="/Fer.jpg"] {
        object-position: center 20%; /* Muestra más la parte superior */
    }

    .integrante-foto[src="/Peti.jpg"] {
        object-position: center 35%; /* Sube ligeramente la imagen */
    }

    .integrante-foto[src="/Eevee.jpg"] {
        object-position: center center; /* Mantiene centrada (por defecto) */
    }

    .icon-cards_item:hover .integrante-foto {
        transform: scale(1.05);
        border-color: var(--secondary-color);
        box-shadow: 
            0 12px 35px rgba(0,0,0,0.2),
            0 0 0 2px var(--secondary-color),
            inset 0 1px 0 rgba(255,255,255,0.2);
    }

    .eevee-ig {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
        margin-top: 1rem;
        padding: 0.5rem 1rem;
        background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
        color: white;
        text-decoration: none;
        border-radius: 25px;
        transition: all 0.3s ease;
        font-weight: 600;
        font-size: 0.9rem;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }

    .eevee-ig:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        background: linear-gradient(135deg, var(--secondary-color) 0%, var(--primary-color) 100%);
    }

    .eevee-ig svg {
        width: 20px;
        height: 20px;
        transition: transform 0.3s ease;
    }

    .eevee-ig:hover svg {
        transform: rotate(10deg) scale(1.1);
    }
    
    /* Media Queries para diseño responsive */
    
    /* Tablets grandes */
    @media screen and (max-width: 1024px) {
        .icon-cards {
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
        }
        
        .icon-cards_item {
            padding: 1.5rem;
        }
        
        .integrante-foto {
            width: 180px;
            height: 180px;
        }
    }
    
    /* Tablets */
    @media screen and (max-width: 768px) {
        .cuerpo {
            padding: 0 1rem;
        }
        
        .icon-cards {
            grid-template-columns: 1fr;
            gap: 1.5rem;
            max-width: 400px;
            margin: 0 auto;
        }
        
        .icon-cards_item {
            padding: 2rem 1.5rem;
        }
        
        .integrante-foto {
            width: 160px;
            height: 160px;
        }
    }
    
    /* Móviles */
    @media screen and (max-width: 480px) {
        .nosotros-section {
            padding: 1rem 0;
        }
        
        .cuerpo {
            padding: 0 0.5rem;
        }
        
        .icon-cards {
            max-width: 100%;
            gap: 1rem;
        }
        
        .icon-cards_item {
            padding: 1.5rem 1rem;
            margin: 0;
        }
        
        .integrante-foto {
            width: 140px;
            height: 140px;
        }
        
        h2 {
            font-size: 1.25rem;
        }
        
        .icon-cards_item p {
            font-size: 0.9rem;
        }
    }
</style>