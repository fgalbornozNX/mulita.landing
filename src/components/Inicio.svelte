<script lang="ts">
	import '../global.css';
	import { onMount } from 'svelte';
	import gsap from 'gsap';

	onMount(() => {
		/* PROBAR: Ejecuta después de haber cargado las fuentes
		document.fonts.onloadingdone = () => {

		}; */
		
		let tl = gsap.timeline();
		tl.to('.logo', { duration: 1.5, y: 18, rotation: 5 })
		  .to('.logo', { duration: 1.5, y: 0, rotation: 0 });

	});
</script>

<div class="inicio-section">
	<div class="cuerpo">
		<!-- Logo de Mulita App -->
		<svg
			class="logo"
			id="Capa_1"
			data-name="Capa 1"
			xmlns="http://www.w3.org/2000/svg"
			viewBox="0 0 1023.81 992.75"
		>
			<defs>
				<style>
					.color {
						fill: var(--text-color);
					}

					.bg {
						fill: var(--primary-color);
					}
				</style>
			</defs>
			<path class="bg" d="M1012.72,323.99c7.91-19.66,23.16-68.41-6.11-96.51-8.98-8.62-21.27-13.18-35.54-13.18-15.97,0-36.54,6.11-55.79,15.67C827.16,91.71,672.48,0,496.38,0,222.24,0,0,222.24,0,496.38s222.24,496.38,496.38,496.38,496.38-222.24,496.38-496.38c0-42.09-5.25-82.96-15.11-121.99,18.67-14.35,30.04-37.89,35.08-50.4Z"/>
			<path class="color" d="M620.12,744.31c.1,6.32-7.76,9.23-11.78,4.36-.03-.04-.06-.07-.09-.11-15.68-18.91-45.62-43.81-80.89-67.58-5.15-3.47-3.17-11.46,3.01-12.12,16.24-1.71,31.81-6.59,50.68-20.02,3.19-2.27,7.67-1.28,9.6,2.13,16.65,29.36,29.12,70.34,29.47,93.34Z"/>
			<path class="color" d="M897.86,298.74c0,16.56,26.46,51.45,48.08,48.13,30.99-4.77,60.69-75.89,37.5-91.29-21.03-13.97-85.58,13.3-85.58,43.16Z"/>
			<path class="color" d="M835.76,289.19c-61.65-17.04-124.62-3.85-132.26,10-5.2,9.45,2.89,56.63,8.56,85.71,2.81,14.38,9.27,27.78,18.82,38.89,16.89,19.65,44.53,54.49,57.08,85.45,18.75,46.23,18.1,77.5,30.87,107.8,12.77,30.3,44.93,78.91,82.49,65.57,37.56-13.34,45.57-191.71,45.57-191.71,0,0,8-163.04-111.14-201.72ZM771.43,421.78c-7.08.89-17.29-.95-22.86-5.4s-8.91-11.53-4.08-17.96c7.11-11.85,33.35-11.8,41.91-1.91,11.34,13.1-1.67,23.6-14.97,25.27ZM801.48,305.84c11.85-3.56,26.06,3.62,27.17,11.96,2.15,16.22-16.6,17.78-27.27,11.85-10.67-5.93-11.76-20.25.1-23.81ZM825.1,480.2c-12,1.49-24.5-9.19-16.6-20.15,5-6.94,26.08-6.09,27.27,7.11.64,7.08-4.48,12.27-10.67,13.04ZM859.47,365.21c2.66-9.87,25.94-10.03,30.82,2.37,4.07,10.35-8.04,14.04-14.69,12.87-10.51-1.84-18.15-7.74-16.13-15.24ZM889.44,598.14c-9.86,9.78-29.58,1.05-27.56-8.76s15.57-9.93,22.7-6.24c4.71,2.44,9.72,10.17,4.85,14.99ZM910.36,506.99c-5.21,1.28-21.39.34-25.77-6.26s.25-11.64,6.66-13.09c6.42-1.45,16.69.21,22.38,5.24,5.03,4.44,3.35,12.48-3.28,14.11Z"/>
			<path class="color" d="M880.43,707.86c-.13-.03-.26-.06-.39-.09.29.04.59.08.88.11-.17,0-.32,0-.49-.02Z"/>
			<path class="color" d="M898.08,717.03c-1.05-4.29-8.48-7.99-14.78-8.9-120.4-33.51-77.02-163.48-151.63-244.8-31.01-41.62-54.29-86.36-53.45-141.2.08-5.25-1.46-10.42-4.39-14.77-18.61-27.64-52.14-49.99-77.43-51.95h-.01c-42.28-3.86-42.31,45.85-31.23,75.66,7.47,20.09,32.24,45.72,44.99,62.2,6.88,8.89,8.28,20.88,3.61,31.11-10.42,22.78-36.91,41.06-16.39,93.5,22.94,50.09,78.04,80.81,118.37,116.42,33.64,31.37,41.41,77.94,90.95,96.03,23.8,9.52,52.32,10.01,84.77-5.39,5.59-2.53,7.25-5.33,6.62-7.91ZM664.84,382.33c-.72,4.31-6.29,5.73-9.06,2.36-3.82-4.65-7.9-13.18-14.2-20.23-1.75-1.95-3.75-3.67-5.86-5.22-40.26-29.73-54.19-53.35-48.29-67.52,1.67-4,6.16-5.95,10.23-4.47,22.27,8.07,72.06,65.69,67.18,95.08ZM741.41,570.19c-2.19,3.94-6.27,6.16-10.47,6.16-1.97,0-3.96-.49-5.8-1.51-39.14-21.73-53.18-57.39-53.76-58.9-2.36-6.17.72-13.09,6.89-15.46,6.16-2.36,13.05.71,15.44,6.85.2.52,11.91,29.31,43.04,46.59,5.78,3.21,7.86,10.5,4.66,16.27Z"/>
			<path class="color" d="M328.29,595.3c4.14,3.66,1.23,10.46-4.28,9.96-135.66-12.36-232.05-201.61-235.07-215.66-14.14-65.69,174.67-304.73,172.74-212.11-.38,3.68-.76,7.58-1.12,11.72-3.23,36.62-4.59,80.06-3.82,122.29,1.22,66.13,8.95,186.9,47.07,252.93,7.73,13.39,16.05,23.41,24.48,30.87Z"/>
			<path class="color" d="M535.97,95.58c-136.19,108.6-210.56,318.91-155.83,481.22,2.7,7.99-4.39,15.82-12.62,13.95-116.63-26.6-86.49-451.72-68.99-465.67,67.87-54.11,151.79-58.13,232.01-48.55,9.44,1.13,12.86,13.13,5.42,19.06Z"/>
			<path class="color" d="M819.77,248.06c-26.05-2.71-68.37-6.44-114.69,21.64-4.27,2.59-9.66,2.41-13.78-.41-19.37-13.27-68.67-53.57-117.81-49.64-11.28.91-20.94,7.19-29.11,16.97-5.54,6.63-24.61,52.88-1.19,102.61,2.22,4.71,4.25,9.78,7.1,14.67,8.15,13.94,19.75,27.75,30.32,40.32,1.83,2.18,3.89,4.63,5.88,7.05,5,6.06,5.61,14.64,1.47,21.32-.71,1.15-1.49,2.39-2.34,3.72-2.39,3.76-5.04,7.91-7.57,12.54-10.32,18.82-18.9,45.67-2.51,87.58l.24.62.27.6c1.21,2.65,2.5,5.24,3.84,7.78,1.8,3.41,3.16,7.03,3.94,10.81l.07.32c1.79,8.63.51,17.61-3.56,25.42-8.1,15.54-7.72,19.02-6.12,26.38,2.33,10.73-2.47,21.71-11.82,27.46-57.23,35.24-120.26,13.81-139.77-8.88-32.17-55.9-51.84-176.15-21.46-274.06,52.22-177.55,171.58-255.23,196.88-254.22,67.83,2.75,168.89,74.92,227.24,149.32,3.41,4.35-.04,10.67-5.54,10.09Z"/>
			<path class="color" d="M305.26,666.84c-47.98,25.37-118.42,33.92-175.31,21.29-9.25-2.05-12.83-9.62-14.39-12.96-31.91-69.19-50.13-155.46-37.06-233.7.47-2.81,4.14-3.61,5.76-1.26h0c51.49,83.79,129.16,175.09,239.41,189.33,2.71.35,5.39.99,7.9,2.09,21.19,9.24-11.52,26.89-26.13,35.12l-.17.1Z"/>
			<path class="color" d="M627.08,839.92c1.58,25.22-8.05,65.65-139.44,65.65-142.23,0-267.89-70.91-343.54-179.33-3.45-4.94.53-11.6,6.52-10.89,11.23,1.32,22.83,1.99,34.71,1.99,47.41,0,102.12-12.74,131.04-29.85,40.4-23.9,47.07-43.02,44.86-51.98-.77-3.12,1.3-5.38,4.62-4.8,76.77,13.44,191.39,93.05,224.35,132.82,25.8,31.12,35.64,56.44,36.89,76.4Z"/>
			<path class="color" d="M660.27,857.59c-1.47-150.45-37.14-191.77-48.73-232.91-2.62-9.3,6.82-17.36,15.57-13.29,77.24,35.99,140.8,93.4,150.55,180.27,2.04,18.19-72.83,72-100.04,76.61-8.74,1.48-17.27-1.82-17.35-10.68Z"/>
		</svg>
		<div class="titulo">
			<p>MULITA</p>
		</div>
	</div>
</div>

<style>
	/* Estilo del logo y el título */
	.cuerpo {
		font-family: PilcrowRounded-Bold;
		font-size: 3rem;
		/* font-weight: bold; */
		color: var(--text-color);
		/* margin-bottom: 2rem; /* Espacio adicional para que el título no quede tapado */
	}

	.logo {
		width: 55%; /* Ajusta el tamaño en función del 60% del ancho de la pantalla */
		max-width: 400px; /* Limita el tamaño máximo */
		height: auto;
		border-radius: 25%;
		margin-bottom: 0px;
	}

	.titulo P {
		font-size: 3.5rem;
	}

	/* Media query para pantallas más grandes */
	@media (min-width: 1366px) {
		.logo {
			width: 70%; /* Aún más pequeño en pantallas grandes */
		}
	}

	/* Media query para dispositivos móviles */
	@media (max-width: 768px) {
		.logo {
			width: 80%; /* Logo más grande en pantallas pequeñas */
		}
	}

	/* Estilo para la sección Inicio para no quedar tapada por el menú */
	.inicio-section {
		height: 100vh; /* Altura completa de la ventana */
		display: grid;
		align-items: center;
	}
</style>
