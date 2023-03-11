SELECT
T1."DocNum",--numero de serie
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
T4."PymntGroup" AS "Tipo de operacion", --nombre de la condicion de pago
T1."DocDueDate" AS "Fecha de vencimiento credito"--Fecha de vencimiento de la factura
FROM
INV1 T0  
INNER JOIN OINV T1 ON T0."DocEntry" = T1."DocEntry" 
INNER JOIN OWHS T2 ON T0."WhsCode" = T2."WhsCode" 
INNER JOIN OITM T3 ON T0."ItemCode" = T3."ItemCode" 
INNER JOIN OCTG T4 ON T1."GroupNum" = T4."GroupNum" 
WHERE T1."DocDate" >= [%0] AND T1."DocDate" <= [%1]
ORDER BY T1."NumAtCard";
