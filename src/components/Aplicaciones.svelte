<script lang="ts">
    import { onMount } from 'svelte';
    import '../global.css';
    
    let { apps } = $props();

    const carouselRotationInterval  = 3000;
    const carouselAnimationDuration = 300;
    const delayAfterSwipe           = 4000;

    let isMobile = $state(false);
    let translateZ = $state('500px');
    let touchStartX = $state(0);
    let touchEndX = $state(0);
    let isSwiping = false;
    let clickedPrev = $state(false);
    let clickedNext = $state(false);
    
    let activeIndex = $state(0);
    let isPaused = $state(false);
    let isAnimating = $state(false);
    let currentRotation = $state(0);
    let targetRotation = $state(0);
    
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

    function calculateTranslateZ(): string {
        const totalAngle = Math.PI / apps.length; // más tarjetas = más cerrado
        let containerWidth = window.innerWidth;

        // Ajustar tamaño de tarjeta y spacing según resolución
        if (containerWidth >= 1920) {
            containerWidth *= 0.6; // Más separación en pantallas grandes
        } else if (containerWidth >= 1024) {
            containerWidth *= 0.6; // Valor por defecto para tablets
        } else if (containerWidth <= 480) {
            containerWidth *= 0.9; // Más cerrado en móviles pequeños
        } else {
            containerWidth *= 0.8; // Ajuste general
        }

        const radius = containerWidth / (2 * Math.tan(totalAngle));
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

<section class="apps-section">
    <div class="section-content">
        <div class="titulo">
            <h1>Aplicaciones</h1>
        </div>

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
        </div>
    </div>
</section>

<style>
    .apps-section {
        height: 100vh;
        width: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
        box-sizing: border-box;
        position: relative;
        padding-top: 60px;
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
    
    .titulo, .aplicacion-titulo {
        width: 100%;
        color: var(--primary-color);
        text-align: center;
        margin-bottom: 10px;
        margin-top: 20px;
    }

    .aplicacion-titulo {
        margin-top: 60px;
    }
    
    h2 {
        margin: 0px;
        font-family: PilcrowRounded-Bold;
        color: #ffffff;
    }
    
    .carousel-container {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        width: 100%;
        flex: 2;
        position: relative;
    }
    
    .icon-cards {
        position: relative;
        width: 70vw;
        height: 80%;
        max-width: 800px;
        margin: 0 auto;
        color: white;
        perspective: 1200px;
        transform-origin: center;
    }
    
    .icon-cards__content {
        position: absolute;
        width: 100%;
        height: 100%;
        transform-origin: center;
        transform-style: preserve-3d;
        transition: transform 0.8s cubic-bezier(0.455, 0.03, 0.515, 0.955);
    }
    
    .icon-cards__item {
        position: absolute;
        margin: 0 auto;
        width: 70vw;
        height: 100%;
        max-width: 800px;
        box-shadow: 0 5px 20px rgba(0,0,0,.1);
        border-radius: 10px;
        transform-origin: center;
        transform-style: preserve-3d;
        background: var(--secondary-background);
        display: flex;
        flex-direction: column;
        overflow: auto;
        backface-visibility: hidden;
    }
    
    .aplicacion-container-detalles {
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
    
    @media (max-width: 600px) {
        .icon-cards {
            width: 90vw;
        }

        .icon-cards__item {
            width: 90vw;
        }
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
</style>
