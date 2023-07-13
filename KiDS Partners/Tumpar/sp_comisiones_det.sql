ALTER PROCEDURE KDS_COMISIONES_DET (in fdesde date, in fhasta date, in vendedor varchar(100))
-- CALL KDS_COMISIONES_DET('2023-05-01','2023-05-31','CASTRO CUELLAR JOANA') 
/*  modificaciones 
    10-07-2023 v2
*/
AS
BEGIN

SELECT
TO_DATE(TO_NVARCHAR("Fecha Contable", 'YYYY-MM-DD')) AS "Fecha Contable",--+linea modificaciones v2 10-07
"Numero de Asiento",--+linea modificaciones v2 10-07
TO_DATE(TO_NVARCHAR("Fecha de Documento", 'YYYY-MM-DD')) AS "Fecha de Documento",--+linea modificaciones v2 10-07
"Numero de Documento",--+linea modificaciones v2 10-07
"Tipo de Documento", --+linea modificaciones v2 10-07
"Codigo Cliente",--+linea modificaciones v2 10-07
"Nombre Cliente",--+linea modificaciones v2 10-07
"Vendedor",
TO_DATE(TO_NVARCHAR("Fecha de Pago", 'YYYY-MM-DD')) AS "Fecha de Pago",--+linea modificaciones v2 10-07
"Numero de Pago",--+linea modificaciones v2 10-07
"Monto",--+linea modificaciones v2 10-07
"Tipo",--+linea modificaciones v2 10-07
"Comentario",--+linea modificaciones v2 10-07
"Bono Extra Stock"--+linea modificaciones v2 10-07

