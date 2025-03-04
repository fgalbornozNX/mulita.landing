<script lang="ts">
    let imgSrc = '/mulita.webp';
    let imgAlt = 'Logo Mulita App';
</script>

<style>
    /* Estilo del logo y el título */
    .logo {
        font-size: 4rem;
        font-weight: bold;
        color: #FFFFFF;
        margin-bottom: 1rem;
    }
    
    .logo img {
        width: 60%; /* Ajusta el tamaño en función del 60% del ancho de la pantalla */
        max-width: 800px; /* Limita el tamaño máximo */
        height: auto;
        border-radius: 25%;
        margin-bottom: 0px;
    }
    
    /* Media query para pantallas más grandes */
    @media (min-width: 1366px) {
        .logo img {
            width: 80%; /* Aún más pequeño en pantallas grandes */
        }
    }
    
    /* Media query para dispositivos móviles */
    @media (max-width: 768px) {
        .logo img {
            width: 80%; /* Logo más grande en pantallas pequeñas */
        }
    }
</style>

<div class="logo">
    <img src={imgSrc} alt={imgAlt} />
    <p>Mulita App</p>
</div>