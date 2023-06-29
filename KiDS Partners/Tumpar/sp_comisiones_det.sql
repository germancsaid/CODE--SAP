CREATE PROCEDURE AAA_COMISIONES_DET (in fdesde date, in fhasta date, in vendedor varchar(100))
AS
BEGIN

SELECT
"Fecha",
"Pago",
"Tipo",
"Vendedor",
"Monto"
FROM
(  
    -- PAGOS RECIBIDOS AL CONTADO DETALLADO
    SELECT
      T1."DocDate" AS "Fecha", T1."DocNum" AS "Pago", 'Contado' AS "Tipo",
      CASE WHEN T4."SlpName" IS NOT NULL THEN T4."SlpName" ELSE T1."U_VENDEDOR" END AS "Vendedor",
      CASE WHEN T2."SumApplied" + T0."LocTotal" = 0 THEN T0."LocTotal" ELSE T2."SumApplied" END AS "Monto"
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
      T1."DocDate" AS "Fecha", T1."DocNum" AS "Pago", 'Credito' AS "Tipo",
      CASE WHEN T4."SlpName" IS NOT NULL THEN T4."SlpName" ELSE T1."U_VENDEDOR" END AS "Vendedor",
      CASE WHEN T2."SumApplied" + T0."LocTotal" = 0 THEN T0."LocTotal" ELSE T2."SumApplied" END AS "Monto"
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
      T1."DocDate" AS "Fecha", T1."DocNum" AS "Pago", 'Anticipo' AS "Tipo",
      CASE WHEN T4."SlpName" IS NOT NULL THEN T4."SlpName" ELSE T1."U_VENDEDOR" END AS "Vendedor",
      CASE WHEN T1."NoDocSum" + T0."LocTotal" = 0 THEN T0."LocTotal" ELSE T1."NoDocSum" END AS "Monto"
      FROM OJDT T0 
      LEFT JOIN ORCT T1 ON T0."BaseRef" = T1."DocNum"
      LEFT JOIN RCT2 T2 ON T1."DocEntry" = T2."DocNum"
      LEFT JOIN OINV T3 ON T2."DocEntry" = T3."DocEntry"
      LEFT JOIN OSLP T4 ON T3."SlpCode" = T4."SlpCode" 
      WHERE T0."TransType"  = '24' AND
      T0."RefDate" >= fdesde AND 
      T0."RefDate" <= fhasta AND
      (T3."DocDate" >= '2019-01-01' OR T3."DocDate" IS NULL OR T3."DocDate" = '') AND
      T1."PayNoDoc" = 'Y'
      
      UNION ALL
      
    -- PAGOS RECIBIDOS OTROS DETALLADO
    SELECT
      T1."DocDate" AS "Fecha", T1."DocNum" AS "Pago", 'Otros' AS "Tipo",
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
      T1."DocDate" AS "Fecha", T1."DocNum" AS "Pago", 'Nota de credito' AS "Tipo",
      CASE WHEN T4."SlpName" IS NOT NULL THEN T4."SlpName" ELSE T1."U_VENDEDOR" END AS "Vendedor",
      CASE WHEN T2."SumApplied" + T0."LocTotal" = 0 THEN T0."LocTotal" ELSE -1 * T2."SumApplied" END AS "Monto"
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
      T1."DocDate" AS "Fecha", T1."DocNum" AS "Pago", 'Devolucion Otros' AS "Tipo",
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
WHERE "Vendedor" = vendedor
ORDER BY "Fecha", "Vendedor"

;
END;