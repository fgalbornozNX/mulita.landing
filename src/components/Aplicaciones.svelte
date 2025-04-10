<script lang="ts">
    import '../global.css';
    let { apps } = $props();
</script>

<div class="titulo">
    <h1>Aplicaciones</h1>
</div>

<div class="carousel-container">
    <!-- Carrusel de tarjetas -->
    <div class="icon-cards">
        <div class="icon-cards__content">
            {#each apps as app, i}
                <div class="icon-cards__item aplicacion-card">
                    <div class="aplicacion-titulo">
                        <h2>{app.titulo}</h2>
                    </div>
                    <div class="aplicacion-container">
                        <div class="aplicacion-container-detalles">
                            <img src={app.img} alt={app.alt} class="aplicacion-logo" />
                            <div class="aplicacion-info">
                                <p>{app.descripcion}</p>
                                <button>Saber más</button>
                            </div>
                        </div>
                    </div>
                </div>
            {/each}
        </div>
    </div>
</div>

<style>
    .titulo,
    .aplicacion-titulo {
        width: 100%;
        color: var(--primary-color);
        text-align: center;
        margin-bottom: 10px;
    }
    
    h1 {
        margin: 0px;
        font-size: 2rem;
        font-family: PilcrowRounded-Bold;
        color: var(--primary-color);
    }
    
    h2 {
        margin: 0px;
        font-family: PilcrowRounded-Bold;
        color: #ffffff;
    }
    
    /* Contenedor del carrusel */
    .carousel-container {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        margin: 40px 0;
    }
    
    /* Cards Carousel */
    .icon-cards {
        position: relative;
        width: 60vw;
        height: 40vw;
        max-width: 500px;
        max-height: 380px;
        margin: 0 auto;
        color: white;
        perspective: 1000px;
        transform-origin: center;
    }
    
    /* Elemento que rota con la animación */
    .icon-cards__content {
        position: absolute;
        width: 100%;
        height: 100%;
        transform-origin: center;
        transform-style: preserve-3d;
        transform: translateZ(-30vw) rotateY(0);
        animation: carousel 15s infinite cubic-bezier(0.77, 0, 0.175, 1) forwards;
    }
    
    /* Tarjetas individuales */
    .icon-cards__item {
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        width: 60vw;
        height: 40vw;
        max-width: 500px;
        max-height: 380px;
        box-shadow: 0 5px 20px rgba(0,0,0,.1);
        border-radius: 10px;
        transform-origin: center;
        background: var(--secondary-background);
        padding: 20px;
        display: flex;
        flex-direction: column;
        overflow: auto;
    }
    
    /* Posicionamiento 3D de las tarjetas */
    .icon-cards__item:nth-child(1) {
        transform: rotateY(0) translateZ(35vw);
    }
    
    .icon-cards__item:nth-child(2) {
        transform: rotateY(120deg) translateZ(35vw);
    }
    
    .icon-cards__item:nth-child(3) {
        transform: rotateY(240deg) translateZ(35vw);
    }
    
    /* Si hay más de 3 tarjetas, las ocultamos hasta que roten */
    .icon-cards__item:nth-child(n+4) {
        opacity: 0;
        visibility: hidden;
    }
    
    /* Animación del carrusel */
    @keyframes carousel {
        0%,  17.5%  { transform: translateZ(-35vw) rotateY(0); }
        27.5%, 45%  { transform: translateZ(-35vw) rotateY(-120deg); }
        55%, 72.5%  { transform: translateZ(-35vw) rotateY(-240deg); }
        82.5%, 100% { transform: translateZ(-35vw) rotateY(-360deg); }
    }
    
    /* Estilos para el contenido de las tarjetas */
    .aplicacion-container-detalles {
        display: flex;
        align-items: center;
        justify-content: flex-start;
        gap: 15px;
        margin-top: 15px;
    }
    
    .aplicacion-container {
        text-align: center;
        margin-top: 10px;
    }
    
    .aplicacion-container-detalles button {
        background: var(--primary-color);
        color: #343233;
        border: none;
        padding: 10px 20px;
        border-radius: 5px;
        cursor: pointer;
        font-weight: bold;
        transition:
            background 0.3s ease-in-out,
            transform 0.2s ease-in-out;
    }
    
    .aplicacion-container-detalles button:hover {
        background: var(--primary-color);
        transform: scale(1.05);
    }
    
    .aplicacion-logo {
        width: 80px;
        height: 80px;
    }
    
    .aplicacion-info {
        flex: 1;
    }
    
    p {
        color: #979595;
        margin-top: 0;
    }
    
    /* Estilos responsivos */
    @media (max-width: 768px) {
        .icon-cards {
            width: 80vw;
            height: 60vw;
            max-height: 450px;
        }
        
        .icon-cards__item {
            width: 80vw;
            height: 60vw;
            max-height: 450px;
        }
        
        .aplicacion-container-detalles {
            flex-direction: column;
            align-items: center;
            text-align: center;
        }
        
        .aplicacion-info {
            margin-left: 0;
        }
    }
    
    @media (max-width: 480px) {
        .icon-cards {
            width: 90vw;
            height: 70vw;
            min-height: 350px;
        }
        
        .icon-cards__item {
            width: 90vw;
            height: 70vw;
            min-height: 350px;
        }
        
        .aplicacion-logo {
            width: 60px;
            height: 60px;
        }
    }
</style>