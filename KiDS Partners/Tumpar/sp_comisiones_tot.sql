CREATE PROCEDURE KDS_COMISIONES_TOT (in fdesde date, in fhasta date) 
-- CALL KDS_COMISIONES_TOT('2023-05-01','2023-05-31') 
/*  modificaciones 
    10-07-2023 v2
*/
AS
BEGIN

SELECT
"CODE",
"VENDEDOR",
"CC",
"CONTADO",
"CREDITO",
"ANTICIPO",
"OTROS",
"NOTAS_CREDITO",
"DEVOLUCIONES_OTROS",
("CONTADO" + "CREDITO" + "ANTICIPO" + "OTROS" - "NOTAS_CREDITO" - "DEVOLUCIONES_OTROS") AS "TOTAL_USD"
FROM
(  
  
  SELECT U."SlpCode" AS "CODE", U."SlpName" AS "VENDEDOR", U."U_CentroCosto" AS "CC",
    CASE WHEN CT."Monto" > 0 THEN CT."Monto" ELSE 0 END AS "CONTADO",
    CASE WHEN CD."Monto" > 0 THEN CD."Monto" ELSE 0 END AS "CREDITO",
    CASE WHEN AN."Monto" > 0 THEN AN."Monto" ELSE 0 END AS "ANTICIPO",
    CASE WHEN OT."Monto" > 0 THEN OT."Monto" ELSE 0 END AS "OTROS",
    CASE WHEN NC."Monto" > 0 THEN NC."Monto" ELSE 0 END AS "NOTAS_CREDITO",
    CASE WHEN PR."Monto" > 0 THEN PR."Monto" ELSE 0 END AS "DEVOLUCIONES_OTROS"
  FROM OSLP U
    LEFT JOIN (
    -- PAGOS RECIBIDOS AL CONTADO AGRUPADO
    SELECT
      CASE WHEN T4."SlpName" IS NOT NULL THEN T4."SlpName" ELSE T1."U_VENDEDOR" END AS "Vendedor",
      --SUM(CASE WHEN T2."SumApplied" + T0."LocTotal" = 0 THEN T0."LocTotal" ELSE T2."SumApplied" END) AS "Monto" modificaciones v2 10-07
      SUM(CASE 
      WHEN (T2."SumApplied" + T0."LocTotal" = 0) OR (T2."SumApplied" > ABS(T0."LocTotal")) THEN T0."LocTotal" 
      WHEN (T2."SumApplied" + T0."LocTotal" <> 0) AND (T0."LocTotal" - T2."SumApplied" < 0) AND (T2."SumApplied" < ABS(T0."LocTotal")) THEN T2."SumApplied" * (-1)
      ELSE  T2."SumApplied" END) AS "Monto"--+linea modificaciones v2 10-07
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
      GROUP BY CASE WHEN T4."SlpName" IS NOT NULL THEN T4."SlpName" ELSE T1."U_VENDEDOR" END
      ) CT ON U."SlpName" = CT."Vendedor"
      LEFT JOIN (
    -- PAGOS RECIBIDOS AL CREDITO AGRUPADO
    SELECT
      CASE WHEN T4."SlpName" IS NOT NULL THEN T4."SlpName" ELSE T1."U_VENDEDOR" END AS "Vendedor",
      --SUM(CASE WHEN T2."SumApplied" + T0."LocTotal" = 0 THEN T0."LocTotal" ELSE T2."SumApplied" END) AS "Monto", --modificaciones v2 10-07
      SUM(CASE 
      WHEN (T2."SumApplied" + T0."LocTotal" = 0) OR (T2."SumApplied" > ABS(T0."LocTotal")) THEN T0."LocTotal" 
      WHEN (T2."SumApplied" + T0."LocTotal" <> 0) AND (T0."LocTotal" - T2."SumApplied" < 0) AND (T2."SumApplied" < ABS(T0."LocTotal")) THEN T2."SumApplied" * (-1)
      ELSE  T2."SumApplied" END) AS "Monto"  --+linea modificaciones v2 10-07
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
      GROUP BY CASE WHEN T4."SlpName" IS NOT NULL THEN T4."SlpName" ELSE T1."U_VENDEDOR" END
      ) CD ON U."SlpName" = CD."Vendedor"
      LEFT JOIN (
    --  PAGOS RECIBIDOS ANTICIPOS AGRUPADO


    SELECT 
      T1."U_VENDEDOR" AS "Vendedor", --+linea modificaciones v2 10-07
      --CASE WHEN T4."SlpName" IS NOT NULL THEN T4."SlpName" ELSE T1."U_VENDEDOR" END AS "Vendedor", modificaciones v2 10-07
      SUM(CASE WHEN T1."NoDocSum" + T0."LocTotal" = 0 THEN T0."LocTotal" ELSE T1."NoDocSum" END) AS "Monto"
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
      --GROUP BY CASE WHEN T4."SlpName" IS NOT NULL THEN T4."SlpName" ELSE T1."U_VENDEDOR" END
	  GROUP BY T1."U_VENDEDOR"
      ) AN ON U."SlpName" = AN."Vendedor"
      LEFT JOIN (
    -- PAGOS RECIBIDOS OTROS AGRUPADOS
    SELECT
      CASE WHEN T4."SlpName" IS NOT NULL THEN T4."SlpName" ELSE T1."U_VENDEDOR" END AS "Vendedor",
      SUM(CASE WHEN T2."SumApplied" + T0."LocTotal" = 0 THEN T0."LocTotal" ELSE T2."SumApplied" END) AS "Monto"
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
      GROUP BY CASE WHEN T4."SlpName" IS NOT NULL THEN T4."SlpName" ELSE T1."U_VENDEDOR" END
      ) OT ON U."SlpName" = OT."Vendedor"
      LEFT JOIN (
    -- PAGOS EFECTUADOS NOTAS DE CREDITO AGRUPADO
    SELECT
      CASE WHEN T4."SlpName" IS NOT NULL THEN T4."SlpName" ELSE T1."U_VENDEDOR" END AS "Vendedor",
      SUM(CASE WHEN T0."LocTotal" > 0 THEN T2."SumApplied" * (-1) ELSE T2."SumApplied" END) AS "Monto"--+linea modificaciones v2 10-07
      --SUM(CASE WHEN T2."SumApplied" + T0."LocTotal" = 0 THEN T0."LocTotal" ELSE T2."SumApplied" END) AS "Monto" modificaciones v2 10-07
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
      GROUP BY CASE WHEN T4."SlpName" IS NOT NULL THEN T4."SlpName" ELSE T1."U_VENDEDOR" END
      ) NC ON U."SlpName" = NC."Vendedor"
      LEFT JOIN (
    -- PAGOS EFECTUADOS DEV DE PAGO RECIBIDO AGRUPADO
    SELECT
      CASE WHEN T4."SlpName" IS NOT NULL THEN T4."SlpName" ELSE T1."U_VENDEDOR" END AS "Vendedor",
      SUM(CASE WHEN T2."SumApplied" + T0."LocTotal" = 0 THEN T0."LocTotal" ELSE T2."SumApplied" END) AS "Monto"
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
      GROUP BY CASE WHEN T4."SlpName" IS NOT NULL THEN T4."SlpName" ELSE T1."U_VENDEDOR" END
      ) PR ON U."SlpName" = PR."Vendedor"
)
WHERE
("CONTADO" + "CREDITO" + "ANTICIPO" + "OTROS" - "NOTAS_CREDITO" - "DEVOLUCIONES_OTROS") > 0
ORDER BY "VENDEDOR", "CC"
;
END;