import {
  c_function_enviar_parametros_de_calculo,
  c_function_enviar_parametros_para_detalle,
  publish_totales,
  publish_totales_resumen,
  publish_detalle,
  publish_cc,
  publish_cc_poli,
  publish_vendedor,
  publish_parametros_de_calculo,
} from "./ui.js";
import {
  c_recibiendo_tabla_totales,
  c_recibiendo_tabla_totales_resumen,
  c_recibiendo_tabla_detalle,
  c_recibiendo_cc,
  c_recibiendo_vendedores,
  c_recibiendo_parametros_ordenados,
} from "./socketClient.js";
/**
 * *DEFINED DATA FROM CLIENT TO THE SEND TO SERVER
 */

  if (window.location.pathname === "/") {
    window.addEventListener("DOMContentLoaded", () => {
      c_recibiendo_tabla_totales(publish_totales);
      c_recibiendo_tabla_totales_resumen(publish_totales_resumen);
      c_recibiendo_vendedores(publish_vendedor)
      c_recibiendo_cc(publish_cc)

        const FormCalcularComision = document.querySelector("#FormCalcularComision");
        const tabla = document.querySelector("#cabecera");
        const cabeceraresumen = document.querySelector("#cabeceraresumen");
        const VistaList = document.querySelector("#VistaList");
        const borde = document.querySelector("#borde");
    
        FormCalcularComision.addEventListener("submit", c_function_enviar_parametros_de_calculo);
        FormCalcularComision.addEventListener("submit", (event) => {
            event.preventDefault(); // Evitar el envío del formulario y la recarga de la página
          
           if (VistaList.value === "Resumen") {
              // Si el campo VistaList es "Resumen"
              cabeceraresumen.style.display = "table"; // Mostrar la "tablita"
              tabla.style.display = "none"; // Ocultar la tabla
              borde.style.display = "none"; // Ocultar el borde

            } else if (VistaList.value === "General"){
              // Si el campo VistaList no es "Resumen"
              cabeceraresumen.style.display = "none"; // Ocultar la "tablita"
              tabla.style.display = "table"; // Mostrar la tabla
              borde.style.display = "none"; // Ocultar el borde
            }
        });
    });
  } else if (window.location.pathname === "/datos") {
    c_recibiendo_vendedores(publish_vendedor)
    c_recibiendo_tabla_detalle(publish_detalle);

    const FormVerDetalle = document.querySelector("#FormVerDetalle");
    const tablaa = document.querySelector("#cabeceraa");
    const bordee = document.querySelector("#bordee");
    FormVerDetalle.addEventListener("submit", c_function_enviar_parametros_para_detalle);
    FormVerDetalle.addEventListener("submit", (event) => {
      event.preventDefault(); // Evitar el envío del formulario y la recarga de la página
      tablaa.style.display = "table";
      bordee.style.display = "none";
    });
  } else if (window.location.pathname === "/politicas") {
    c_recibiendo_cc(publish_cc_poli)
    c_recibiendo_parametros_ordenados(publish_parametros_de_calculo)
  } else if (window.location.pathname === "/cobranzas"){
    c_recibiendo_tabla_totales(publish_totales);
    c_recibiendo_cc(publish_cc)
  }


  
  