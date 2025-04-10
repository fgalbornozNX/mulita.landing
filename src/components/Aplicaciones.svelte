<script lang="ts">
	import { onMount } from 'svelte';
    import '../global.css';
	
    let { apps } = $props();

    let isMobile = $state(false); // Variable para detectar si es móvil
	let translateZ = $state('500px'); // valor inicial por defecto
    let touchStartX = $state(0);
    let touchEndX = $state(0);
    let clickedPrev = $state(false);
	let clickedNext = $state(false);
    
    // Estado para control del carrusel
    let activeIndex = $state(0);
    let isPaused = $state(false);
    
    // Variables para transición fluida
    let isAnimating = $state(false);
    let currentRotation = $state(0);
    let targetRotation = $state(0);
    
    // Ángulo por elemento
    const anglePerItem = 360 / apps.length;
    
    // Función para cambiar a la siguiente tarjeta con animación suave
    function nextCard() {
        if (isAnimating) return;
        
        isAnimating = true;
        activeIndex = (activeIndex + 1) % apps.length;
        
        // Actualizar rotación objetivo
        targetRotation -= anglePerItem;
        
        // Iniciar animación suave
        animateRotation();
        pauseCarousel();
    }
    
    // Función para cambiar a la tarjeta anterior con animación suave
    function prevCard() {
        if (isAnimating) return;
        
        isAnimating = true;
        activeIndex = (activeIndex - 1 + apps.length) % apps.length;
        
        // Actualizar rotación objetivo
        targetRotation += anglePerItem;
        
        // Iniciar animación suave
        animateRotation();
        pauseCarousel();
    }
    
    // Función para animar la rotación suavemente
    function animateRotation() {
        const startTime = performance.now();
        const startRotation = currentRotation;
        const rotationDiff = targetRotation - startRotation;
        const duration = 300; // duración de la animación en ms
        
        function step(timestamp: number) {
            const elapsed = timestamp - startTime;
            const progress = Math.min(elapsed / duration, 1);
            
            // Función de easing para suavizar el movimiento
            const easeProgress = easeInOutCubic(progress);
            
            // Calcular rotación actual
            currentRotation = startRotation + rotationDiff * easeProgress;
            
            // Continuar animación si no ha terminado
            if (progress < 1) {
                requestAnimationFrame(step);
            } else {
                isAnimating = false;
            }
        }
        
        requestAnimationFrame(step);
    }
    
    // Función de easing para animación más natural
    function easeInOutCubic(t: number) {
        return t < 0.5
            ? 4 * t * t * t
            : 1 - Math.pow(-2 * t + 2, 3) / 2;
    }
    
    // Función para ir directamente a una tarjeta específica
    function goToCard(index: number) {
        if (isAnimating || index === activeIndex) return;
        
        isAnimating = true;
        
        // Calcular el camino más corto para llegar al índice deseado
        const currentAngle = -activeIndex * anglePerItem;
        const targetAngle = -index * anglePerItem;
        
        // Determinar si es más rápido ir hacia adelante o hacia atrás
        let angleDiff = targetAngle - currentAngle;
        
        // Ajustar para tomar el camino más corto
        if (Math.abs(angleDiff) > 180) {
            angleDiff = angleDiff > 0
                ? angleDiff - 360
                : angleDiff + 360;
        }
        
        // Actualizar rotación objetivo
        targetRotation = currentRotation + angleDiff;
        activeIndex = index;
        
        // Iniciar animación suave
        animateRotation();
        pauseCarousel();
    }
    
    // Función para pausar el carrusel temporalmente
    function pauseCarousel() {
        isPaused = true;
        // Reanuda la animación después de 5 segundos
        setTimeout(() => {
            isPaused = false;
        }, 5000);
    }
    
    // Configurar intervalo de rotación automática
    let intervalId: number;
    
    // Iniciar rotación automática
    function startAutoRotation() {
        if (!intervalId) {
            intervalId = setInterval(() => {
                if (!isPaused && !isAnimating) {
                    nextCard();
                }
            }, 3000); // Cambiar cada 3 segundos
        }
    }
    
    // Detener rotación
    function stopAutoRotation() {
        if (intervalId) {
            clearInterval(intervalId);
            intervalId = 0;
        }
    }
    
    // Iniciar la rotación al cargar el componente
    $effect(() => {
        startAutoRotation();
        
        // Limpiar el intervalo cuando el componente se desmonte
        return () => stopAutoRotation();
    });

    function calculateTranslateZ(): string {
		const cardBaseWidth = 250; // tamaño base de cada tarjeta
		const totalAngle = Math.PI / apps.length; // más tarjetas = más cerrado
		let containerWidth = window.innerWidth;

		// Ajustar tamaño de tarjeta y spacing según resolución
		if (containerWidth >= 1600) {
			containerWidth *= 0.5; // menos separación en pantallas grandes
		} else if (containerWidth <= 904) {
			containerWidth *= 0.9; // más cerrado en móviles
		} else {
			containerWidth *= 0.6; // valor por defecto
		}

		const radius = containerWidth / (2 * Math.tan(totalAngle));
		return `${radius}px`;
	}

	onMount(() => {
		isMobile = window.innerWidth <= 768; // Detectar si es móvil
        
        // Set initial translateZ
		translateZ = calculateTranslateZ();

		// Optional: update on resize
		const handleResize = () => {
            isMobile = window.innerWidth <= 768; // Detectar si es móvil
			translateZ = calculateTranslateZ();
		};

		window.addEventListener('resize', handleResize);

        const contentEl = document.querySelector('.icon-cards__content');
        if (contentEl) {
            contentEl.addEventListener('touchstart', handleTouchStart as EventListener);
            contentEl.addEventListener('touchmove', handleTouchMove as EventListener);
            contentEl.addEventListener('touchend', handleTouchEnd as EventListener);
        }

        return () => {
        if (contentEl) {
            contentEl.removeEventListener('touchstart', handleTouchStart as EventListener);
            contentEl.removeEventListener('touchmove', handleTouchMove as EventListener);
            contentEl.removeEventListener('touchend', handleTouchEnd as EventListener);
        }
            window.removeEventListener('resize', handleResize);
        };
	});

    function handleTouchStart(event: TouchEvent) {
        touchStartX = event.touches[0].clientX;
    }

    function handleTouchMove(event: TouchEvent) {
        touchEndX = event.touches[0].clientX;
    }

    function handleTouchEnd() {
        const deltaX = touchEndX - touchStartX;
        if (Math.abs(deltaX) > 50) {
            deltaX < 0 ? nextCard() : prevCard();
        }
    }

	function animateButton(direction: 'prev' | 'next') {
		if (direction === 'prev') {
			clickedPrev = false;
			requestAnimationFrame(() => clickedPrev = true);
			prevCard();
		} else {
			clickedNext = false;
			requestAnimationFrame(() => clickedNext = true);
			nextCard();
		}
	}

    function handleAnimationEnd(direction: 'prev' | 'next') {
        direction === 'prev' ? (clickedPrev = false) : (clickedNext = false);
    }

