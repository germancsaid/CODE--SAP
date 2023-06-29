import hana from "@sap/hana-client";
import _ from "lodash";
import parametro from "./models/parametro";

/**
 * *SOCKET CONNECTION
 */
export default (io) => {
  io.on("connection", (socket) => {
    // Conexion del socket y session.
    const session = socket.request.session;
    session.socketId = socket.id;
    session.save();
    //const player_id = session.passport.user;

    let ParametrosData = [];

    /**
     * *LEER INFORMACION DE MONGO DB
     */
    const s_query_find_parametros = async () => {
      const parametros_find = await parametro.find(
        {},
        {
          Parametro: 1,
          Rango: 1,
          Sucursal: 1,
          Tipo: 1,
        }
      );

      let LineNum = 0;
      let tasa = 0;
      let monto = 0;
      // ORDENDANDO PARAMETROS PARA PRESENTARLOS EN HOJA POLITICAS
      const parametros_ordenados = [];
      parametros_find.forEach((parametro) => {
        parametro.Rango.forEach((parametroRango) => {
          if (!parametroRango.tasa) {
            tasa = 0;
          } else {
            tasa = parametroRango.tasa;
          }
          if (!parametroRango.monto) {
            monto = 0;
          } else {
            monto = parametroRango.monto;
          }

          const lineaParametros = {
            lineNum: LineNum + 1,
            parametro: parametro.Parametro,
            min: parametroRango.min,
            max: parametroRango.max,
            tasa: tasa,
            monto: monto,
          };
          parametros_ordenados.push(lineaParametros);
          LineNum = LineNum + 1;
        });
      });
      ParametrosData = parametros_find;
      io.emit("server:s_enviando_parametros_ordenados", parametros_ordenados);
    };
    s_query_find_parametros();

    /**
     * *CONEXION HANA
    */
    var conn = hana.createConnection();
    var conn_params = {
      serverNode: '10.60.10.5:30015',
      uID: 'B1ADMIN',
      pwd: 'B1Admin1$'
    };

    conn.connect(conn_params, function (err) {
      if (err) {
        console.error('Error al conectar con la base HANA: ', err);
        console.error('API MONGO CONECTADO');
        
        /**
        * *ENVIO DE INFORMACION DESDE API
        */
        let bug = 0

        bug = bug + 1
       console.error(bug);

        fetch("http://localhost:8082/b1s/v1/TablaU", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
        })
          .then((response) => response.json())
          .then((TablaU) => {
            bug = bug + 1
            console.error(bug);
            
            let TablaOSLP = TablaU;
            
            //==================================================================
            
            bug = bug + 1
            console.error(bug);
            const uniqueSlpCC = _.uniq(TablaOSLP.map((item) => item.U_CentroCosto));
            const centroCostoArray = uniqueSlpCC.map((U_CentroCosto) => ({
              CC: U_CentroCosto,
            }));
            const centroCostoArraySinNull = centroCostoArray.filter(
              (item) => item.CC !== null
            );
            io.emit("server:s_enviando_cc", centroCostoArraySinNull);

            //==================================================================
            bug = bug + 1
            console.error(bug);
            const uniqueSlpName = _.uniq(TablaOSLP.map((item) => item.SlpName));
            const SlpNameArray = uniqueSlpName.map((SlpName) => ({
              SlpName: SlpName,
            }));
            const SlpNameArraySinNull = SlpNameArray.filter(
              (item) => item.SlpName !== null
            );
            io.emit("server:s_enviando_vendedores", SlpNameArraySinNull);
            bug = bug + 1
            console.error(bug);
            //==================================================================

            socket.on("client:c_enviando_parametros_de_calculo", async (dat3) => {

              let desde = dat3.FechaInicial;
              let hasta = dat3.FechaFinal;

              fetch("http://localhost:8082/b1s/v1/TablaTOT", {
                method: "POST",
                headers: {
                  "Content-Type": "application/json",
                },
              })
                .then((response) => response.json())
                .then((TablaTOT) => {

                  let totales = TablaTOT;

                  //==================================================================

                  if (dat3.VistaList === "Resumen") {

                    var ParametrosFiltrados = ParametrosData.filter(function (obj) {
                      return obj.Tipo === "Jefe";
                    });
                    var gruposCC = {};
                    for (var i = 0; i < totales.length; i++) {
                      var item = totales[i];
                      var cc = item.CC;
                      var totalUSD = parseFloat(item.TOTAL_USD);

                      if (!gruposCC[cc]) {
                        gruposCC[cc] = {
                          CC: cc,
                          TOTAL_USD: totalUSD,
                        };
                      } else {
                        gruposCC[cc].TOTAL_USD += totalUSD;
                      }
                    }
                    var resultado = Object.values(gruposCC);

                    totales = resultado;

                    _.forEach(totales, (objTotales) => {
                      // Encontrar el objeto en "comisiones" que cumple la condición
                      const objComisiones = _.find(ParametrosFiltrados, {
                        Sucursal: objTotales.CC,
                      });
                      // Verificar si se encontró un objeto en "comisiones" que cumple la condición
                      if (objComisiones) {
                        _.forEach(objComisiones.Rango, (objRango) => {
                          if (
                            objTotales.TOTAL_USD >= objRango.min &&
                            objTotales.TOTAL_USD < objRango.max
                          ) {
                            objTotales.Comision =
                              objTotales.TOTAL_USD * objRango.tasa;
                          }
                        });
                      } else {
                        objTotales.Comision = 0; // Asignar 0 al campo Comision si no se encontró objeto en ParametrosFiltrados
                      }
                    });
                    let totalesConComision = totales;

                    if (!dat3.Sucursal || dat3.Sucursal === "") {
                      io.emit(
                        "server:s_enviando_totales_resumen",
                        totalesConComision
                      );
                    } else {
                      const tablaTotalesResumen = totalesConComision.filter(
                        (item) => item.CC === dat3.Sucursal
                      );
                      io.emit(
                        "server:s_enviando_totales_resumen",
                        tablaTotalesResumen
                      );
                      console.log(tablaTotalesResumen);
                    }
                  } else {
                    var ParametrosFiltrados = ParametrosData.filter(function (obj) {
                      return obj.Tipo === "Vendedor";
                    });

                    _.forEach(totales, (objTotales) => {
                      // Encontrar el objeto en "comisiones" que cumple la condición
                      const objComisiones = _.find(ParametrosFiltrados, {
                        Sucursal: objTotales.CC,
                      });
                      // Verificar si se encontró un objeto en "comisiones" que cumple la condición
                      if (objComisiones) {
                        _.forEach(objComisiones.Rango, (objRango) => {
                          if (
                            objTotales.TOTAL_USD >= objRango.min &&
                            objTotales.TOTAL_USD < objRango.max
                          ) {
                            objTotales.Comision =
                              objTotales.TOTAL_USD * objRango.tasa;
                          }
                        });
                      } else {
                        objTotales.Comision = 0; // Asignar 0 al campo Comision si no se encontró objeto en ParametrosFiltrados
                      }
                    });
                    let totalesConComision = totales;

                    if (
                      (!dat3.Sucursal || dat3.Sucursal === "") &&
                      (!dat3.Vendedor || dat3.Vendedor === "")
                    ) {
                      io.emit("server:s_enviando_totales", totalesConComision);
                    } else if (!dat3.Sucursal || dat3.Sucursal === "") {
                      const tablaTotalesResumen = totalesConComision.filter(
                        (item) => item.VENDEDOR === dat3.Vendedor
                      );
                      io.emit("server:s_enviando_totales", tablaTotalesResumen);
                    } else if (!dat3.Vendedor || dat3.Vendedor === "") {
                      const tablaTotalesResumen = totalesConComision.filter(
                        (item) => item.CC === dat3.Sucursal
                      );
                      io.emit("server:s_enviando_totales", tablaTotalesResumen);
                    } else {
                      const tablaTotalesResumen = totalesConComision.filter(
                        (item) =>
                          item.CC === dat3.Sucursal &&
                          item.VENDEDOR === dat3.Vendedor
                      );

                      io.emit("server:s_enviando_totales", tablaTotalesResumen);
                    }
                  }
                });
            });


            socket.on("client:c_enviando_parametros_para_detalle", async (dat3) => {
              let desde = '2019-01-01';
              let hasta = '2023-01-01';
              let vendedor = '';

              desde = dat3.FechaInicial;
              hasta = dat3.FechaFinal;
              vendedor = dat3.Vendedor

              fetch("http://localhost:8082/b1s/v1/TablaDET", {
                method: "POST",
                headers: {
                  "Content-Type": "application/json",
                },
              })
                .then((response) => response.json())
                .then((TablaDET) => {
  
                if (err) throw err;
                const detalle = TablaDET;
                const tablaDetalleVendedor = detalle.filter(
                  (item) =>
                    item.Vendedor === vendedor
                );
                io.emit("server:s_enviando_detalle", tablaDetalleVendedor);
              });
            });
          });

      } else {
        /**
        * *ENVIO DE INFORMACION DESDE HANA
        */
        console.log('Consulta efectuada a base HANA');
        conn.exec('SELECT "SlpCode", "SlpName", "U_CentroCosto" FROM "TUMPAR_PRD"."OSLP" ORDER BY "SlpName"',
          function (err, result) {
            if (err) throw err;
            let TablaOSLP = result;


            const uniqueSlpCC = _.uniq(TablaOSLP.map((item) => item.U_CentroCosto));
            const centroCostoArray = uniqueSlpCC.map((U_CentroCosto) => ({
              CC: U_CentroCosto,
            }));
            const centroCostoArraySinNull = centroCostoArray.filter(
              (item) => item.CC !== null
            );
            io.emit("server:s_enviando_cc", centroCostoArraySinNull);

            const uniqueSlpName = _.uniq(TablaOSLP.map((item) => item.SlpName));
            const SlpNameArray = uniqueSlpName.map((SlpName) => ({
              SlpName: SlpName,
            }));
            const SlpNameArraySinNull = SlpNameArray.filter(
              (item) => item.SlpName !== null
            );

            io.emit("server:s_enviando_vendedores", SlpNameArraySinNull);



            socket.on("client:c_enviando_parametros_para_detalle", async (dat3) => {
              let desde = '2019-01-01';
              let hasta = '2023-01-01';
              let vendedor = '';

              desde = dat3.FechaInicial;
              hasta = dat3.FechaFinal;
              vendedor = dat3.Vendedor

              conn.exec(`CALL "TUMPAR_PRD"."AAA_COMISIONES_DET"('${desde}', '${hasta}', '${vendedor}')`, function (err, result) {
                if (err) throw err;
                const detalle = result;
                const tablaDetalleVendedor = detalle.filter(
                  (item) =>
                    item.Vendedor === vendedor
                );
                io.emit("server:s_enviando_detalle", tablaDetalleVendedor);
              });
            });

            socket.on("client:c_enviando_parametros_de_calculo", async (dat3) => {
              let desde = '2019-01-01';
              let hasta = '2023-01-01';

              desde = dat3.FechaInicial;
              hasta = dat3.FechaFinal;

              conn.exec(`CALL "TUMPAR_PRD"."AAA_COMISIONES_TOT"('${desde}', '${hasta}')`, function (err, result) {
                if (err) throw err;
                let totales = result;

                if (dat3.VistaList === "Resumen") {
                  var ParametrosFiltrados = ParametrosData.filter(function (obj) {
                    return obj.Tipo === "Jefe";
                  });

                  var objetoCCyTotalUSD = totales.map(function (item) {
                    return {
                      CC: item.CC,
                      TOTAL_USD: item.TOTAL_USD,
                    };
                  });

                  var gruposCC = {};

                  for (var i = 0; i < totales.length; i++) {
                    var item = totales[i];
                    var cc = item.CC;
                    var totalUSD = parseFloat(item.TOTAL_USD);

                    if (!gruposCC[cc]) {
                      gruposCC[cc] = {
                        CC: cc,
                        TOTAL_USD: totalUSD,
                      };
                    } else {
                      gruposCC[cc].TOTAL_USD += totalUSD;
                    }
                  }

                  var resultado = Object.values(gruposCC);

                  totales = resultado;
                  _.forEach(totales, (objTotales) => {
                    // Encontrar el objeto en "comisiones" que cumple la condición
                    const objComisiones = _.find(ParametrosFiltrados, {
                      Sucursal: objTotales.CC,
                    });
                    // Verificar si se encontró un objeto en "comisiones" que cumple la condición
                    if (objComisiones) {
                      _.forEach(objComisiones.Rango, (objRango) => {
                        if (
                          objTotales.TOTAL_USD >= objRango.min &&
                          objTotales.TOTAL_USD < objRango.max
                        ) {
                          objTotales.Comision =
                            objTotales.TOTAL_USD * objRango.tasa;
                        }
                      });
                    } else {
                      objTotales.Comision = 0; // Asignar 0 al campo Comision si no se encontró objeto en ParametrosFiltrados
                    }
                  });
                  let totalesConComision = totales;

                  if (!dat3.Sucursal || dat3.Sucursal === "") {
                    io.emit(
                      "server:s_enviando_totales_resumen",
                      totalesConComision
                    );
                  } else {
                    const tablaTotalesResumen = totalesConComision.filter(
                      (item) => item.CC === dat3.Sucursal
                    );
                    io.emit(
                      "server:s_enviando_totales_resumen",
                      tablaTotalesResumen
                    );
                    console.log(tablaTotalesResumen);
                  }
                } else {
                  var ParametrosFiltrados = ParametrosData.filter(function (obj) {
                    return obj.Tipo === "Vendedor";
                  });

                  _.forEach(totales, (objTotales) => {
                    // Encontrar el objeto en "comisiones" que cumple la condición
                    const objComisiones = _.find(ParametrosFiltrados, {
                      Sucursal: objTotales.CC,
                    });
                    // Verificar si se encontró un objeto en "comisiones" que cumple la condición
                    if (objComisiones) {
                      _.forEach(objComisiones.Rango, (objRango) => {
                        if (
                          objTotales.TOTAL_USD >= objRango.min &&
                          objTotales.TOTAL_USD < objRango.max
                        ) {
                          objTotales.Comision =
                            objTotales.TOTAL_USD * objRango.tasa;
                        }
                      });
                    } else {
                      objTotales.Comision = 0; // Asignar 0 al campo Comision si no se encontró objeto en ParametrosFiltrados
                    }
                  });
                  let totalesConComision = totales;

                  if (
                    (!dat3.Sucursal || dat3.Sucursal === "") &&
                    (!dat3.Vendedor || dat3.Vendedor === "")
                  ) {
                    io.emit("server:s_enviando_totales", totalesConComision);
                  } else if (!dat3.Sucursal || dat3.Sucursal === "") {
                    const tablaTotalesResumen = totalesConComision.filter(
                      (item) => item.VENDEDOR === dat3.Vendedor
                    );
                    io.emit("server:s_enviando_totales", tablaTotalesResumen);
                  } else if (!dat3.Vendedor || dat3.Vendedor === "") {
                    const tablaTotalesResumen = totalesConComision.filter(
                      (item) => item.CC === dat3.Sucursal
                    );
                    io.emit("server:s_enviando_totales", tablaTotalesResumen);
                  } else {
                    const tablaTotalesResumen = totalesConComision.filter(
                      (item) =>
                        item.CC === dat3.Sucursal &&
                        item.VENDEDOR === dat3.Vendedor
                    );

                    io.emit("server:s_enviando_totales", tablaTotalesResumen);
                  }
                }
              });

            });

          });//select
      };//if
    });
    conn.disconnect();
  });
};
