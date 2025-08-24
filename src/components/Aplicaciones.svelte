<script lang="ts">
    import { onMount, onDestroy } from 'svelte';
    import '../global.css';
    
    let { apps } = $props();

    // Constantes de configuración
    const DEFAULT_CARD_COUNT = 6;                // Número fijo de tarjetas en el carrusel
    const ROTATION_INTERVAL = 2000;      // Intervalo de rotación automática en ms
    const ANIMATION_DURATION = 600;      // Duración de la animación en ms
    const SWIPE_THRESHOLD = 50;          // Umbral para detectar deslizamiento
    const CAROUSEL_RADIUS = 250;         // Radio del carrusel en px

    let cardCount = $state(Math.min(DEFAULT_CARD_COUNT, apps.length));
    let ANGLE_PER_CARD = $derived(360 / cardCount); // por defecto, 60º

    // Para permitir animaciones CSS basadas en variables
    const cssVariables = {
        '--animation-duration': `${ANIMATION_DURATION}ms`,
        '--carousel-radius': `${CAROUSEL_RADIUS}px`,
    };
    
    // Estado del carrusel
    let isMobile = $state(false);
    let currentPage = $state(0);
    let isAnimating = $state(false);
    let isPaused = $state(false);
    let totalPages: number = $state(apps.length);
    
    // Estado visual
    let rotationAngle = $state(0);
    let clickedPrev = $state(false);
    let clickedNext = $state(false);
    let disableTransition = $state(false);

    // Timeouts
    let animationTimeout: ReturnType<typeof setTimeout> | null = null;
    let pauseTimeout: ReturnType<typeof setTimeout> | null = null;
    let buttonTimeout: ReturnType<typeof setTimeout> | null = null;
    
    // Elementos visibles actuales (6 tarjetas)
    let visibleApps = $state(apps.slice(0, DEFAULT_CARD_COUNT));
    
    // Manejar cambio de página
    function updateVisibleApps() {
        // Aseguramos que siempre tengamos cardCount tarjetas visibles (o menos si no hay tantas apps)
        cardCount = Math.min(DEFAULT_CARD_COUNT, apps.length);
        ANGLE_PER_CARD = 360 / cardCount;
        
        let visibleCount = Math.min(cardCount, apps.length);
        let cards = [];
        
        for (let i = 0; i < visibleCount; i++) {
            // Calculamos el índice real considerando el currentPage como punto de inicio
            let index = (currentPage + i) % totalPages;
            cards.push(apps[index]);
        }
        
        visibleApps = cards;
        rotationAngle = 0;
    }
    
    // Rotación
    function goToNextPage() {
        if (isAnimating) return;
        isAnimating = true;
        stopAutoRotation();

        // Animación temporal: rotar una ranura hacia la izquierda
        rotationAngle = -ANGLE_PER_CARD;
        
        animationTimeout && clearTimeout(animationTimeout);
        animationTimeout = setTimeout(() => {
            // Desactivar transición para el "swap" instantáneo de tarjetas
            disableTransition = true;
            currentPage = (currentPage + 1) % totalPages;
            updateVisibleApps();
            requestAnimationFrame(() => {
                disableTransition = false;
                isAnimating = false;
                startAutoRotation();
            });
        }, ANIMATION_DURATION);
        
        //pauseAutoRotation();
    }
    
    function goToPrevPage() {
        if (isAnimating) return;
        isAnimating = true;
        stopAutoRotation();

        // Animación temporal: rotar una ranura hacia la derecha
        rotationAngle = ANGLE_PER_CARD;

        animationTimeout && clearTimeout(animationTimeout);
        animationTimeout = setTimeout(() => {
            disableTransition = true;
            currentPage = (currentPage - 1 + totalPages) % totalPages;
            updateVisibleApps();
            requestAnimationFrame(() => {
                disableTransition = false;
                isAnimating = false;
                startAutoRotation();
            });
        }, ANIMATION_DURATION);
        
        //pauseAutoRotation();
    }
    
    function goToPage(pageIndex: number) {
        if (isAnimating || pageIndex === currentPage) return;
        isAnimating = true;
        stopAutoRotation();
        
        // Calcular la distancia mínima en pasos entre currentPage y pageIndex (en el anillo de apps)
        let diff = ((pageIndex - currentPage) % totalPages + totalPages) % totalPages;
        if (diff > totalPages / 2) {
            diff = diff - totalPages; // convierte a valor negativo cuando conviene ir hacia atrás
        }
        
        // Animamos la rotación temporalmente por diff pasos (puede ser negativo)
        rotationAngle = -diff * ANGLE_PER_CARD;

        animationTimeout && clearTimeout(animationTimeout);
        animationTimeout = setTimeout(() => {
            disableTransition = true;
            currentPage = pageIndex;
            updateVisibleApps();
            requestAnimationFrame(() => {
                disableTransition = false;
                isAnimating = false;
                startAutoRotation();
            });
        }, ANIMATION_DURATION);
        
        //pauseAutoRotation();
    }
    
    // Auto rotación
    let autoRotationInterval: ReturnType<typeof setInterval> | null = null;
    
    function startAutoRotation() {
        autoRotationInterval && clearInterval(autoRotationInterval);
        
        autoRotationInterval = setInterval(() => {
            if (!isPaused && !isAnimating) {
                goToNextPage();
            }
        }, ROTATION_INTERVAL);
    }
    
    function stopAutoRotation() {
        if (autoRotationInterval) {
            clearInterval(autoRotationInterval);
            autoRotationInterval = null;
        }
    }
    
    function pauseAutoRotation(delay: number = 4000) {
        isPaused = true;

        pauseTimeout && clearTimeout(pauseTimeout);

        pauseTimeout = setTimeout(() => {
            isPaused = false;
        }, delay);
    }
    
    // Gestión de eventos táctiles
    let touchStartX = 0;
    let touchEndX = 0;
    
    function handleTouchStart(e: TouchEvent) {
        touchStartX = e.touches[0].clientX;
        touchEndX = touchStartX;
        stopAutoRotation();
    }
    
    function handleTouchMove(e: TouchEvent) {
        touchEndX = e.touches[0].clientX;
    }
    
    function handleTouchEnd() {
        const deltaX = touchEndX - touchStartX;
        
        if (Math.abs(deltaX) > SWIPE_THRESHOLD) {
            deltaX < 0 ? goToNextPage() : goToPrevPage();
        }
        
        setTimeout(startAutoRotation, 3000);
    }
    
    // Animación de botones
    function animateButton(direction: 'prev' | 'next') {
        if (direction === 'prev') {
            clickedPrev = true;
            goToPrevPage();

            if (buttonTimeout) {
                clearTimeout(buttonTimeout);
            }

            buttonTimeout = setTimeout(() => {
                clickedPrev = false;
            }, ANIMATION_DURATION * 0.75);

        } else {
            clickedNext = true;
            goToNextPage();

            if (buttonTimeout) {
                clearTimeout(buttonTimeout);
            }

            buttonTimeout = setTimeout(() => {
                clickedNext = false;
            }, ANIMATION_DURATION * 0.75);
        }
    }
    
    // Efectos de montaje/desmontaje
    onMount(() => {
        updateVisibleApps();
        startAutoRotation();
        
        // Detectar tipo de dispositivo
        const checkMobile = () => {
            isMobile = window.innerWidth <= 768;
        };
        
        checkMobile();
        window.addEventListener('resize', checkMobile);
        
        return () => {
            window.removeEventListener('resize', checkMobile);
            stopAutoRotation();
        };
    });
    
    onDestroy(() => {
        isAnimating = false;
        stopAutoRotation();
        animationTimeout && clearTimeout(animationTimeout);
        pauseTimeout && clearTimeout(pauseTimeout);
        buttonTimeout && clearTimeout(buttonTimeout);
    });
    
    // Efecto para actualizar páginas totales si cambia apps
    $effect(() => {
        totalPages = apps.length;
        // recalculamos cardCount / ANGLE_PER_CARD y visbles
        cardCount = Math.min(DEFAULT_CARD_COUNT, apps.length);
        ANGLE_PER_CARD = 360 / cardCount;
        updateVisibleApps();
    });
