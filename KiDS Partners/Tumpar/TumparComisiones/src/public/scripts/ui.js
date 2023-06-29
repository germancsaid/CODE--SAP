/**
 * *Import constants
 */
import {
  c_enviando_parametros_de_calculo,
  c_enviando_parametros_para_detalle,
} from "./socketClient.js";

/**
 * *Let
 */

console.log(userData.PlayerName);

/**
 * *Fuctions backend
 */

// Function to save new event backlog and insert one into the DB
export const c_function_enviar_parametros_de_calculo = (e) => {
  c_enviando_parametros_de_calculo(
    FormCalcularComision["FechaInicial"].value,
    FormCalcularComision["FechaFinal"].value,
    FormCalcularComision["Vendedor"].value,
    FormCalcularComision["Sucursal"].value,
    FormCalcularComision["VistaList"].value,
  );
  console.log('Enviando parametros...')
  /*FormCalcularComision.reset();*/
};

// Function to save new event backlog and insert one into the DB
export const c_function_enviar_parametros_para_detalle = (e) => {
  c_enviando_parametros_para_detalle(
    FormVerDetalle["FechaInicial"].value,
    FormVerDetalle["FechaFinal"].value,
    FormVerDetalle["Vendedor"].value,
  );
  console.log('Enviando parametros...')
};

// Container to publish old events and new events
const tablaTotales = document.querySelector(
  "#tablaTotales"
);
// Function publish events list from event_backlog from DB
export const publish_totales = (data_totales) => {
  tablaTotales.innerHTML = "";
  data_totales.forEach((tablaTotalesLine) =>
    tablaTotales.append(data_totales_UI(tablaTotalesLine))
    );
};


// Container to publish old events and new events
const data_totales_UI = (tablaTotalesLine) => {
  const tr = document.createElement("tr");
  tr.innerHTML = `
  <td class="center" style="width: 1%;">${tablaTotalesLine.CODE}</td>
  <td class="left" style="width: 24%;">${tablaTotalesLine.VENDEDOR}</td>
  <td class="center" style="width: 6%;">${tablaTotalesLine.CC}</td>
  <td class="center" style="width: 7%;">${parseFloat(tablaTotalesLine.CONTADO).toFixed(2)}</td>
  <td class="center" style="width: 7%;">${parseFloat(tablaTotalesLine.CREDITO).toFixed(2)}</td>
  <td class="center" style="width: 7%;">${parseFloat(tablaTotalesLine.ANTICIPO).toFixed(2)}</td>
  <td class="center" style="width: 7%;">${parseFloat(tablaTotalesLine.OTROS).toFixed(2)}</td>
  <td class="center" style="width: 7%;">${parseFloat(tablaTotalesLine.NOTAS_CREDITO).toFixed(2)}</td>
  <td class="center" style="width: 7%;">${parseFloat(tablaTotalesLine.DEVOLUCIONES_OTROS).toFixed(2)}</td>
  <td class="right" style="width: 7%;">${parseFloat(tablaTotalesLine.TOTAL_USD).toFixed(2)}</td>
  <td class="right" style="width: 7%;">${parseFloat(tablaTotalesLine.Comision).toFixed(2)}</td>
  `;

  return tr;
};
// Function publish events list from event_backlog from DB
export const publish_totales_resumen = (data_totales) => {
  tablaTotales.innerHTML = "";
  data_totales.forEach((tablaTotalesLine) =>
    tablaTotales.append(data_totales_resumen_UI(tablaTotalesLine))
    );
};


// Container to publish old events and new events
const data_totales_resumen_UI = (tablaTotalesLine) => {
  const tr = document.createElement("tr");
  tr.innerHTML = `
  <td class="center" style="width: 10%;">${tablaTotalesLine.CC}</td>
  <td class="center" style="width: 50%;">Nombre del Jefe de ventas de sucursal</td>
  <td class="right" style="width: 20%;">${parseFloat(tablaTotalesLine.TOTAL_USD).toFixed(2)}</td>
  <td class="right" style="width: 20%;">${parseFloat(tablaTotalesLine.Comision).toFixed(2)}</td>
  `;
  return tr;
};


