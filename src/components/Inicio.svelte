<script lang="ts">
    let imgSrc = '/mulita.webp';
    let imgAlt = 'Logo Mulita App';
</script>

<style>
    /* Estilo del logo y el título */
    .logo {
        font-size: 3rem;
        font-weight: bold;
        color: #FFFFFF;
        /* margin-bottom: 2rem; /* Espacio adicional para que el título no quede tapado */
    }
    
    .logo img {
        width: 60%; /* Ajusta el tamaño en función del 60% del ancho de la pantalla */
        max-width: 800px; /* Limita el tamaño máximo */
        height: auto;
        border-radius: 25%;
        margin-bottom: 0px;
    }

    .logo p {
        margin-top: 0.5rem; /* Espacio entre el logo y el título */
    }
    
    /* Media query para pantallas más grandes */
    @media (min-width: 1366px) {
        .logo img {
            width: 70%; /* Aún más pequeño en pantallas grandes */
        }
    }
    
    /* Media query para dispositivos móviles */
    @media (max-width: 768px) {
        .logo img {
            width: 80%; /* Logo más grande en pantallas pequeñas */
        }
    }

    /* Estilo para la sección Inicio para no quedar tapada por el menú */
    .inicio-section {
        padding-bottom: 60px; /* Agrega espacio para que el menú no tape el contenido */
    }
</style>

<div class="inicio-section">
    <div class="logo">
        <img src={imgSrc} alt={imgAlt} />
        <p>Mulita App</p>
    </div>
</div>