</script>

<section class="aplicaciones-section" style={Object.entries(cssVariables).map(([key, value]) => `${key}:${value}`).join(';')}>
    <div class="container">
        <h1 class="section-title">Aplicaciones</h1>
        
        {#if !isMobile}
            <!-- Vista de carrusel para desktop -->
            <div class="carousel-container">
                <div class="carousel"
                    ontouchstart={handleTouchStart}
                    ontouchmove={handleTouchMove}
                    ontouchend={handleTouchEnd}>
                    
                    <div class="carousel-stage" class:no-transition={disableTransition} style="transform: rotateY({rotationAngle}deg)">
                        {#each visibleApps as app, i}
                            <div class="app-card" 
                                style="transform: rotateY({i * ANGLE_PER_CARD}deg) translateZ({CAROUSEL_RADIUS}px)"
                                role="region"
                                onmouseenter={() => isPaused = true}
                                onmouseleave={() => isPaused = false}>
                                <div class="app-card-content">
                                    <h2 class="app-title">{app.titulo}</h2>
                                    <img class="app-logo" src={app.img} alt={app.alt} />
                                    <p class="app-description">{app.descripcion}</p>
                                    <button class="app-button">Saber más</button>
                                </div>
                            </div>
                        {/each}
                    </div>
                    
                    <div class="carousel-controls">
                        <button class="control-button prev" 
                            class:clicked={clickedPrev}
                            onclick={() => animateButton('prev')}
                            aria-label="Anterior">
                            ←
                        </button>
                        
                        <div class="carousel-indicators">
                            {#each apps as _, i}
                                <button class="indicator {i === currentPage ? 'active' : ''}"
                                    onclick={() => goToPage(i)}
                                    aria-label={`Ir a página ${i + 1}`}>
                                </button>
                            {/each}
                        </div>
                        
                        <button class="control-button next"
                            class:clicked={clickedNext}
                            onclick={() => animateButton('next')}
                            aria-label="Siguiente">
                            →
                        </button>
                    </div>
                </div>
            </div>
        {:else}
            <!-- Vista de tarjetas apiladas para móvil -->
            <div class="mobile-cards">
                {#each apps as app}
                    <div class="mobile-card">
                        <h2 class="app-title">{app.titulo}</h2>
                        <img class="app-logo" src={app.img} alt={app.alt} />
                        <p class="app-description">{app.descripcion}</p>
                        <button class="app-button">Saber más</button>
                    </div>
                {/each}
            </div>
        {/if}
    </div>
</section>

<style>
    /* Estilos generales */
    .aplicaciones-section {
        width: 100%;
        min-height: 100vh;
        padding: 2rem 0;
    }
    
    .container {
        width: 90%;
        max-width: 1200px;
        margin: 0 auto;
    }
    
    .section-title {
        text-align: center;
        font-size: 2.5rem;
        margin-bottom: 3rem;
        color: #fff;
    }
    
    /* Estilos del carrusel 3D */
    .carousel-container {
        position: relative;
        height: 70vh;
        margin: 0 auto;
        overflow: hidden;
        z-index: 1;
    }
    
    .carousel {
        position: relative;
        width: 100%;
        height: 100%;
        perspective: 1200px;
        transform-style: preserve-3d;
    }
    
    .carousel-stage {
        position: absolute;
        width: 100%;
        height: 100%;
        transform-style: preserve-3d;
        transition: transform var(--animation-duration) ease-out;
        transform-origin: center center calc(var(--carousel-radius)* -1); /* Centro del carrusel, debe coincidir con CAROUSEL_RADIUS */
        pointer-events: none;
    }

    .carousel-stage.no-transition {
        transition: none !important;
    }
    
    .app-card {
        position: absolute;
        top: 50%;
        left: 50%;
        width: 280px;
        height: 400px;
        transform-origin: center center calc(var(--carousel-radius)* -1); /* Mismo valor que el radio del carrusel */
        transform-style: preserve-3d;
        backface-visibility: visible;
        background: var(--secondary-background);
        border-radius: 12px;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
        margin-left: -140px; /* Mitad del ancho */
        margin-top: -200px; /* Mitad de la altura */
        transition: opacity var(--animation-duration) ease, transform var(--animation-duration) ease-out;
        pointer-events: auto;
    }
    
    .app-card-content {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        text-align: center;
        height: 100%;
        padding: 20px;
        box-sizing: border-box;
    }
    
    .app-card:hover {
        box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);
    }
    
    .app-title {
        margin: 0 0 15px;
        font-size: 1.5rem;
        color: #ffffff;
    }
    
    .app-logo {
        width: 80px;
        height: 80px;
        object-fit: contain;
        margin: 15px 0;
    }
    
    .app-description {
        color: #979595;
        font-size: 1rem;
        margin: 15px 0;
        flex-grow: 1;
    }
    
    .app-button {
        background: var(--primary-color);
        color: #343233;
        border: none;
        padding: 10px 25px;
        border-radius: 25px;
        font-weight: bold;
        cursor: pointer;
        transition: transform 0.4s ease, background-color 0.4s ease;
        margin-top: 15px;
    }
    
    .app-button:hover {
        transform: scale(1.05);
    }
    
    /* Controles del carrusel */
    .carousel-controls {
        position: absolute;
        bottom: 5%;
        left: 0;
        right: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 30px;
        z-index: 10;
        pointer-events: auto;
    }
    
    .control-button {
        background: rgba(255, 255, 255, 0.2);
        color: var(--primary-color);
        border: none;
        width: 40px;
        height: 40px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 18px;
        cursor: pointer;
        transition: all calc(var(--animation-duration) * 0.75) ease;
    }
    
    .control-button:hover {
        background: rgba(255, 255, 255, 0.3);
    }
    
    .carousel-indicators {
        display: flex;
        gap: 8px;
    }
    
    .indicator {
        width: 10px;
        height: 10px;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.3);
        border: none;
        padding: 0;
        cursor: pointer;
        transition: background 0.3s ease;
    }
    
    .indicator.active {
        background: var(--primary-color);
        transform: scale(1.2);
    }
    
    /* Animación de botones */
    @keyframes jelly {
        0% { transform: scale(1); }
        30% { transform: scale(1.25, 0.75); }
        40% { transform: scale(0.75, 1.25); }
        50% { transform: scale(1.15, 0.85); }
        65% { transform: scale(0.95, 1.05); }
        75% { transform: scale(1.05, 0.95); }
        100% { transform: scale(1); }
    }
    
    .control-button.clicked {
        animation: jelly 0.6s ease;
    }
    
    /* Vista móvil */
    .mobile-cards {
        display: flex;
        flex-direction: column;
        gap: 20px;
    }
    
    .mobile-card {
        background: var(--secondary-background);
        border-radius: 12px;
        padding: 20px;
        display: flex;
        flex-direction: column;
        align-items: center;
        text-align: center;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
    }
    
    /* Media queries */
    @media (max-width: 1200px) {
        .app-card {
            width: 240px;
            height: 350px;
        }
    }
    
    @media (max-width: 992px) {
        .app-card {
            width: 220px;
            height: 320px;
        }
        
        .app-title {
            font-size: 1.3rem;
        }
        
        .app-description {
            font-size: 0.9rem;
        }
    }
    
    @media (min-width: 769px) and (max-height: 700px) {
        .carousel-container {
            height: 450px;
        }
        
        .app-card {
            height: 300px;
        }
    }
</style>