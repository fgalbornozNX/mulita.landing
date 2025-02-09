<script lang="ts">
    import { goto } from '$app/navigation';
	let { children } = $props();

    let activeSection = $state('Inicio'); // Variable para la sección activa

    // Función para cambiar la sección activa
    function setActiveSection(section: string) {
        activeSection = section;
        switch (activeSection) {
            case 'Inicio':
                goto('/');
                break;
            case 'Aplicaciones':
                goto('/apps');
                break;
            case 'Nosotros':
                goto('/about');
                break;
        }
    }
</script>

<style>
    @import 'styles.css';
</style>

<div class="container">
    <div class="menu">
        <button 
            class:selected={activeSection === 'Inicio'} 
            onclick={() => setActiveSection('Inicio')}>
            Inicio
        </button>
        <button 
            class:selected={activeSection === 'Aplicaciones'} 
            onclick={() => setActiveSection('Aplicaciones')}>
            Aplicaciones
        </button>
        <button 
            class:selected={activeSection === 'Nosotros'} 
            onclick={() => setActiveSection('Nosotros')}>
            Nosotros
        </button>
    </div>
</div>

{@render children()}