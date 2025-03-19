<script lang="ts">
    let {apps} = $props();
</script>

<style>
.titulo, .aplicacion-titulo {
    width: 300px;
    border-top: 2px solid #9ebe68;
    color: #9ebe68;
    text-align: center;
    margin-bottom: 10px;
}

h1{
    color: #9ebe68;
    margin: 0px;
}

.aplicacionI, .aplicacionD {
    width: 45%; /* Casi la mitad de la pantalla */
    max-width: 600px; /* No ser demasiado anchas */
    background: #343233;
    padding: 20px;
    border-radius: 10px;
    display: flex;
    flex-direction: column;
    margin: 20px auto; /* Espaciado entre elementos */
    clear: both; /* Esto asegura que cada tarjeta empiece en una nueva fila */
}

/* Alinear a la izquierda */
.aplicacionI {
    float: left;
    margin-left: 5%;
}

/* Alinear a la derecha */
.aplicacionD {
    float: right;
    margin-right: 5%;
}

/* 📌 En pantallas grandes (más de 1424px) aseguramos que cada uno ocupe una fila completa */
@media (min-width: 1424px) {
    .aplicacionI, .aplicacionD {
        width: 50%; /* Ocupar exactamente la mitad */
        display: block; /* Forzar a que cada uno esté en su línea */
    }
}

/* 📌 En móviles los centramos */
@media (max-width: 768px) {
    .aplicacionI, .aplicacionD {
        width: 90%; /* Usar casi toda la pantalla */
        float: none; /* Eliminar float */
        margin: 10px auto; /* Centrar */
    }

    .aplicacion-container-detalles {
        flex-direction: column;
        align-items: center;
        text-align: center;
    }
}

@media (max-width: 600px) {
    .aplicacionD .aplicacion-container-detalles {
        flex-direction: column; /* También invertir en móviles */
    }

    .aplicacion-logo {
        width: 80px;
        height: 80px;
    }

    .aplicacion-info {
        margin-left: 0; /* Quitar margen en móviles para centrar */
    }
}

.clearfix {
    margin-bottom: 60px;
}

.clearfix::after {
    content: "";
    display: table;
    clear: both;
}

.aplicacion-container-detalles {
    display: flex;
    align-items: center; /* Asegura que los elementos estén alineados verticalmente */
    justify-content: center; /* Distribuye bien los espacios */
    gap: 15px; /* Espaciado entre logo y texto */
}

/* Invierte el orden en las tarjetas impares */
.aplicacionD .aplicacion-container-detalles {
    flex-direction: row-reverse;
}


.aplicacion-container{
    text-align: center;
}

.aplicacion-container-detalles button {
background: #9ebe68;
color: #343233;
border: none;
padding: 10px 20px;
border-radius: 5px;
cursor: pointer;
font-weight: bold;
transition: background 0.3s ease-in-out, transform 0.2s ease-in-out;
}

.aplicacion-container-detalles button:hover {
    background: #7ea84e;
    transform: scale(1.05);
}

.aplicacion-logo{
    width: 100px;
    height: 100px;
}

.aplicacion-info{
    margin-left: 20px;
}

h2{
    color: #ffffff;
    margin: 0px;
}

p{
    color: #979595;
}
</style>

<div class="titulo">
    <h1>APLICACIONES</h1>
</div>

<div class="clearfix">
    {#each apps as app, i}
        <div class={i % 2 === 0 ? "aplicacionI" : "aplicacionD"}>
            <div class="aplicacion-titulo">
                <h2>{app.titulo}</h2>
            </div>
            <div class="aplicacion-container">
                <div class="aplicacion-container-detalles">
                    <img src={app.img} alt={app.alt} class="aplicacion-logo"/>
                    <div class="aplicacion-info">
                        <p>{app.descripcion}</p>
                        <button>Saber más</button>
                    </div>
                </div>
            </div>
        </div>
    {/each}
</div>