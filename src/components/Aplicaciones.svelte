<script lang="ts">
    import '../global.css';
    import { onMount, onDestroy } from 'svelte';

    type App = { titulo: string; img: string; alt: string; descripcion: string };

    // receive apps from props (runes mode)
    const { apps } = $props<{ apps: App[] }>();

    let container: HTMLElement | null = null;
    let activeIndex = $state(0);
    let autoplayId: number | null = null;
    let isPaused = $state(false);
    const AUTOPLAY_MS = 5000;

    // Responsive cards per view
    let cardsPerView = $state(1);
    let cardWidth = $state(320);
    const GAP = 24; // 1.5rem = 24px, debe coincidir con gap-6 en el HTML
    
    // Touch/swipe support
    let touchStartX = 0;
    let touchEndX = 0;
    let isDragging = false;
    
    function updateLayout() {
        if (typeof window !== 'undefined') {
            const width = window.innerWidth;
            if (width >= 1280) {
                cardsPerView = 3;
                cardWidth = 380; // Tamaño consistente para desktop
            } else if (width >= 768) {
                cardsPerView = 2;
                cardWidth = 360; // Tamaño consistente para tablet
            } else {
                cardsPerView = 1;
                cardWidth = Math.min(340, width - 48); // Mayor margen en móvil
            }
        }
    }

    function scrollToSlide(index: number, smooth = true) {
        if (!container || !apps) return;
        
        // Ensure index is within bounds
        const boundedIndex = Math.max(0, Math.min(index, apps.length - 1));
        activeIndex = boundedIndex;
        
        // Calculate scroll position precisely
        const scrollPosition = boundedIndex * (cardWidth + GAP);
        
        container.scrollTo({
            left: scrollPosition,
            behavior: smooth ? 'smooth' : 'auto'
        });
    }

    function next() {
        if (!apps) return;
        const maxIndex = Math.max(0, apps.length - cardsPerView);
        // Avanzar uno, con navegación circular limitada al rango navegable
        const nextIndex = activeIndex >= maxIndex ? 0 : activeIndex + 1;
        scrollToSlide(nextIndex);
    }

    function prev() {
        if (!apps) return;
        const maxIndex = Math.max(0, apps.length - cardsPerView);
        // Retroceder uno, con navegación circular limitada al rango navegable
        const prevIndex = activeIndex <= 0 ? maxIndex : activeIndex - 1;
        scrollToSlide(prevIndex);
    }

    function goToSlide(index: number) {
        if (!apps || index < 0 || index >= apps.length) return;
        
        // Stop autoplay temporarily
        stopAutoplay();
        
        // Scroll to the specific slide
        scrollToSlide(index);
        
        // Restart autoplay after delay
        setTimeout(() => {
            if (!isPaused) startAutoplay();
        }, 3000);
    }

    function startAutoplay() {
        if (isPaused) return;
        stopAutoplay();
        autoplayId = window.setInterval(() => {
            if (!isPaused) next();
        }, AUTOPLAY_MS);
    }

    function stopAutoplay() {
        if (autoplayId != null) {
            clearInterval(autoplayId);
            autoplayId = null;
        }
    }

    function pauseAutoplay() {
        isPaused = true;
        stopAutoplay();
    }

    function resumeAutoplay() {
        isPaused = false;
        startAutoplay();
    }

    // Simplified scroll handler
    let scrollTimeout: number | null = null;
    let isScrolling = false;
    
    function handleScroll() {
        if (!container || !apps || isDragging) return;
        
        // Clear existing timeout
        if (scrollTimeout) {
            clearTimeout(scrollTimeout);
        }
        
        isScrolling = true;
        
        // Debounce the scroll handler to avoid conflicts during smooth scrolling
        scrollTimeout = window.setTimeout(() => {
            if (!container) return;
            
            const scrollLeft = container.scrollLeft;
            const calculatedIndex = Math.round(scrollLeft / (cardWidth + GAP));
            const boundedIndex = Math.max(0, Math.min(calculatedIndex, apps.length - 1));
            
            // Solo actualizar si el índice cambió realmente
            if (boundedIndex !== activeIndex) {
                activeIndex = boundedIndex;
            }
            
            isScrolling = false;
        }, 100);
    }

    // Touch/swipe handlers
    function handleTouchStart(e: TouchEvent) {
        isDragging = true;
        touchStartX = e.touches[0].clientX;
        pauseAutoplay();
    }

    function handleTouchMove(e: TouchEvent) {
        if (!isDragging) return;
        touchEndX = e.touches[0].clientX;
    }

    function handleTouchEnd(e: TouchEvent) {
        if (!isDragging) return;
        isDragging = false;
        
        if (touchEndX === 0) {
            touchEndX = e.changedTouches[0].clientX;
        }
        
        handleSwipe();
        setTimeout(resumeAutoplay, 2000);
    }

    function handleSwipe() {
        const swipeThreshold = 50;
        const diff = touchStartX - touchEndX;
        
        if (Math.abs(diff) > swipeThreshold) {
            if (diff > 0) {
                // Swipe left - next slide
                next();
            } else {
                // Swipe right - previous slide
                prev();
            }
        }
        
        // Reset touch positions
        touchStartX = 0;
        touchEndX = 0;
    }

    onMount(() => {
        updateLayout();
        
        // Small delay to ensure DOM is ready
        setTimeout(() => {
            scrollToSlide(0, false);
            startAutoplay();
        }, 100);

        const handleResize = () => {
            const oldIndex = activeIndex;
            updateLayout();
            // Recalculate position after resize without animation
            requestAnimationFrame(() => {
                scrollToSlide(oldIndex, false);
            });
        };

        const handleKeydown = (e: KeyboardEvent) => {
            if (e.target instanceof HTMLInputElement || e.target instanceof HTMLTextAreaElement) {
                return; // Don't handle if user is typing
            }
            
            if (e.key === 'ArrowLeft') {
                e.preventDefault();
                prev();
                pauseAutoplay();
                setTimeout(resumeAutoplay, 3000);
            }
            if (e.key === 'ArrowRight') {
                e.preventDefault();
                next();
                pauseAutoplay();
                setTimeout(resumeAutoplay, 3000);
            }
        };

        window.addEventListener('resize', handleResize);
        window.addEventListener('keydown', handleKeydown);
        
        // Add scroll listener with proper cleanup
        let scrollElement: HTMLElement | null = null;
        const addScrollListener = () => {
            if (container && container !== scrollElement) {
                // Remove old listener if exists
                if (scrollElement) {
                    scrollElement.removeEventListener('scroll', handleScroll);
                }
                // Add new listener
                container.addEventListener('scroll', handleScroll, { passive: true });
                scrollElement = container;
            }
        };
        
        // Initial setup
        addScrollListener();
        
        // Re-check periodically in case container changes
        const intervalId = setInterval(addScrollListener, 1000);

        return () => {
            window.removeEventListener('resize', handleResize);
            window.removeEventListener('keydown', handleKeydown);
            if (scrollElement) {
                scrollElement.removeEventListener('scroll', handleScroll);
            }
            clearInterval(intervalId);
            if (scrollTimeout) {
                clearTimeout(scrollTimeout);
            }
        };
    });

    onDestroy(() => {
        stopAutoplay();
    });

    // Calculate maximum navigable slides (slides that actually cause scroll)
    const maxNavigableIndex = $derived(() => {
        if (!apps) return 0;
        // En desktop (3 cards), si hay 7 elementos, solo necesitas scrollear hasta el índice 4 (mostrando 5, 6, 7)
        // En tablet (2 cards), si hay 7 elementos, scrolleas hasta el índice 5 (mostrando 6, 7)
        // En móvil (1 card), scrolleas todos los elementos
        const maxIndex = Math.max(0, apps.length - cardsPerView);
        return maxIndex;
    });
    
    // Calculate if navigation buttons should be shown
    const showNavigation = $derived(apps && apps.length > cardsPerView);
    const canScrollPrev = $derived(apps && apps.length > 0);
    const canScrollNext = $derived(apps && apps.length > 0);
