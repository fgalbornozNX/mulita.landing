<script>
	import '../global.css';

	let { integrantes } = $props();
</script>

<section class="about-section">
	<div class="titulo">
		<h1>Nosotros</h1>
	</div>
	
	<p>Esta página habla de nosotros</p>

	<div class="carousel-container">
		<div class="icon-cards">
			{#each integrantes as integrante}
				<div class="icon-cards_item">
					<h2>{integrante.nombre}</h2>
					<img src={integrante.img} alt={integrante.alt} class="integrante-foto" />
					<p>{integrante.descripcion}</p>
				</div>
			{/each}
		</div>
	</div>
</section>

<style>
    .about-section {
        height: 100vh; /* 100% del alto de la ventana */
        width: 100%;
        box-sizing: border-box;
        position: relative;
		margin-bottom: 10px;
        padding-top: 60px; /* Añadir padding-top para compensar la barra de menú superior */
    }

	p {
		color: #979595;
		margin-bottom: 20px;
	}

	.titulo {
		margin-top: 60px;
	}

	.icon-cards{
		display: flex;
	}

	.icon-cards_item{
		width: 300px;
		margin: 30px;
	}

	.integrante-foto {
        max-width: 90vh;
		width: 300px;
		border-radius: 10px;
    }
</style>