</script>

<section class="apps-section">
    <div class="section-content">
        <div class="titulo">
            <h1>Aplicaciones</h1>
        </div>

        <div class="carousel-container">
            <!-- Carrusel de tarjetas -->
            <div class="icon-cards">
                <div class="icon-cards__content" 
     				role="region" 
     				aria-label="Carrusel de aplicaciones"
     				style={`transform: translateZ(-${translateZ}) rotateY(${currentRotation}deg)`}>
                    {#each apps as app, i}
                        <div class="icon-cards__item aplicacion-card" 
                            style={`transform: rotateY(${i * (360/apps.length)}deg) translateZ(${translateZ})`}
                            onmouseenter={() => isPaused = true}
                            onmouseleave={() => isPaused = false}
                            role="button"
                            tabindex="0">
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
            
            {#if !isMobile}
                <!-- Controles de navegación reposicionados -->
                <div class="carousel-navigation">
                    <button
                        class="control-button prev"
                        class:clicked={clickedPrev}
                        onclick={() => animateButton('prev')}
                        onanimationend={() => handleAnimationEnd('prev')}
                        aria-label="Anterior"
                        disabled={isAnimating}>←</button>
                
                    <div class="carousel-indicators">
                        {#each apps as _, i}
                            <button type="button"
                                class="indicator {i === activeIndex ? 'active' : ''}"
                                aria-label={`Ir a la aplicación ${i + 1}`}
                                onclick={() => { goToCard(i); }}
                                disabled={isAnimating}></button>
                        {/each}
                    </div>
                
                    <button
                        class="control-button next"
                        class:clicked={clickedNext}
                        onclick={() => animateButton('next')}
                        onanimationend={() => handleAnimationEnd('next')}
                        aria-label="Siguiente"
                        disabled={isAnimating}>→</button>
                </div>
            {/if}
        </div>
    </div>
</section>

<style>
    /* Sección de pantalla completa */
    .apps-section {
        height: 100vh; /* 100% del alto de la ventana */
        width: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
        box-sizing: border-box;
        position: relative;
        padding-top: 60px; /* Añadir padding-top para compensar la barra de menú superior */
    }
    
    .section-content {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        width: 100%;
        height: 100%;
        padding: 20px 0;
    }
    
    .titulo,
    .aplicacion-titulo {
        width: 100%;
        color: var(--primary-color);
        text-align: center;
        margin-bottom: 10px;
        margin-top: 60px;
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
        width: 100%;
        flex: 1;
        margin-top: 20px; /* Espacio entre título y carrusel */
        position: relative;
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
        transition: transform 0.8s cubic-bezier(0.455, 0.03, 0.515, 0.955);
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
		transform-style: preserve-3d;
        background: var(--secondary-background);
        padding: 20px;
        display: flex;
        flex-direction: column;
        overflow: auto;
        backface-visibility: hidden;
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
    
    /* Controles de navegación reposicionados */
    .carousel-navigation {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 20px;
        margin-top: 60px;
        width: 100%;
        max-width: 500px;
        padding: 0 20px;
        box-sizing: border-box;
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
        transition: background 0.3s;
        z-index: 10;
    }
    
    .control-button:hover:not([disabled]) {
        background: rgba(255, 255, 255, 0.4);
    }
    
    .control-button[disabled] {
        opacity: 0.5;
        /* cursor: not-allowed; */
    }
    
    /* Indicadores de posición */
    .carousel-indicators {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 10px;
        flex: 1;
    }
    
    .indicator {
        width: 10px;
        height: 10px;
        border-radius: 50%;
        border: none;
        background: rgba(255, 255, 255, 0.3);
        cursor: pointer;
        transition: background 0.3s;
        padding: 0;
    }
    
    .indicator.active {
        background: var(--primary-color);
    }
    
    .indicator[disabled] {
        opacity: 0.5;
        /* cursor: not-allowed; */
    }
    
    /* Estilos responsivos */
    @media (max-width: 904px) {
        .icon-cards {
            width: 80vw;
            height: 60vw;
            max-height: 450px;
        }
        
        .icon-cards__item {
            width: 80vw;
            height: 60vw;
            max-height: 450px;
            transform: scale(0.85); /* reduce un poco para evitar solapamiento */
        }
        
        .aplicacion-container-detalles {
            flex-direction: column;
            align-items: center;
            text-align: center;
        }
        
        .aplicacion-info {
            margin-left: 0;
        }
        
        h1 {
            font-size: 1.8rem;
        }
        
        .titulo {
            margin-top: 40px; /* Reducido en pantallas más pequeñas */
        }

        .apps-section {
            padding-top: 50px; /* Ajustar en pantallas medianas */
        }
    }
    
    
    @media (max-width: 480px) {

        .icon-cards {
            height: 150vw;
        }

        .icon-cards__item {
            width: 80vw;
            height: 110vw;
            font-size: 0.85rem;
            padding: 0.75rem;
        }
        
        .aplicacion-logo {
            width: 60px;
            height: 60px;
        }
        
        h1 {
            font-size: 1.6rem;
        }

        h2 {
            font-size: 1.3rem;
            margin: -12px;
        }

        p {
            font-size: 0.75rem;
        }

        .aplicacion-container-detalles button {
            padding: 8px 16px;
            font-size: 0.8rem;
        }
        
        .titulo {
            margin-top: 30px; /* Ajustar en pantallas pequeñas */
        }

        .apps-section {
            padding-top: 40px; /* Ajustar en pantallas pequeñas */
        }
    }

    /* Animación de "jelly" para el botón */
    /* ================================== */
    .control-button.clicked {
        animation: jelly 0.6s ease;
    }

    @keyframes jelly {
        from { transform: scale(1, 1); }
        30% { transform: scale(1.25, 0.75); }
        40% { transform: scale(0.75, 1.25); }
        50% { transform: scale(1.15, 0.85); }
        65% { transform: scale(0.95, 1.05); }
        75% { transform: scale(1.05, 0.95); }
        to { transform: scale(1, 1); }
    }
    /* ================================== */

</style>