FROM
(  
    -- PAGOS RECIBIDOS AL CONTADO DETALLADO
    SELECT
      T0."RefDate" AS "Fecha Contable",
      T0."Number" AS "Numero de Asiento",
      T1."DocDate" AS "Fecha de Pago", T1."DocNum" AS "Numero de Pago",
      T3."DocDate" AS "Fecha de Documento",
      T3."DocNum" AS "Numero de Documento",
      T3."CardCode" AS "Codigo Cliente",
      T3."CardName" AS "Nombre Cliente",
	    CASE WHEN T1."Comments" IS NULL THEN T1."JrnlMemo" ELSE T1."Comments" END AS "Comentario",
      CASE WHEN T2."InvType" = '13' THEN 'Factura' ELSE '' END AS "Tipo de Documento",
      'Contado' AS "Tipo",
      0 AS "Bono Extra Stock",
      CASE WHEN T4."SlpName" IS NOT NULL THEN T4."SlpName" ELSE T1."U_VENDEDOR" END AS "Vendedor",
      --CASE WHEN T2."SumApplied" + T0."LocTotal" = 0 THEN T0."LocTotal" ELSE T2."SumApplied" END AS "Monto", modificaciones v2 10-07
      CASE 
      WHEN (T2."SumApplied" + T0."LocTotal" = 0) OR (T2."SumApplied" > ABS(T0."LocTotal")) THEN T0."LocTotal" 
      WHEN (T2."SumApplied" + T0."LocTotal" <> 0) AND (T0."LocTotal" - T2."SumApplied" < 0) AND (T2."SumApplied" < ABS(T0."LocTotal")) THEN T2."SumApplied" * (-1)
      ELSE  T2."SumApplied" END AS "Monto" --+linea modificaciones v2 10-07
      FROM OJDT T0 
      LEFT JOIN ORCT T1 ON T0."BaseRef" = T1."DocNum"
      LEFT JOIN RCT2 T2 ON T1."DocEntry" = T2."DocNum"
      LEFT JOIN OINV T3 ON T2."DocEntry" = T3."DocEntry"
      LEFT JOIN OSLP T4 ON T3."SlpCode" = T4."SlpCode" 
      WHERE 
      T0."TransType"  = '24' AND
      T2."InvType"  = '13' AND
      T0."RefDate" >= fdesde AND 
      T0."RefDate" <= fhasta AND
      (T3."DocDate" >= '2019-01-01' OR T3."DocDate" IS NULL OR T3."DocDate" = '') AND
      T3."DocDate" = T1."DocDate"
      
      UNION ALL

    -- PAGOS RECIBIDOS AL CREDITO DETALLADO
    SELECT
      T0."RefDate" AS "Fecha Contable",
      T0."Number" AS "Numero de Asiento",
      T1."DocDate" AS "Fecha de Pago", T1."DocNum" AS "Numero de Pago",
      T3."DocDate" AS "Fecha de Documento",
      T3."DocNum" AS "Numero de Documento",
      T3."CardCode" AS "Codigo Cliente",
      T3."CardName" AS "Nombre Cliente",
	    CASE WHEN T1."Comments" IS NULL THEN T1."JrnlMemo" ELSE T1."Comments" END AS "Comentario",
      CASE WHEN T2."InvType" = '13' THEN 'Factura' ELSE '' END AS "Tipo de Documento",
      'Credito' AS "Tipo",
      0 AS "Bono Extra Stock",
      CASE WHEN T4."SlpName" IS NOT NULL THEN T4."SlpName" ELSE T1."U_VENDEDOR" END AS "Vendedor",
      --CASE WHEN T2."SumApplied" + T0."LocTotal" = 0 THEN T0."LocTotal" ELSE T2."SumApplied" END AS "Monto", --modificaciones v2 10-07
      CASE 
      WHEN (T2."SumApplied" + T0."LocTotal" = 0) OR (T2."SumApplied" > ABS(T0."LocTotal")) THEN T0."LocTotal" 
      WHEN (T2."SumApplied" + T0."LocTotal" <> 0) AND (T0."LocTotal" - T2."SumApplied" < 0) AND (T2."SumApplied" < ABS(T0."LocTotal")) THEN T2."SumApplied" * (-1)
      ELSE  T2."SumApplied" END AS "Monto" --+linea modificaciones v2 10-07
      FROM OJDT T0 
      LEFT JOIN ORCT T1 ON T0."BaseRef" = T1."DocNum"
      LEFT JOIN RCT2 T2 ON T1."DocEntry" = T2."DocNum"
      LEFT JOIN OINV T3 ON T2."DocEntry" = T3."DocEntry"
      LEFT JOIN OSLP T4 ON T3."SlpCode" = T4."SlpCode" 
      WHERE 
      T0."TransType"  = '24' AND
      T2."InvType"  = '13' AND
      T0."RefDate" >= fdesde AND 
      T0."RefDate" <= fhasta AND
      (T3."DocDate" >= '2019-01-01' OR T3."DocDate" IS NULL OR T3."DocDate" = '') AND
      T3."DocDate" <> T1."DocDate"
      
      UNION ALL
      
    --  PAGOS RECIBIDOS ANTICIPOS DETALLADO
    SELECT
      T0."RefDate" AS "Fecha Contable",
      T0."Number" AS "Numero de Asiento",
      T1."DocDate" AS "Fecha de Pago", T1."DocNum" AS "Numero de Pago",
      '1900-01-01' AS "Fecha de Documento",
      0 AS "Numero de Documento",
      '' AS "Codigo Cliente",
      '' AS "Nombre Cliente",
	    CASE WHEN T1."Comments" IS NULL THEN T1."JrnlMemo" ELSE T1."Comments" END AS "Comentario",
      'Pago Anticipo' AS "Tipo de Documento",
      'Anticipo' AS "Tipo",
      0 AS "Bono Extra Stock",
      T1."U_VENDEDOR" AS "Vendedor", --+linea modificaciones v2 10-07
      --CASE WHEN T4."SlpName" IS NOT NULL THEN T4."SlpName" ELSE T1."U_VENDEDOR" END AS "Vendedor", modificaciones v2 10-07
      CASE WHEN T1."NoDocSum" + T0."LocTotal" = 0 THEN T0."LocTotal" ELSE T1."NoDocSum" END AS "Monto"
      FROM OJDT T0 
      LEFT JOIN ORCT T1 ON T0."BaseRef" = T1."DocNum"
      --LEFT JOIN RCT2 T2 ON T1."DocEntry" = T2."DocNum" modificaciones v2 10-07
      --LEFT JOIN OINV T3 ON T2."DocEntry" = T3."DocEntry" modificaciones v2 10-07
      --LEFT JOIN OSLP T4 ON T3."SlpCode" = T4."SlpCode"  modificaciones v2 10-07
      WHERE T0."TransType"  = '24' AND
      T0."RefDate" >= fdesde AND 
      T0."RefDate" <= fhasta AND
      --(T3."DocDate" >= '2019-01-01' OR T3."DocDate" IS NULL OR T3."DocDate" = '') AND modificaciones v2 10-07
      T1."PayNoDoc" = 'Y'
      
      UNION ALL
      
    -- PAGOS RECIBIDOS OTROS DETALLADO
    SELECT
      T0."RefDate" AS "Fecha Contable",
      T0."Number" AS "Numero de Asiento",
      T1."DocDate" AS "Fecha de Pago", T1."DocNum" AS "Numero de Pago",
      '1900-01-01' AS "Fecha de Documento",
      0 AS "Numero de Documento",
      T3."CardCode" AS "Codigo Cliente",
      T3."CardName" AS "Nombre Cliente",
	    CASE WHEN T1."Comments" IS NULL THEN T1."JrnlMemo" ELSE T1."Comments" END AS "Comentario",
      CASE WHEN T2."InvType" = '30' THEN 'Asiento' ELSE '' END AS "Tipo de Documento",
      'Reconciliacion' AS "Tipo",
      0 AS "Bono Extra Stock",
      CASE WHEN T4."SlpName" IS NOT NULL THEN T4."SlpName" ELSE T1."U_VENDEDOR" END AS "Vendedor",
      CASE WHEN T2."SumApplied" + T0."LocTotal" = 0 THEN T0."LocTotal" ELSE T2."SumApplied" END AS "Monto"
      FROM OJDT T0 
      LEFT JOIN ORCT T1 ON T0."BaseRef" = T1."DocNum"
      LEFT JOIN RCT2 T2 ON T1."DocEntry" = T2."DocNum"
      LEFT JOIN OINV T3 ON T2."DocEntry" = T3."DocEntry"
      LEFT JOIN OSLP T4 ON T3."SlpCode" = T4."SlpCode" 
      WHERE 
      T0."TransType"  = '24' AND
      T2."InvType"  = '30' AND
      T0."RefDate" >= fdesde AND 
      T0."RefDate" <= fhasta AND
      (T3."DocDate" >= '2019-01-01' OR T3."DocDate" IS NULL OR T3."DocDate" = '')

      UNION ALL
      
    -- PAGOS EFECTUADOS NOTAS DE CREDITO DETALLADOS
    SELECT
      T0."RefDate" AS "Fecha Contable",
      T0."Number" AS "Numero de Asiento",
      T1."DocDate" AS "Fecha de Pago", T1."DocNum" AS "Numero de Pago",
      T3."DocDate" AS "Fecha de Documento",
      T3."DocNum" AS "Numero de Documento",
      T3."CardCode" AS "Codigo Cliente",
      T3."CardName" AS "Nombre Cliente",
	    CASE WHEN T1."Comments" IS NULL THEN T1."JrnlMemo" ELSE T1."Comments" END AS "Comentario",
      CASE WHEN T2."InvType" = '14' THEN 'Nota de Credito' ELSE '' END AS "Tipo de Documento",
      'Devolucion' AS "Tipo",
      0 AS "Bono Extra Stock",
      CASE WHEN T4."SlpName" IS NOT NULL THEN T4."SlpName" ELSE T1."U_VENDEDOR" END AS "Vendedor",
      CASE WHEN T0."LocTotal" > 0 THEN T2."SumApplied" * (-1) ELSE T2."SumApplied" END AS "Monto" --+linea modificaciones v2 10-07
      --CASE WHEN T2."SumApplied" + T0."LocTotal" = 0 THEN T0."LocTotal" ELSE -1 * T2."SumApplied" END AS "Monto" modificaciones v2 10-07
      FROM OJDT T0 
      LEFT JOIN OVPM T1 ON T0."BaseRef" = T1."DocNum"
      LEFT JOIN VPM2 T2 ON T1."DocEntry" = T2."DocNum"
      LEFT JOIN ORIN T3 ON T2."DocEntry" = T3."DocEntry"
      LEFT JOIN OSLP T4 ON T3."SlpCode" = T4."SlpCode" 
      WHERE 
      T0."TransType"  = '46' AND
      T2."InvType"  = '14' AND
      T0."RefDate" >= fdesde AND 
      T0."RefDate" <= fhasta AND
      (T3."DocDate" >= '2019-01-01' OR T3."DocDate" IS NULL OR T3."DocDate" = '')
      
      UNION ALL
      
    -- PAGOS EFECTUADOS DEV DE PAGO RECIBIDO DETALLADOS
    SELECT
      T0."RefDate" AS "Fecha Contable",
      T0."Number" AS "Numero de Asiento",
      T1."DocDate" AS "Fecha de Pago", T1."DocNum" AS "Numero de Pago", 
      '1900-01-01' AS "Fecha de Documento",
      0 AS "Numero de Documento",
      T3."CardCode" AS "Codigo Cliente",
      T3."CardName" AS "Nombre Cliente",
	    CASE WHEN T1."Comments" IS NULL THEN T1."JrnlMemo" ELSE T1."Comments" END AS "Comentario",
      CASE WHEN T2."InvType" = '24' THEN 'Pago Recibido' ELSE '' END AS "Tipo de Documento",
      'Devolucion' AS "Tipo",
      0 AS "Bono Extra Stock",
      CASE WHEN T4."SlpName" IS NOT NULL THEN T4."SlpName" ELSE T1."U_VENDEDOR" END AS "Vendedor",
      CASE WHEN T2."SumApplied" + T0."LocTotal" = 0 THEN T0."LocTotal" ELSE -1 * T2."SumApplied" END AS "Monto"
      FROM OJDT T0 
      LEFT JOIN OVPM T1 ON T0."BaseRef" = T1."DocNum"
      LEFT JOIN VPM2 T2 ON T1."DocEntry" = T2."DocNum"
      LEFT JOIN ORIN T3 ON T2."DocEntry" = T3."DocEntry"
      LEFT JOIN OSLP T4 ON T3."SlpCode" = T4."SlpCode" 
      WHERE 
      T0."TransType"  = '46' AND
      T2."InvType"  = '24' AND
      T0."RefDate" >= fdesde AND 
      T0."RefDate" <= fhasta AND
      (T3."DocDate" >= '2019-01-01' OR T3."DocDate" IS NULL OR T3."DocDate" = '')
)
WHERE vendedor IS NULL OR vendedor = '' OR "Vendedor" = vendedor
ORDER BY "Fecha de Pago", "Vendedor"

;
END;