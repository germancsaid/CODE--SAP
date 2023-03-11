--calculo ice especifico por linea
DECLARE Factor DECIMAL(10,3);

SELECT T0."U_ICE_BS_L" INTO Factor FROM 
"SBA_PRD"."@LB_ICE"  T0  
INNER JOIN OITM T1 ON T0."Code" = T1."U_Tipo_ICE" 
WHERE T1."ItemCode" =$[$38.1.0];

SELECT (($[INV1."Volume"]/1)*:Factor) AS TOTAL FROM DUMMY;

--calculo ice porcentual por linea trabajando con una tabla auxiliar que vincula la alicupta de los ices por tipo de articulos
DECLARE Factor DECIMAL(10,3);

SELECT T0."U_ICE_PORC" INTO Factor FROM 
"SBA_PRD"."@LB_ICE"  T0  
INNER JOIN OITM T1 ON T0."Code" = T1."U_Tipo_ICE" 
WHERE T1."ItemCode" =$[$38.1.0];

SELECT ($[$38.21.number]*:Factor) AS TOTAL FROM DUMMY;

--suma de ice esp y porc en la linea
SELECT (($[$38.112.number])+($[$38.116.number])) AS TOTAL FROM DUMMY

--tipo de ice en el gasto 3
SELECT (3) AS GASTO FROM DUMMY


--tipo de ice en el gasto 4
SELECT (3) AS GASTO FROM DUMMY


--total de ice por documento
SELECT $[OINV."TotalExpns"] AS TOTAL FROM DUMMY



/*-*-*-*-*-*-*-* VENTAS LIQUIDADAS v1.1 *-*-*-*-*-*-*/
SELECT
T1."DocDate",--fecha de factura
T1."NumAtCard" AS "N° Fact",--numero de factura
T1."U_ESTADOFC" AS "Estado",--estado de factura
T1."U_NROAUTOR",--numero de autorizacion
T1."U_NIT",--nit
T1."U_RAZSOC",--razon social
T1."U_CODCTRL",--codigo de control
T0."WhsCode" AS "Cod Almacén", --codigo de almacen
T2."WhsName", --nombre de almacen
T1."CardCode" AS "Cod Cliente", --codigo de cliente
T0."ItemCode" AS "Cod Producto", --codigo de articulo
T0."Dscription" AS "Producto", --descripcion o nombre del articulo
T0."Quantity", --cantidad vendida
T0."Volume" AS "Equivalencia en Litros", --volumen total vendido
T0."PriceAfVAT" AS "Precio facturado", --precio venta unitario = precio base + iva
T0."PriceBefDi" AS "Precio Base", --precio base
T0."GTotal" AS "Monto neto", -- precio facturado * cant
T0."VatSum" AS "Monto IVA", --total iva
T5."ESP" AS "Esp monto ICE", --ice especial
T5."PORC" AS "% monto ICE", --ice porcentual
T0."U_ICE_LINEA" AS "Monto ICE", --monto ice total ICE T0."U_ICE_LINEA"
((T0."U_ICE_LINEA")+(T0."GTotal")) AS "Monto bruto", --monto bruto = monto neto + monto ice
T4."PymntGroup" AS "Tipo de operacion", --nombre de la condicion de pago
T1."DocDueDate" AS "Fecha de vencimiento credito"--Fecha de vencimiento de la factura
FROM
INV1 T0  
INNER JOIN OINV T1 ON T0."DocEntry" = T1."DocEntry" 
INNER JOIN OWHS T2 ON T0."WhsCode" = T2."WhsCode" 
INNER JOIN OITM T3 ON T0."ItemCode" = T3."ItemCode" 
INNER JOIN OCTG T4 ON T1."GroupNum" = T4."GroupNum" 

----Este inner join transpone las columnas verticales horizontalmente
INNER JOIN (SELECT
	 T0."DocEntry",
	 T0."LineNum",
	 SUM(CASE WHEN T0."ExpnsCode" = 3 THEN T0."LineTotal" END) AS ESP,
	 SUM(CASE WHEN T0."ExpnsCode" = 4 THEN T0."LineTotal" END) AS PORC
FROM INV2 T0
GROUP BY T0."DocEntry", T0."LineNum") T5 ON T0."DocEntry" = T5."DocEntry" AND T0."LineNum" = T5."LineNum"
WHERE T1."DocDate" >= [%0] AND T1."DocDate" <= [%1]
ORDER BY T1."NumAtCard";

