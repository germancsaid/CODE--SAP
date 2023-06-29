/**
 * *Socket connection
 */
const socket = io();
const player_id = userData._id

/**
 * * GENERAL
*/
//Click en button calculo de comisiones
export const c_enviando_parametros_de_calculo = (
  FechaInicial,
  FechaFinal,
  Vendedor,
  Sucursal,
  VistaList,
) => {
  socket.emit("client:c_enviando_parametros_de_calculo", {
    FechaInicial,
    FechaFinal,
    Vendedor,
    Sucursal,
    VistaList,
  });
};

export const c_enviando_parametros_para_detalle = (
  FechaInicial,
  FechaFinal,
  Vendedor
) => {
  socket.emit("client:c_enviando_parametros_para_detalle", {
    FechaInicial,
    FechaFinal,
    Vendedor
  });
};

export const c_recibiendo_tabla_totales = (totales) => {
  socket.on("server:s_enviando_totales", totales)
};

export const c_recibiendo_tabla_totales_resumen = (totales) => {
  socket.on("server:s_enviando_totales_resumen", totales)
};
export const c_recibiendo_tabla_detalle = (detalle) => {
  socket.on("server:s_enviando_detalle", detalle)
};
export const c_recibiendo_cc = (cc) => {
  socket.on("server:s_enviando_cc", cc)
};

export const c_recibiendo_vendedores = (vendedores) => {
  socket.on("server:s_enviando_vendedores", vendedores)
};

export const c_recibiendo_parametros = (parametros) => {
  socket.on("server:s_enviando_parametros", parametros)
};

export const c_recibiendo_parametros_ordenados = (parametros) => {
  socket.on("server:s_enviando_parametros_ordenados", parametros)
};