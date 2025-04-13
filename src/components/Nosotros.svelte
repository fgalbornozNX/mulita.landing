<script>
	import '../global.css';
	import { onMount } from 'svelte';

	let { integrantes } = $props();

    /**
	 * @type {HTMLAudioElement}
	 */
    let easterEggAudio;
    
    onMount(() => {
        // Inicializar el objeto de audio
        easterEggAudio = new Audio('/cuicui.mp3');
    });
    
    function playEasterEgg() {
        if (easterEggAudio) {
            easterEggAudio.currentTime = 0; // Reinicia el audio si ya estaba reproduciéndose
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
                    <img src={integrante.img} alt={integrante.alt} class="integrante-foto" />
                    <p>{@html integrante.descripcion}</p>
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