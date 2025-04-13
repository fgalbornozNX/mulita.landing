<script lang="ts">
    import { onMount } from 'svelte';
    import '../global.css';
    
    let { apps } = $props();

    const carouselRotationInterval  = 99999;
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
            widthFactor = 0.85; // Móviles pequeños
        }
        
        // Ajuste adicional basado en la relación de aspecto
        if (aspectRatio < 1) { // Pantallas altas (móvil en vertical)
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
                            <div class="icon-cards__item_centrar">
                                <h2 class="aplicacion-titulo">{app.titulo}</h2>
                                <img class="aplicacion-logo" src={app.img} alt={app.alt}  />
                                <p class="aplicacion-descripcion">{app.descripcion}</p>
                                <button class="aplicacion-button">Saber más</button>
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
    
    .titulo {
        width: 100%;
        color: var(--primary-color);
        text-align: center;
        margin-bottom: 10px;
        margin-top: 20px;
    }
    
    .icon-cards {
        position: relative;
        width: 70vw;
        height: 50vw;
        max-height: 600px;
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
        height: 50vw;
        max-height: 600px;
        padding: 20px;
        margin: 0 auto;
        width: 70vw;
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
        width: 80px;
        height: 80px;
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

    .carousel-container {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        width: 100%;
        flex: 2;
        position: relative;
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
    
    .mobile-indicators {
        margin-top: 40px;
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
    
    /* Media queries para responsive */
    
    /* Pantallas extra grandes (desktop) */
    @media (min-width: 1920px) {
        .icon-cards {
            width: 60vw;
            height: 40vw;
        }
        
        .icon-cards__item {
            width: 60vw;
            height: 40vw;
            padding: 30px;
        }
        
        .aplicacion-titulo {
            font-size: 2.5rem;
        }
        
        .aplicacion-logo {
            width: 120px;
            height: 120px;
            margin: 30px;
        }
        
        .aplicacion-descripcion {
            font-size: 1.2rem;
            max-width: 70%;
            margin-bottom: 30px;
        }
        
        .aplicacion-button {
            padding: 15px 30px;
            font-size: 1.1rem;
        }
    }
    
    /* Pantallas grandes (laptops/desktops) */
    @media (min-width: 1366px) and (max-width: 1919px) {
        .icon-cards {
            width: 65vw;
            height: 45vw;
        }
        
        .icon-cards__item {
            width: 65vw;
            height: 45vw;
            padding: 25px;
        }
        
        .aplicacion-titulo {
            font-size: 2.2rem;
        }
        
        .aplicacion-logo {
            width: 100px;
            height: 100px;
        }
        
        .aplicacion-descripcion {
            font-size: 1.1rem;
            max-width: 75%;
        }
    }
    
    /* Tablets y laptops pequeñas */
    @media (min-width: 1024px) and (max-width: 1365px) {
        .icon-cards {
            width: 70vw;
            height: 48vw;
        }
        
        .icon-cards__item {
            width: 70vw;
            height: 48vw;
        }
        
        .aplicacion-titulo {
            font-size: 2rem;
        }
        
        .aplicacion-descripcion {
            font-size: 1rem;
            max-width: 80%;
        }
    }
    
    /* Tablets */
    @media (min-width: 768px) and (max-width: 1023px) {
        .apps-section {
            padding-top: 40px;
        }
        
        .icon-cards {
            width: 75vw;
            height: 55vw;
        }
        
        .icon-cards__item {
            width: 75vw;
            height: 55vw;
            padding: 15px;
        }
        
        .aplicacion-titulo {
            font-size: 1.8rem;
        }
        
        .aplicacion-logo {
            width: 70px;
            height: 70px;
            margin: 15px;
        }
        
        .aplicacion-descripcion {
            font-size: 0.95rem;
            max-width: 85%;
            margin-bottom: 15px;
        }
        
        .carousel-navigation {
            margin-top: 40px;
        }
    }
    
    /* Móviles grandes */
    @media (min-width: 480px) and (max-width: 767px) {
        .apps-section {
            padding-top: 30px;
            height: auto;
            min-height: 100vh;
        }
        
        .icon-cards {
            width: 85vw;
            height: 65vw;
        }
        
        .icon-cards__item {
            width: 85vw;
            height: 65vw;
            padding: 15px;
        }
        
        .aplicacion-titulo {
            font-size: 1.5rem;
        }
        
        .aplicacion-logo {
            width: 60px;
            height: 60px;
            margin: 10px;
        }
        
        .aplicacion-descripcion {
            font-size: 0.9rem;
            max-width: 90%;
            margin-bottom: 15px;
        }
        
        .aplicacion-button {
            padding: 8px 16px;
            font-size: 0.9rem;
        }
        
        .titulo h1 {
            font-size: 1.8rem;
        }
    }
    
    /* Móviles pequeños */
    @media (max-width: 479px) {
        .apps-section {
            padding-top: 20px;
            height: auto;
            min-height: 100vh;
        }
        
        .section-content {
            padding: 10px 0;
        }
        
        .icon-cards {
            width: 90vw;
            height: 75vw;
            min-height: 300px;
        }
        
        .icon-cards__item {
            width: 90vw;
            height: 75vw;
            min-height: 300px;
            padding: 10px;
        }
        
        .aplicacion-titulo {
            font-size: 1.3rem;
        }
        
        .aplicacion-logo {
            width: 50px;
            height: 50px;
            margin: 8px;
        }
        
        .aplicacion-descripcion {
            font-size: 0.85rem;
            max-width: 95%;
            margin-bottom: 12px;
            line-height: 1.3;
        }
        
        .aplicacion-button {
            padding: 7px 14px;
            font-size: 0.85rem;
        }
        
        .titulo h1 {
            font-size: 1.6rem;
            margin-bottom: 15px;
        }
        
        .mobile-indicators {
            margin-top: 30px;
        }
        
        .indicator {
            width: 8px;
            height: 8px;
        }
    }
    
    /* Ajustes para pantallas con altura reducida */
    @media (max-height: 700px) {
        .apps-section {
            height: auto;
            min-height: 100vh;
        }
        
        .icon-cards__item_centrar {
            justify-content: flex-start;
            padding-top: 15px;
        }
        
        .aplicacion-logo {
            margin: 10px;
        }
        
        .aplicacion-descripcion {
            margin-bottom: 15px;
        }
    }
    
    /* Pantallas con orientación landscape en móviles */
    @media (max-height: 500px) and (orientation: landscape) {
        .apps-section {
            height: auto;
            min-height: 100vh;
            padding-top: 10px;
        }
        
        .icon-cards {
            height: 45vw;
            min-height: 250px;
        }
        
        .icon-cards__item {
            height: 45vw;
            min-height: 250px;
        }
        
        .icon-cards__item_centrar {
            flex-direction: row;
            flex-wrap: wrap;
            justify-content: center;
            align-content: center;
            gap: 10px;
        }
        
        .aplicacion-titulo {
            font-size: 1.2rem;
            width: 100%;
            text-align: center;
        }
        
        .aplicacion-logo {
            width: 45px;
            height: 45px;
            margin: 5px 15px;
        }
        
        .aplicacion-descripcion {
            width: calc(100% - 80px);
            margin: 0;
            text-align: left;
        }
        
        .aplicacion-button {
            margin-top: 5px;
        }
    }
</style>