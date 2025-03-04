<script lang="ts">
	let { children } = $props();

    let activeSection = $state('Inicio'); // Variable para la sección activa

    // Función para cambiar la sección activa
    function setActiveSection(section: string) {
        activeSection = section;
        const element = document.getElementById(section);
        if (element) {
            element.scrollIntoView({ behavior: 'smooth' });
        }
    }
</script>

<style>
    /* Estilos generales */
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    .container {
        text-align: center;
    }

    /* Estilo para los botones */
    .menu {
        position: absolute;
        bottom: 20px;
        right: 20px;
        display: flex;
        flex-direction: row;
        gap: 10px;
        flex-wrap: wrap; /* Permite que los botones se ajusten en múltiples filas si es necesario */
    }

    .menu button {
        background-color: #545454;
        color: #FFFFFF;
        border: none;
        padding: 10px 20px;
        font-size: 1.2rem;
        cursor: pointer;
        transition: background-color 0.3s ease, transform 0.3s ease;
        border-radius: 12px;
        flex-grow: 1;
        min-width: 120px;
    }

    .menu button:hover {
        background-color: #333333;
    }

    /* Media query para pantallas más pequeñas (como en móviles) */
    @media (max-width: 768px) {
        .menu {
            bottom: 10px;
            right: 10px;
            gap: 5px; /* Menos espacio entre botones en pantallas pequeñas */
        }
    }

    /* Estilo para el botón activo */
    .menu button.selected {
        background-color: #333333;
        transform: scale(1.1); /* Agranda el botón seleccionado */
    }
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