</script>

<section class="py-16 min-h-screen flex items-center">
    <div class="max-w-7xl mx-auto px-4 w-full">
        <!-- Title Section -->
        <div class="text-center mb-12">
            <h1>Nuestras Aplicaciones</h1>
            <p class="text-lg max-w-2xl mx-auto mt-4" style="color: var(--muted-text);">
                Descubre nuestro ecosistema de aplicaciones diseñadas para simplificar tu vida
            </p>
        </div>

        <!-- Carousel Container -->
        <div class="relative">
            <!-- Navigation Buttons -->
            {#if showNavigation}
                <button
                    aria-label="Anterior"
                    onclick={prev}
                    onmouseenter={pauseAutoplay}
                    onmouseleave={resumeAutoplay}
                    class="absolute left-4 top-1/2 -translate-y-1/2 z-10 bg-white/90 backdrop-blur-sm rounded-full p-3 shadow-lg hover:bg-white hover:shadow-xl transition-all duration-300 disabled:opacity-50 disabled:cursor-not-allowed group"
                    disabled={!canScrollPrev}
                >
                    <svg class="w-6 h-6 text-gray-700 group-hover:text-gray-900 transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
                    </svg>
                </button>

                <button
                    aria-label="Siguiente"
                    onclick={next}
                    onmouseenter={pauseAutoplay}
                    onmouseleave={resumeAutoplay}
                    class="absolute right-4 top-1/2 -translate-y-1/2 z-10 bg-white/90 backdrop-blur-sm rounded-full p-3 shadow-lg hover:bg-white hover:shadow-xl transition-all duration-300 disabled:opacity-50 disabled:cursor-not-allowed group"
                    disabled={!canScrollNext}
                >
                    <svg class="w-6 h-6 text-gray-700 group-hover:text-gray-900 transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                    </svg>
                </button>
            {/if}

            <!-- Cards Container -->
            <div 
                bind:this={container}
                class="overflow-x-auto scrollbar-hide scroll-smooth"
                onmouseenter={pauseAutoplay}
                onmouseleave={resumeAutoplay}
                ontouchstart={handleTouchStart}
                ontouchmove={handleTouchMove}
                ontouchend={handleTouchEnd}
                role="region"
                aria-label="Carrusel de aplicaciones"
                style="scroll-snap-type: x mandatory; -webkit-overflow-scrolling: touch;"
            >
                <div class="flex gap-6 px-4" style="width: fit-content;">
                    {#if apps && apps.length}
                        {#each apps as app, index (app.titulo)}
                            <div 
                                data-card 
                                data-index={index}
                                class="app-card flex-shrink-0 rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-500 overflow-hidden group"
                                style="width: {cardWidth}px; scroll-snap-align: start; background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.9) 100%); border: 1px solid rgba(158, 190, 104, 0.3);"
                            >
                                <div class="h-full flex flex-col">
                                    <!-- Image Container with Gradient Overlay -->
                                    <div class="relative h-52 overflow-hidden" style="background: linear-gradient(135deg, rgba(158, 190, 104, 0.1) 0%, rgba(163, 216, 0, 0.1) 100%);">
                                        <div class="absolute inset-0 bg-gradient-to-t from-black/10 to-transparent z-10"></div>
                                        <img 
                                            src={app.img} 
                                            alt={app.alt} 
                                            class="w-full h-full object-contain p-4 group-hover:scale-110 transition-transform duration-700" 
                                            loading="lazy"
                                        />
                                    </div>
                                    
                                    <!-- Content -->
                                    <div class="p-5 flex-1 flex flex-col">
                                        <h3 class="text-xl font-bold mb-2 transition-colors duration-300" style="color: var(--primary-background);">
                                            {app.titulo}
                                        </h3>
                                        <p class="leading-relaxed flex-1 text-sm" style="color: var(--primary-background); opacity: 0.75;">
                                            {app.descripcion}
                                        </p>
                                        
                                        <!-- Action Button -->
                                        <div class="mt-4 pt-4" style="border-top: 1px solid rgba(158, 190, 104, 0.3);">
                                            <button 
                                                class="w-full text-white py-2.5 px-4 rounded-lg transition-all duration-300 transform hover:scale-105 font-medium text-sm shadow-md hover:shadow-lg" 
                                                style="background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);"
                                                aria-label="Ver más sobre {app.titulo}"
                                            >
                                                Ver más
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        {/each}
                    {:else}
                        <div class="w-full p-12 bg-white rounded-2xl shadow-lg text-center">
                            <div class="text-6xl mb-4">🚧</div>
                            <h3 class="text-xl font-semibold text-gray-800 mb-2">En construcción</h3>
                            <p class="text-gray-600">No hay aplicaciones para mostrar en este momento.</p>
                        </div>
                    {/if}
                </div>
            </div>
        </div>

        <!-- Indicators - Solo mostrar posiciones navegables -->
        {#if apps && apps.length > cardsPerView}
            {@const maxIndex = Math.max(0, apps.length - cardsPerView)}
            <div class="flex justify-center items-center mt-8 gap-3">
                <!-- Play/Pause Button -->
                <button
                    class="mr-2 p-2 rounded-full bg-white/10 hover:bg-white/20 transition-colors duration-200"
                    onclick={() => isPaused ? resumeAutoplay() : pauseAutoplay()}
                    aria-label={isPaused ? 'Reanudar autoplay' : 'Pausar autoplay'}
                    title={isPaused ? 'Reanudar autoplay' : 'Pausar autoplay'}
                >
                    {#if isPaused}
                        <!-- Play icon -->
                        <svg class="w-4 h-4 text-white" fill="currentColor" viewBox="0 0 20 20">
                            <path d="M8 5v10l8-5-8-5z"/>
                        </svg>
                    {:else}
                        <!-- Pause icon -->
                        <svg class="w-4 h-4 text-white" fill="currentColor" viewBox="0 0 20 20">
                            <path d="M6 4h2v12H6zM12 4h2v12h-2z"/>
                        </svg>
                    {/if}
                </button>
                
                {#each Array(maxIndex + 1) as _, i}
                    {@const slideApps = apps.slice(i, i + cardsPerView)}
                    {@const tooltipText = slideApps.map((a: App) => a.titulo).join(', ')}
                    <button
                        class="relative group transition-all duration-300 hover:scale-125"
                        onclick={() => goToSlide(i)}
                        aria-label={`Ir a ${tooltipText}`}
                    >
                        <div class="w-3 h-3 rounded-full transition-all duration-300 {i === activeIndex ? 'scale-125' : 'hover:bg-gray-500'}" style="background-color: {i === activeIndex ? 'var(--secondary-color)' : '#9ca3af'}"></div>
                        <!-- Tooltip -->
                        <div class="absolute bottom-6 left-1/2 transform -translate-x-1/2 bg-black text-white text-xs px-2 py-1 rounded opacity-0 group-hover:opacity-100 transition-opacity duration-200 whitespace-nowrap pointer-events-none">
                            {tooltipText}
                        </div>
                    </button>
                {/each}
            </div>
        {/if}

        <!-- Progress Bar -->
        {#if apps && apps.length > cardsPerView}
            {@const maxIndex = Math.max(0, apps.length - cardsPerView)}
            {@const totalSlides = maxIndex + 1}
            <div class="mt-6 max-w-md mx-auto">
                <div class="w-full bg-gray-600 rounded-full h-1">
                    <div 
                        class="h-1 rounded-full transition-all duration-500"
                        style="width: {((activeIndex + 1) / totalSlides) * 100}%; background: linear-gradient(90deg, var(--primary-color) 0%, var(--secondary-color) 100%);"
                    ></div>
                </div>
                <div class="text-center mt-2 text-sm" style="color: var(--muted-text);">
                    {activeIndex + 1} de {totalSlides}
                    {#if cardsPerView > 1}
                        <span class="opacity-60">• Mostrando {Math.min(cardsPerView, apps.length - activeIndex)} de {apps.length} apps</span>
                    {/if}
                </div>
            </div>
        {/if}
    </div>
</section>

<style>
    /* Hide scrollbar for smooth scrolling */
    .scrollbar-hide {
        -ms-overflow-style: none;
        scrollbar-width: none;
    }
    
    .scrollbar-hide::-webkit-scrollbar {
        display: none;
    }

    /* Enhanced card animations */
    .app-card {
        transform: translateY(0);
        transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
        height: 450px; /* Altura fija para consistencia */
        backdrop-filter: blur(5px);
    }

    .app-card:hover {
        transform: translateY(-8px);
        box-shadow: 
            0 20px 40px rgba(158, 190, 104, 0.2),
            0 8px 16px rgba(0,0,0,0.1);
        background: linear-gradient(135deg, rgba(255,255,255,0.98) 0%, rgba(255,255,255,0.95) 100%) !important;
        border-color: var(--primary-color) !important;
    }

    /* Responsive height adjustments */
    @media (max-width: 640px) {
        .app-card {
            height: 420px;
        }
    }

    @media (min-width: 768px) {
        .app-card {
            height: 440px;
        }
    }

    @media (min-width: 1024px) {
        .app-card {
            height: 460px;
        }
    }

    /* Smooth focus indicators */
    button:focus-visible {
        outline: 2px solid var(--secondary-color);
        outline-offset: 2px;
    }

    /* Tooltip styling */
    .group:hover .group-hover\:opacity-100 {
        opacity: 1 !important;
    }

    /* Custom scrollbar for better UX on desktop */
    @media (min-width: 1024px) {
        .scrollbar-hide::-webkit-scrollbar {
            height: 4px;
            display: block;
        }
        
        .scrollbar-hide::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 2px;
        }
        
        .scrollbar-hide::-webkit-scrollbar-thumb {
            background: var(--secondary-color);
            border-radius: 2px;
        }
        
        .scrollbar-hide::-webkit-scrollbar-thumb:hover {
            background: var(--primary-color);
        }
    }
</style>