/*-*-*-*-*-*-*-* VENTAS LIQUIDADAS v1.2 *-*-*-*-*-*-*/
SELECT
T1."DocDate",--fecha de factura
T1."NumAtCard" AS "N° Fact",--numero de factura
T1."U_ESTADOFC" AS "Estado",--estado de factura
T1."U_NROAUTOR",--numero de autorizacion
T1."U_NIT",--nit
T1."U_RAZSOC",--razon social
T1."U_CODCTRL",--codigo de control
T0."WhsCode" AS "Cod Almacén", --codigo de almacen
T2."WhsName", --nombre de almacen
T1."CardCode" AS "Cod Cliente", --codigo de cliente
T0."ItemCode" AS "Cod Producto", --codigo de articulo
T0."Dscription" AS "Producto", --descripcion o nombre del articulo
T0."Quantity", --cantidad vendida
T0."Volume" AS "Equivalencia en Litros", --volumen total vendido
T0."PriceAfVAT" AS "Precio facturado", --precio venta unitario = precio base + iva
((T0."PriceAfVAT")-(T0."VatSum"/T0."Quantity")) AS "Precio Base", --precio base
T0."GTotal" AS "Monto neto", -- precio facturado * cant
T0."VatSum" AS "Monto IVA", --total iva
T5."ESP" AS "Esp monto ICE", --ice especial
T5."PORC" AS "% monto ICE", --ice porcentual
(T5."ESP" + T5."PORC") AS "Total ICE",
T0."U_ICE_LINEA" AS "Monto ICE", --monto ice total ICE T0."U_ICE_LINEA"
((T0."U_ICE_LINEA")+(T0."GTotal")) AS "Monto bruto", --monto bruto = monto neto + monto ice
T4."PymntGroup" AS "Tipo de operacion", --nombre de la condicion de pago
T1."DocDueDate" AS "Fecha de vencimiento credito"--Fecha de vencimiento de la factura
FROM
INV1 T0  
INNER JOIN OINV T1 ON T0."DocEntry" = T1."DocEntry" 
INNER JOIN OWHS T2 ON T0."WhsCode" = T2."WhsCode" 
INNER JOIN OITM T3 ON T0."ItemCode" = T3."ItemCode" 
INNER JOIN OCTG T4 ON T1."GroupNum" = T4."GroupNum" 
LEFT JOIN (SELECT
	 T0."DocEntry",
	 T0."LineNum",
	 SUM(CASE WHEN T0."ExpnsCode" = 3 THEN T0."LineTotal" END) AS ESP,
	 SUM(CASE WHEN T0."ExpnsCode" = 4 THEN T0."LineTotal" END) AS PORC
FROM INV2 T0
GROUP BY T0."DocEntry", T0."LineNum") T5 ON T0."DocEntry" = T5."DocEntry" AND T0."LineNum" = T5."LineNum"
WHERE T1."DocDate" >= [%0] AND T1."DocDate" <= [%1] AND T1."U_ESTADOFC" = 'V'
ORDER BY CAST(T1."NumAtCard" AS INT) ASC;

/*Busqueda formateada para los calculos automaticos del ICE desde una tabla creada con los valores de
las alicuotas*/

--declaras una funcion decimal con la cantidad de digitos (10) y decimales (3)
DECLARE Factor DECIMAL(10,3);

SELECT T0."U_ICE_BS_L" INTO Factor FROM
"SBA_PRD"."@LB_ICE" T0
INNER JOIN OITM T1 ON T0."Code" = T1."U_Tipo_ICE"
WHERE T1."ItemCode" =$[$38.1.0];
--llamar a un dato del propio documento llenado
SELECT (($[INV1."Volume"]/1000)*:Factor) AS TOTAL FROM DUMMY;
