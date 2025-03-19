<script lang="ts">
    let {apps} = $props();
</script>

<style>
    .titulo{
        width: 300px;
        border-top-style: solid;
        border-top-width: 2px;
        color: #9ebe68;
    }

    h1{
        color: #9ebe68;
        margin: 0px;
    }

    .aplicacionI {
    background: #343233;
    padding: 20px;
    border-radius: 10px;
    }

    .aplicacionD {
    background: #343233;
    padding: 20px;
    border-radius: 10px;
    
    /* Mantener la estructura sin empujar todo a la derecha */
    display: flex;
    flex-direction: column; /* Mantiene alineación vertical */
    align-items: flex-end; /* Solo alinea los elementos, sin afectar su estructura */
}

    .aplicacionD .aplicacion-container-detalles {
        display: flex;
        flex-direction: row-reverse; /* Invierte el orden de los elementos */
        text-align: right; /* Solo afecta el texto, sin mover el layout */
    }


    .aplicacion-titulo{
        width: 300px;
        border-top-style: solid;
        border-top-width: 1px;
        color: #979595;
    }

    .aplicacion-container{
        text-align: center;
    }

    .aplicacion-container-detalles {
        display: flex;
        flex-direction: row;
        flex-wrap: wrap; /* Permite que los botones se ajusten en múltiples filas si es necesario */
    }

    .aplicacion-container-detalles button {
        background: #343233;
        color: #ffffff;
        border: none;
        padding: 10px 20px;
        border-radius: 5px;
        cursor: pointer;
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

{#each apps as app, i}
    <!-- Si es par, a la izquierda, sino a la derecha (uno y uno) -->
    <div class={i % 2 === 0 ? "aplicacionI" : "aplicacionD"}>
        <div class="aplicacion-titulo">
            <h2>{app.titulo}</h2>
        </div>
        <div class="aplicacion-container">
            <div class="aplicacion-container-detalles">
                <!-- Para cada app dentro del array 'apps', cargo su imagen con su texto alt -->
                <img src={app.img} alt={app.alt} class="aplicacion-logo"/>
                
                <div class="aplicacion-info">
                    <p>{app.descripcion}</p>
                    <button>Saber más</button>
                </div>
            </div>
        </div>
    </div>
{/each}