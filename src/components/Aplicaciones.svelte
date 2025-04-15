<script lang="ts">
    import { onMount } from 'svelte';
    import '../global.css';
    
    let { apps } = $props();

    const carouselRotationInterval  = 3000;
    const carouselAnimationDuration = 300;
    const delayAfterSwipe           = 4000;

    let isMobile = $state(false);
    let translateZ = $state('500px');
    let touchStartX = 0;
    let touchEndX = 0;
    let isSwiping = false;
    let clickedPrev = $state(false);
    let clickedNext = $state(false);
    
    let activeIndex = $state(0);
    let isPaused = false;
    let isAnimating = false;
    let currentRotation = $state(0);
    let targetRotation = 0;
    
    const anglePerItem = 360 / apps.length;
    
    function nextCard() {
        if (isAnimating) return;
        isAnimating = true;
        activeIndex = (activeIndex + 1) % apps.length;
        targetRotation -= anglePerItem;
        animateRotation();
        pauseCarousel();
    }
    
    function prevCard() {
        if (isAnimating) return;
        isAnimating = true;
        activeIndex = (activeIndex - 1 + apps.length) % apps.length;
        targetRotation += anglePerItem;
        animateRotation();
        pauseCarousel();
    }
    
    function animateRotation() {
        const startTime = performance.now();
        const startRotation = currentRotation;
        const rotationDiff = targetRotation - startRotation;
        
        function step(timestamp: number) {
            const elapsed = timestamp - startTime;
            const progress = Math.min(elapsed / carouselAnimationDuration, 1);
            const easeProgress = easeInOutCubic(progress);
            currentRotation = startRotation + rotationDiff * easeProgress;
            if (progress < 1) {
                requestAnimationFrame(step);
            } else {
                isAnimating = false;
            }
        }
        
        requestAnimationFrame(step);
    }

    function pauseCarousel(delay: number = 1000) {
        isPaused = true;
        setTimeout(() => {
            isPaused = false;
        }, delay);
    }
    
    function easeInOutCubic(t: number) {
        return t < 0.5
            ? 4 * t * t * t
            : 1 - Math.pow(-2 * t + 2, 3) / 2;
    }
    
    function goToCard(index: number) {
        if (isAnimating || index === activeIndex) return;
        isAnimating = true;
        const currentAngle = -activeIndex * anglePerItem;
        const targetAngle = -index * anglePerItem;
        let angleDiff = targetAngle - currentAngle;
        if (Math.abs(angleDiff) > 180) {
            angleDiff = angleDiff > 0
                ? angleDiff - 360
                : angleDiff + 360;
        }
        targetRotation = currentRotation + angleDiff;
        activeIndex = index;
        animateRotation();
        pauseCarousel();
    }
    
    let intervalId: NodeJS.Timeout | null;
    
    function startAutoRotation() {
        if (!intervalId) {
            intervalId = setInterval(() => {
                if (!isPaused && !isAnimating) {
                    nextCard();
                }
            }, carouselRotationInterval);
        }
    }
    
    function stopAutoRotation() {
        if (intervalId) {
            clearInterval(intervalId);
            intervalId = null;
        }
    }
    
    $effect(() => {
        startAutoRotation();
        return () => stopAutoRotation();
    });

    // Función mejorada para calcular el valor de translateZ según la resolución de pantalla
    function calculateTranslateZ(): string {
        const totalAngle = (2 * Math.PI) / apps.length; // Ángulo total en radianes
        let containerWidth = window.innerWidth;
        let containerHeight = window.innerHeight;
        let aspectRatio = containerWidth / containerHeight;
        
        // Factores de ajuste según tamaño de pantalla
        let widthFactor = 0.7; // Factor base
        let minRadius = 300; // Radio mínimo para evitar que las tarjetas se junten demasiado
        
        // Ajustes según resolución de pantalla
        if (containerWidth >= 1920) {
            widthFactor = 0.6; // Pantallas grandes
        } else if (containerWidth >= 1366) {
            widthFactor = 0.65; // Laptops
        } else if (containerWidth >= 1024) {
            widthFactor = 0.7; // Tablets grandes
        } else if (containerWidth >= 768) {
            widthFactor = 0.75; // Tablets
        } else if (containerWidth >= 480) {
            widthFactor = 0.8; // Móviles grandes
        } else {
            widthFactor = 0.9; // Móviles pequeños
        }
        
        // Ajuste adicional basado en la relación de aspecto
        if (aspectRatio < 0.6) { // Pantallas altas (móvil en vertical)
            widthFactor *= 1.2;
        }
        
        // Cálculo del radio del carrusel
        const adjustedWidth = containerWidth * widthFactor;
        const radius = Math.max(minRadius, adjustedWidth / (2 * Math.sin(totalAngle / 2)));
        
        return `${radius}px`;
    }

    onMount(() => {
        isMobile = window.innerWidth <= 768;
        translateZ = calculateTranslateZ();
        const handleResize = () => {
            isMobile = window.innerWidth <= 768;
            translateZ = calculateTranslateZ();
        };
        window.addEventListener('resize', handleResize);

        const contentEl = document.querySelector('.icon-cards__content');
        if (contentEl) {
            contentEl.addEventListener('touchstart', handleTouchStart as EventListener);
            contentEl.addEventListener('touchmove', handleTouchMove as EventListener);
            contentEl.addEventListener('touchend', handleTouchEnd);
        }

        return () => {
            if (contentEl) {
                contentEl.removeEventListener('touchstart', handleTouchStart as EventListener);
                contentEl.removeEventListener('touchmove', handleTouchMove as EventListener);
                contentEl.removeEventListener('touchend', handleTouchEnd);
            }
            window.removeEventListener('resize', handleResize);
        };
    });

    function handleTouchStart(event: TouchEvent) {
        touchStartX = event.touches[0].clientX;
        touchEndX = touchStartX;
        isSwiping = false;
        stopAutoRotation()
    }

    function handleTouchMove(event: TouchEvent) {
        touchEndX = event.touches[0].clientX;
        isSwiping = true;
    }

    function handleTouchEnd() {
        if (isSwiping) {
            const deltaX = touchEndX - touchStartX;
            if (Math.abs(deltaX) > 50) {
                deltaX < 0 ? nextCard() : prevCard();
            }
        }
        setTimeout(() => {
            startAutoRotation();
        }, delayAfterSwipe);
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

<section class="aplicaciones-section">
    <div class="cuerpo">
        <h1>Aplicaciones</h1>

        <div class="carousel-container">
            <div class="icon-cards">
                <div class="icon-cards__content" 
                    role="region" 
                    aria-label="Carrusel de aplicaciones"
                    style={`transform: translateZ(-${translateZ}) rotateY(${currentRotation}deg)`}>
                    {#each apps as app, i}
                        <div class="icon-cards__item" 
                        style={`transform: rotateY(${i * (360/apps.length)}deg) translateZ(${translateZ})`}
                        onmouseenter={() => i === activeIndex && stopAutoRotation()}
                        onmouseleave={() => i === activeIndex && startAutoRotation()}
                        role="button"
                        tabindex="0">
                        <div class="icon-cards__item_centrar">
                            <h2 class="aplicacion-titulo">{app.titulo}</h2>
                            <img class="aplicacion-logo" src={app.img} alt={app.alt}  />
                            <p class="aplicacion-descripcion">{app.descripcion}</p>
                            <button class="aplicacion-button">Saber más</button>
                        </div> <!-- #1 -->
                        </div>
                    {/each}
                </div>
            </div>
            
            {#if !isMobile}
                <div class="carousel-navigation">
                    <button
                        class="control-button prev"
                        class:clicked={clickedPrev}
                        onclick={() => animateButton('prev')}
                        onanimationend={() => handleAnimationEnd('prev')}
                        aria-label="Anterior">←
                    </button>
                
                    <div class="carousel-indicators">
                        {#each apps as _, i}
                            <button type="button"
                                class="indicator {i === activeIndex ? 'active' : ''}"
                                aria-label={`Ir a la aplicación ${i + 1}`}
                                onclick={() => { goToCard(i); }}
                            ></button>
                        {/each}
                    </div>
                
                    <button
                        class="control-button next"
                        class:clicked={clickedNext}
                        onclick={() => animateButton('next')}
                        onanimationend={() => handleAnimationEnd('next')}
                        aria-label="Siguiente">→
                    </button>
                </div>
            {/if}
            
            {#if isMobile}
                <div class="carousel-indicators mobile-indicators">
                    {#each apps as _, i}
                        <button type="button"
                            class="indicator {i === activeIndex ? 'active' : ''}"
                            aria-label={`Ir a la aplicación ${i + 1}`}
                            onclick={() => { goToCard(i); }}
                        ></button>
                    {/each}
                </div>
            {/if}
        </div>
    </div>
</section>

<style>
    .aplicaciones-section {
        width: 100%;
        height: 100%;
        display: grid;
		align-items: center;
    }
    
    .cuerpo {
        margin-top: max(10vh, 45px);
		height: 90vh;
        align-content: start;
    }

    .carousel-container {
        width: 100vw;
        height: 70vh;
        position: relative;
    }
    
    .icon-cards {
        position: relative;
        margin-top: 8vh;
        width: 90vw;
        height: 65vh;
        left: 50%;
        transform: translateX(-50%);
        max-width: 800px;
        perspective: 800px;
        transform-origin: center;
        justify-content: center;
    }
    
    .icon-cards__content {
        position: relative;
        width: 100%;
        transform-origin: center;
        transform-style: preserve-3d;
        transition: transform 1.2s cubic-bezier(0.455, 0.03, 0.515, 0.955);
    }
    
    .icon-cards__item {
        position: absolute;
        padding: 20px;
        margin: 0;
        max-width: 800px;
        box-shadow: 0 5px 20px rgba(0,0,0,.1);
        border-radius: 10px;
        transform-origin: center;
        transform-style: preserve-3d;
        transform: translate(-50%, -50%) rotateY(0deg) translateZ(500px); /* Ajusta el valor de translateZ dinámicamente */
        background: var(--secondary-background);
        display: flex;
        flex-direction: column;
        overflow: auto;
        backface-visibility: hidden;
    }

    .icon-cards__item_centrar{
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 100%;
    }
    
    .aplicacion-titulo {
        margin: 0px;
        font-family: PilcrowRounded-Bold;
        color: #ffffff;
    }
    
    .aplicacion-logo {
        position: relative;
        width: 80px;
        height: 20%;
        margin: 20px;
    }

    
    .aplicacion-descripcion {
        color: #979595;
        margin-top: 0;
        margin-bottom: 20px;
        text-align: center;
    }

    .aplicacion-button {
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

    .aplicacion-button:hover {
        background: var(--primary-color);
        transform: scale(1.05);
    }
    
    .carousel-navigation {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 20px;
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

    .carousel-indicators {
        position: absolute;
        bottom: 10px;
        display: flex;
        justify-content: center;
        align-content: center;
        width: 100%;
        gap: 10px;
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

    @keyframes jelly {
        from { transform: scale(1, 1); }
        30% { transform: scale(1.25, 0.75); }
        40% { transform: scale(0.75, 1.25); }
        50% { transform: scale(1.15, 0.85); }
        65% { transform: scale(0.95, 1.05); }
        75% { transform: scale(1.05, 0.95); }
        to { transform: scale(1, 1); }
    }

    .control-button.clicked {
        animation: jelly 0.6s ease;
    }
    
    /* #2 Media queries para responsive */
</style>