// Container to publish old events and new events
const TablaDetalle = document.querySelector(
  "#TablaDetalle"
);
// Function publish events list from event_backlog from DB
export const publish_detalle = (data_detalle) => {
  TablaDetalle.innerHTML = "";
  data_detalle.forEach((data_detalle_line) =>
  TablaDetalle.append(data_detalle_UI(data_detalle_line))
    );
};


// Container to publish old events and new events
const data_detalle_UI = (data_detalle_line) => {
  const tr = document.createElement("tr");
  tr.innerHTML = `
  <td class="left" style="width: 10%;">
  ${new Date(data_detalle_line.Fecha).toISOString().split('T')[0]}
  </td>
  <td class="center" style="width: 15%;">${data_detalle_line.Tipo}</td>
  <td class="center" style="width: 15%">${data_detalle_line.Pago}</td>
  <td class="center" style="width: 15%;">${parseFloat(data_detalle_line.Monto).toFixed(2)}</td>
  <td class="left" style="width: 45%;">${data_detalle_line.Vendedor}</td>
  `;

  return tr;
};


// Container to publish old events and new events
const SucursalList = document.querySelector(
  "#SucursalList"
);
// Function publish events list from event_backlog from DB
export const publish_cc = (data_cc) => {
  SucursalList.innerHTML = "";
  data_cc.forEach((data_cc_line) =>
  SucursalList.append(data_cc_UI(data_cc_line))
    );
};

// Container to publish old events and new events
const data_cc_UI = (data_cc_line) => {
  const optionElement = document.createElement("option");
  optionElement.value = data_cc_line.CC;
  optionElement.textContent = data_cc_line.text; // Agrega el texto que se mostrará en la opción
  return optionElement;
};


// Container to publish old events and new events
const VendedorList = document.querySelector(
  "#VendedorList"
);
// Function publish events list from event_backlog from DB
export const publish_vendedor = (data_vendedor) => {
  VendedorList.innerHTML = "";
  data_vendedor.forEach((data_vendedor_line) =>
  VendedorList.append(data_vendedor_UI(data_vendedor_line))
    );
};

// Container to publish old events and new events
const data_vendedor_UI = (data_vendedor_line) => {
  const optionElement = document.createElement("option");
  optionElement.value = data_vendedor_line.SlpName;
  optionElement.textContent = data_vendedor_line.text; // Agrega el texto que se mostrará en la opción
  return optionElement;
};

/*========================================================*/

// Container to publish old events and new events
const SucursalListPoli = document.querySelector(
  "#SucursalListPoli"
);
// Function publish events list from event_backlog from DB
export const publish_cc_poli = (data_cc) => {
  SucursalListPoli.innerHTML = "";
  data_cc.forEach((data_cc_line) =>
  SucursalListPoli.append(data_cc_poli_UI(data_cc_line))
    );
};

// Container to publish old events and new events
const data_cc_poli_UI = (data_cc_line) => {
  const optionElement = document.createElement("option");
  optionElement.value = data_cc_line.CC;
  optionElement.textContent = data_cc_line.text; // Agrega el texto que se mostrará en la opción
  return optionElement;
};



// Container to publish old events and new events
const TablaCalculosParametros = document.querySelector(
  "#TablaCalculosParametros"  
);


// Function publish events list from event_backlog from DB
export const publish_parametros_de_calculo = (data_param_orde) => {
  TablaCalculosParametros.innerHTML = "";
  data_param_orde.forEach((data_param_orde_line) =>
  TablaCalculosParametros.append(parametros_de_calculo_UI(data_param_orde_line))
  )
};

// Container to publish old events and new events
const parametros_de_calculo_UI = (data_param_orde_line) => {
  const tr = document.createElement("tr");
  tr.innerHTML = `
  <td class="center" style="width: 1%;">${data_param_orde_line.lineNum}</td>
  <td class="left" style="width: 24%;">${data_param_orde_line.parametro}</td>
  <td class="center" style="width: 7%;">${data_param_orde_line.min}</td>
  <td class="center" style="width: 7%;">${data_param_orde_line.max}</td>
  <td class="center" style="width: 7%;">${data_param_orde_line.tasa}</td>
  <td class="center" style="width: 7%;">${data_param_orde_line.monto}</td>
  <td class="center" style="width: 7%;">Edit</td>
  `;
  return tr;
};