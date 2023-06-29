ALTER PROCEDURE ACB_FIN_REG_EVOLUCION_DE_PATRIMONIO (in fdesde date, in fhasta date)
AS
BEGIN
-- GTP: EVOLUCION DE PATRIMONIO 2023
-- CALL ACB_FIN_REG_EVOLUCION_DE_PATRIMONIO('2023-01-01','2023-01-31')
--  Saldos desde el 1° de enero de 2022
SELECT
'' AS "#",
'Saldo al ' || TO_NVARCHAR(TO_DATE(fdesde, 'YYYY-MM-DD'), 'DD "de" Month "de" YYYY') AS "DESCRIPCION DE MOVIMIENTOS",
  SUM(CASE WHEN T1."AccountGroup" = '30101' THEN T1."Total" ELSE 0 END) AS "301.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30201' THEN T1."Total" ELSE 0 END) AS "302.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30202' THEN T1."Total" ELSE 0 END) AS "302.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30203' THEN T1."Total" ELSE 0 END) AS "302.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30204' THEN T1."Total" ELSE 0 END) AS "302.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30301' THEN T1."Total" ELSE 0 END) AS "303.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30302' THEN T1."Total" ELSE 0 END) AS "303.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30303' THEN T1."Total" ELSE 0 END) AS "303.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30304' THEN T1."Total" ELSE 0 END) AS "303.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30401' THEN T1."Total" ELSE 0 END) AS "304.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30501' THEN T1."Total" ELSE 0 END) AS "305.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30502' THEN T1."Total" ELSE 0 END) AS "305.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30503' THEN T1."Total" ELSE 0 END) AS "305.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30601' THEN T1."Total" ELSE 0 END) AS "306.01M",
  SUM(CASE WHEN T1."AccountGroup" = '307' THEN T1."Total" ELSE 0 END) AS "307",
  SUM(CASE WHEN T1."AccountGroup" = '308' THEN T1."Total" ELSE 0 END) AS "308",
  SUM(CASE WHEN T1."AccountGroup" = 'Total' THEN T1."Total" ELSE 0 END) AS "TOTAL PATRIMONIO"
FROM
(
  SELECT 
      COALESCE("AccountGroup", 'Total') AS "AccountGroup",
      SUM("Total") AS "Total"
  FROM (
        SELECT 
        LEFT(T1."AcctCode", 5) AS "AccountGroup",
        CASE WHEN SUM(T0."Credit" - T0."Debit") IS NULL THEN 0 ELSE SUM(T0."Credit" - T0."Debit") END AS "Total"
        FROM OACT T1
        LEFT JOIN 
        (SELECT "RefDate", "Account", "Credit", "Debit"
        FROM JDT1 WHERE "RefDate" <= ADD_DAYS(fdesde, -1)) T0
        ON T0."Account" = T1."AcctCode"
        WHERE 
        T1."Postable" = 'Y' AND
        LEFT(T1."AcctCode", 1) = '3' AND
        LEFT(T1."AcctCode", 3) NOT IN ('307', '308')
        GROUP BY LEFT(T1."AcctCode", 5)
      UNION ALL
        SELECT 
        LEFT(T1."AcctCode", 3) AS "AccountGroup",
        CASE WHEN SUM(T0."Credit" - T0."Debit") IS NULL THEN 0 ELSE SUM(T0."Credit" - T0."Debit") END AS "Total"
        FROM OACT T1
        LEFT JOIN 
        (SELECT "RefDate", "Account", "Credit", "Debit"
        FROM JDT1 WHERE "RefDate" <= ADD_DAYS(fdesde, -1)) T0
        ON T0."Account" = T1."AcctCode"
        WHERE 
        T1."Postable" = 'Y' AND
        LEFT(T1."AcctCode", 1) = '3' AND
        LEFT(T1."AcctCode", 3) IN ('307', '308')
        GROUP BY LEFT(T1."AcctCode", 3)
  ) AS subquery
  GROUP BY GROUPING SETS ("AccountGroup",())
  ORDER BY "AccountGroup" ASC

) T1
  
UNION ALL
/*
--1. 	    ACTUALIZACIÓN
SELECT
'1.' AS "#",
'ACTUALIZACIÓN' AS "DESCRIPCION DE MOVIMIENTOS",
  SUM(CASE WHEN T1."AccountGroup" = '30101' THEN T1."Total" ELSE 0 END) AS "301.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30201' THEN T1."Total" ELSE 0 END) AS "302.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30202' THEN T1."Total" ELSE 0 END) AS "302.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30203' THEN T1."Total" ELSE 0 END) AS "302.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30204' THEN T1."Total" ELSE 0 END) AS "302.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30301' THEN T1."Total" ELSE 0 END) AS "303.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30302' THEN T1."Total" ELSE 0 END) AS "303.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30303' THEN T1."Total" ELSE 0 END) AS "303.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30304' THEN T1."Total" ELSE 0 END) AS "303.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30401' THEN T1."Total" ELSE 0 END) AS "304.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30501' THEN T1."Total" ELSE 0 END) AS "305.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30502' THEN T1."Total" ELSE 0 END) AS "305.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30503' THEN T1."Total" ELSE 0 END) AS "305.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30601' THEN T1."Total" ELSE 0 END) AS "306.01M",
  SUM(CASE WHEN T1."AccountGroup" = '307' THEN T1."Total" ELSE 0 END) AS "307",
  SUM(CASE WHEN T1."AccountGroup" = '308' THEN T1."Total" ELSE 0 END) AS "308",
  SUM(CASE WHEN T1."AccountGroup" = 'Total' THEN T1."Total" ELSE 0 END) AS "TOTAL PATRIMONIO"
FROM

(
  SELECT 
      COALESCE("AccountGroup", 'Total') AS "AccountGroup",
      SUM("TotalDebit") AS "TotalDebit",
      SUM("TotalCredit") AS "TotalCredit",
      SUM("Total") AS "Total"
  FROM (
      SELECT 
          LEFT("Account", 5) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) NOT IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 2) = '1.'
      GROUP BY LEFT("Account", 5)
      UNION ALL
      SELECT 
          LEFT("Account", 3) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 2) = '1.'
      GROUP BY LEFT("Account", 3)
  ) AS subquery
  GROUP BY GROUPING SETS ("AccountGroup",())
  ORDER BY "AccountGroup" ASC

) T1
  
UNION ALL
*/
--1.1 	    Actualización al tipo de cambio de Bs……. Por UFV
SELECT
'1' AS "#",
'1.1. Actualización al tipo de cambio de Bs por UFV' AS "DESCRIPCION DE MOVIMIENTOS",
  SUM(CASE WHEN T1."AccountGroup" = '30101' THEN T1."Total" ELSE 0 END) AS "301.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30201' THEN T1."Total" ELSE 0 END) AS "302.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30202' THEN T1."Total" ELSE 0 END) AS "302.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30203' THEN T1."Total" ELSE 0 END) AS "302.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30204' THEN T1."Total" ELSE 0 END) AS "302.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30301' THEN T1."Total" ELSE 0 END) AS "303.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30302' THEN T1."Total" ELSE 0 END) AS "303.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30303' THEN T1."Total" ELSE 0 END) AS "303.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30304' THEN T1."Total" ELSE 0 END) AS "303.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30401' THEN T1."Total" ELSE 0 END) AS "304.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30501' THEN T1."Total" ELSE 0 END) AS "305.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30502' THEN T1."Total" ELSE 0 END) AS "305.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30503' THEN T1."Total" ELSE 0 END) AS "305.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30601' THEN T1."Total" ELSE 0 END) AS "306.01M",
  SUM(CASE WHEN T1."AccountGroup" = '307' THEN T1."Total" ELSE 0 END) AS "307",
  SUM(CASE WHEN T1."AccountGroup" = '308' THEN T1."Total" ELSE 0 END) AS "308",
  SUM(CASE WHEN T1."AccountGroup" = 'Total' THEN T1."Total" ELSE 0 END) AS "TOTAL PATRIMONIO"
FROM
  (
  SELECT 
      COALESCE("AccountGroup", 'Total') AS "AccountGroup",
      SUM("TotalDebit") AS "TotalDebit",
      SUM("TotalCredit") AS "TotalCredit",
      SUM("Total") AS "Total"
  FROM (
      SELECT 
          LEFT("Account", 5) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) NOT IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 2) = '1.'
      GROUP BY LEFT("Account", 5)
      UNION ALL
      SELECT 
          LEFT("Account", 3) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 2) = '1.'
      GROUP BY LEFT("Account", 3)
  ) AS subquery
  GROUP BY GROUPING SETS ("AccountGroup",())
  ORDER BY "AccountGroup" ASC
  ) T1
  
UNION ALL
/*
--2 	    MOVIMIENTOS INTERNOS
SELECT
'2.' AS "#",
'MOVIMIENTOS INTERNOS' AS "DESCRIPCION DE MOVIMIENTOS",
  SUM(CASE WHEN T1."AccountGroup" = '30101' THEN T1."Total" ELSE 0 END) AS "301.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30201' THEN T1."Total" ELSE 0 END) AS "302.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30202' THEN T1."Total" ELSE 0 END) AS "302.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30203' THEN T1."Total" ELSE 0 END) AS "302.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30204' THEN T1."Total" ELSE 0 END) AS "302.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30301' THEN T1."Total" ELSE 0 END) AS "303.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30302' THEN T1."Total" ELSE 0 END) AS "303.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30303' THEN T1."Total" ELSE 0 END) AS "303.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30304' THEN T1."Total" ELSE 0 END) AS "303.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30401' THEN T1."Total" ELSE 0 END) AS "304.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30501' THEN T1."Total" ELSE 0 END) AS "305.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30502' THEN T1."Total" ELSE 0 END) AS "305.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30503' THEN T1."Total" ELSE 0 END) AS "305.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30601' THEN T1."Total" ELSE 0 END) AS "306.01M",
  SUM(CASE WHEN T1."AccountGroup" = '307' THEN T1."Total" ELSE 0 END) AS "307",
  SUM(CASE WHEN T1."AccountGroup" = '308' THEN T1."Total" ELSE 0 END) AS "308",
  SUM(CASE WHEN T1."AccountGroup" = 'Total' THEN T1."Total" ELSE 0 END) AS "TOTAL PATRIMONIO"
FROM
  (
  SELECT 
      COALESCE("AccountGroup", 'Total') AS "AccountGroup",
      SUM("TotalDebit") AS "TotalDebit",
      SUM("TotalCredit") AS "TotalCredit",
      SUM("Total") AS "Total"
  FROM (
      SELECT 
          LEFT("Account", 5) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) NOT IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 2) = '2.'
      GROUP BY LEFT("Account", 5)
      UNION ALL
      SELECT 
          LEFT("Account", 3) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 2) = '2.'
      GROUP BY LEFT("Account", 3)
  ) AS subquery
  GROUP BY GROUPING SETS ("AccountGroup",())
  ORDER BY "AccountGroup" ASC
  ) T1
UNION ALL
  */
--2.1 	    Traspaso de la utilidad o pérdida de la gestión anterior
SELECT
'2' AS "#",
'2.1. Traspaso de la utilidad o pérdida de la gestión anterior' AS "DESCRIPCION DE MOVIMIENTOS",
  SUM(CASE WHEN T1."AccountGroup" = '30101' THEN T1."Total" ELSE 0 END) AS "301.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30201' THEN T1."Total" ELSE 0 END) AS "302.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30202' THEN T1."Total" ELSE 0 END) AS "302.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30203' THEN T1."Total" ELSE 0 END) AS "302.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30204' THEN T1."Total" ELSE 0 END) AS "302.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30301' THEN T1."Total" ELSE 0 END) AS "303.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30302' THEN T1."Total" ELSE 0 END) AS "303.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30303' THEN T1."Total" ELSE 0 END) AS "303.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30304' THEN T1."Total" ELSE 0 END) AS "303.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30401' THEN T1."Total" ELSE 0 END) AS "304.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30501' THEN T1."Total" ELSE 0 END) AS "305.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30502' THEN T1."Total" ELSE 0 END) AS "305.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30503' THEN T1."Total" ELSE 0 END) AS "305.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30601' THEN T1."Total" ELSE 0 END) AS "306.01M",
  SUM(CASE WHEN T1."AccountGroup" = '307' THEN T1."Total" ELSE 0 END) AS "307",
  SUM(CASE WHEN T1."AccountGroup" = '308' THEN T1."Total" ELSE 0 END) AS "308",
  SUM(CASE WHEN T1."AccountGroup" = 'Total' THEN T1."Total" ELSE 0 END) AS "TOTAL PATRIMONIO"
FROM
  (
  SELECT 
      COALESCE("AccountGroup", 'Total') AS "AccountGroup",
      SUM("TotalDebit") AS "TotalDebit",
      SUM("TotalCredit") AS "TotalCredit",
      SUM("Total") AS "Total"
  FROM (
      SELECT 
          LEFT("Account", 5) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) NOT IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 3) = '2.1'
      GROUP BY LEFT("Account", 5)
      UNION ALL
      SELECT 
          LEFT("Account", 3) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 3) = '2.1'
      GROUP BY LEFT("Account", 3)
  ) AS subquery
  GROUP BY GROUPING SETS ("AccountGroup",())
  ORDER BY "AccountGroup" ASC
  ) T1
  
UNION ALL
--2.2 	    Constitución de reserva legal ...% Estatutaria… % Facultativa…%
SELECT
'2' AS "#",
'2.2. Constitución de reserva legal ...% Estatutaria… % Facultativa…%' AS "DESCRIPCION DE MOVIMIENTOS",
  SUM(CASE WHEN T1."AccountGroup" = '30101' THEN T1."Total" ELSE 0 END) AS "301.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30201' THEN T1."Total" ELSE 0 END) AS "302.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30202' THEN T1."Total" ELSE 0 END) AS "302.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30203' THEN T1."Total" ELSE 0 END) AS "302.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30204' THEN T1."Total" ELSE 0 END) AS "302.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30301' THEN T1."Total" ELSE 0 END) AS "303.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30302' THEN T1."Total" ELSE 0 END) AS "303.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30303' THEN T1."Total" ELSE 0 END) AS "303.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30304' THEN T1."Total" ELSE 0 END) AS "303.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30401' THEN T1."Total" ELSE 0 END) AS "304.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30501' THEN T1."Total" ELSE 0 END) AS "305.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30502' THEN T1."Total" ELSE 0 END) AS "305.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30503' THEN T1."Total" ELSE 0 END) AS "305.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30601' THEN T1."Total" ELSE 0 END) AS "306.01M",
  SUM(CASE WHEN T1."AccountGroup" = '307' THEN T1."Total" ELSE 0 END) AS "307",
  SUM(CASE WHEN T1."AccountGroup" = '308' THEN T1."Total" ELSE 0 END) AS "308",
  SUM(CASE WHEN T1."AccountGroup" = 'Total' THEN T1."Total" ELSE 0 END) AS "TOTAL PATRIMONIO"
FROM
  (
  SELECT 
      COALESCE("AccountGroup", 'Total') AS "AccountGroup",
      SUM("TotalDebit") AS "TotalDebit",
      SUM("TotalCredit") AS "TotalCredit",
      SUM("Total") AS "Total"
  FROM (
      SELECT 
          LEFT("Account", 5) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) NOT IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 3) = '2.2'
      GROUP BY LEFT("Account", 5)
      UNION ALL
      SELECT 
          LEFT("Account", 3) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 3) = '2.2'
      GROUP BY LEFT("Account", 3)
  ) AS subquery
  GROUP BY GROUPING SETS ("AccountGroup",())
  ORDER BY "AccountGroup" ASC
  ) T1
  
UNION ALL
--2.3 	    Absorción de Pérdidas aprobado con Reolución Administrativa IS-N°…
SELECT
'2' AS "#",
'2.3. Absorción de Pérdidas aprobado con Reolución Administrativa IS-N°' AS "DESCRIPCION DE MOVIMIENTOS",
  SUM(CASE WHEN T1."AccountGroup" = '30101' THEN T1."Total" ELSE 0 END) AS "301.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30201' THEN T1."Total" ELSE 0 END) AS "302.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30202' THEN T1."Total" ELSE 0 END) AS "302.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30203' THEN T1."Total" ELSE 0 END) AS "302.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30204' THEN T1."Total" ELSE 0 END) AS "302.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30301' THEN T1."Total" ELSE 0 END) AS "303.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30302' THEN T1."Total" ELSE 0 END) AS "303.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30303' THEN T1."Total" ELSE 0 END) AS "303.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30304' THEN T1."Total" ELSE 0 END) AS "303.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30401' THEN T1."Total" ELSE 0 END) AS "304.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30501' THEN T1."Total" ELSE 0 END) AS "305.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30502' THEN T1."Total" ELSE 0 END) AS "305.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30503' THEN T1."Total" ELSE 0 END) AS "305.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30601' THEN T1."Total" ELSE 0 END) AS "306.01M",
  SUM(CASE WHEN T1."AccountGroup" = '307' THEN T1."Total" ELSE 0 END) AS "307",
  SUM(CASE WHEN T1."AccountGroup" = '308' THEN T1."Total" ELSE 0 END) AS "308",
  SUM(CASE WHEN T1."AccountGroup" = 'Total' THEN T1."Total" ELSE 0 END) AS "TOTAL PATRIMONIO"
FROM
  (
      SELECT 
      COALESCE("AccountGroup", 'Total') AS "AccountGroup",
      SUM("TotalDebit") AS "TotalDebit",
      SUM("TotalCredit") AS "TotalCredit",
      SUM("Total") AS "Total"
  FROM (
      SELECT 
          LEFT("Account", 5) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) NOT IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 3) = '2.3'
      GROUP BY LEFT("Account", 5)
      UNION ALL
      SELECT 
          LEFT("Account", 3) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 3) = '2.3'
      GROUP BY LEFT("Account", 3)
  ) AS subquery
  GROUP BY GROUPING SETS ("AccountGroup",())
  ORDER BY "AccountGroup" ASC
  ) T1
  
UNION ALL
--2.4 	    Solicitud de Capitalización a la APS según carta Cite:…
SELECT
'2' AS "#",
'2.4. Solicitud de Capitalización a la APS según carta Cite' AS "DESCRIPCION DE MOVIMIENTOS",
  SUM(CASE WHEN T1."AccountGroup" = '30101' THEN T1."Total" ELSE 0 END) AS "301.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30201' THEN T1."Total" ELSE 0 END) AS "302.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30202' THEN T1."Total" ELSE 0 END) AS "302.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30203' THEN T1."Total" ELSE 0 END) AS "302.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30204' THEN T1."Total" ELSE 0 END) AS "302.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30301' THEN T1."Total" ELSE 0 END) AS "303.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30302' THEN T1."Total" ELSE 0 END) AS "303.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30303' THEN T1."Total" ELSE 0 END) AS "303.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30304' THEN T1."Total" ELSE 0 END) AS "303.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30401' THEN T1."Total" ELSE 0 END) AS "304.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30501' THEN T1."Total" ELSE 0 END) AS "305.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30502' THEN T1."Total" ELSE 0 END) AS "305.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30503' THEN T1."Total" ELSE 0 END) AS "305.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30601' THEN T1."Total" ELSE 0 END) AS "306.01M",
  SUM(CASE WHEN T1."AccountGroup" = '307' THEN T1."Total" ELSE 0 END) AS "307",
  SUM(CASE WHEN T1."AccountGroup" = '308' THEN T1."Total" ELSE 0 END) AS "308",
  SUM(CASE WHEN T1."AccountGroup" = 'Total' THEN T1."Total" ELSE 0 END) AS "TOTAL PATRIMONIO"
FROM
  (
  SELECT 
      COALESCE("AccountGroup", 'Total') AS "AccountGroup",
      SUM("TotalDebit") AS "TotalDebit",
      SUM("TotalCredit") AS "TotalCredit",
      SUM("Total") AS "Total"
  FROM (
      SELECT 
          LEFT("Account", 5) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) NOT IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 3) = '2.4'
      GROUP BY LEFT("Account", 5)
      UNION ALL
      SELECT 
          LEFT("Account", 3) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 3) = '2.4'
      GROUP BY LEFT("Account", 3)
  ) AS subquery
  GROUP BY GROUPING SETS ("AccountGroup",())
  ORDER BY "AccountGroup" ASC
  ) T1
  
UNION ALL
--2.5 	    Capitalización Aprobada por la APS según R.A….
SELECT
'2' AS "#",
'2.5. Capitalización Aprobada por la APS según R.A…' AS "DESCRIPCION DE MOVIMIENTOS",
  SUM(CASE WHEN T1."AccountGroup" = '30101' THEN T1."Total" ELSE 0 END) AS "301.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30201' THEN T1."Total" ELSE 0 END) AS "302.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30202' THEN T1."Total" ELSE 0 END) AS "302.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30203' THEN T1."Total" ELSE 0 END) AS "302.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30204' THEN T1."Total" ELSE 0 END) AS "302.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30301' THEN T1."Total" ELSE 0 END) AS "303.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30302' THEN T1."Total" ELSE 0 END) AS "303.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30303' THEN T1."Total" ELSE 0 END) AS "303.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30304' THEN T1."Total" ELSE 0 END) AS "303.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30401' THEN T1."Total" ELSE 0 END) AS "304.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30501' THEN T1."Total" ELSE 0 END) AS "305.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30502' THEN T1."Total" ELSE 0 END) AS "305.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30503' THEN T1."Total" ELSE 0 END) AS "305.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30601' THEN T1."Total" ELSE 0 END) AS "306.01M",
  SUM(CASE WHEN T1."AccountGroup" = '307' THEN T1."Total" ELSE 0 END) AS "307",
  SUM(CASE WHEN T1."AccountGroup" = '308' THEN T1."Total" ELSE 0 END) AS "308",
  SUM(CASE WHEN T1."AccountGroup" = 'Total' THEN T1."Total" ELSE 0 END) AS "TOTAL PATRIMONIO"
FROM
  (
  SELECT 
      COALESCE("AccountGroup", 'Total') AS "AccountGroup",
      SUM("TotalDebit") AS "TotalDebit",
      SUM("TotalCredit") AS "TotalCredit",
      SUM("Total") AS "Total"
  FROM (
      SELECT 
          LEFT("Account", 5) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) NOT IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 3) = '2.5'
      GROUP BY LEFT("Account", 5)
      UNION ALL
      SELECT 
          LEFT("Account", 3) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 3) = '2.5'
      GROUP BY LEFT("Account", 3)
  ) AS subquery
  GROUP BY GROUPING SETS ("AccountGroup",())
  ORDER BY "AccountGroup" ASC
  ) T1
  
UNION ALL
--3 	    MOVIMIENTOS EXTERNOS
SELECT
'3.' AS "#",
'MOVIMIENTOS EXTERNOS' AS "DESCRIPCION DE MOVIMIENTOS",
  SUM(CASE WHEN T1."AccountGroup" = '30101' THEN T1."Total" ELSE 0 END) AS "301.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30201' THEN T1."Total" ELSE 0 END) AS "302.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30202' THEN T1."Total" ELSE 0 END) AS "302.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30203' THEN T1."Total" ELSE 0 END) AS "302.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30204' THEN T1."Total" ELSE 0 END) AS "302.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30301' THEN T1."Total" ELSE 0 END) AS "303.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30302' THEN T1."Total" ELSE 0 END) AS "303.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30303' THEN T1."Total" ELSE 0 END) AS "303.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30304' THEN T1."Total" ELSE 0 END) AS "303.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30401' THEN T1."Total" ELSE 0 END) AS "304.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30501' THEN T1."Total" ELSE 0 END) AS "305.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30502' THEN T1."Total" ELSE 0 END) AS "305.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30503' THEN T1."Total" ELSE 0 END) AS "305.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30601' THEN T1."Total" ELSE 0 END) AS "306.01M",
  SUM(CASE WHEN T1."AccountGroup" = '307' THEN T1."Total" ELSE 0 END) AS "307",
  SUM(CASE WHEN T1."AccountGroup" = '308' THEN T1."Total" ELSE 0 END) AS "308",
  SUM(CASE WHEN T1."AccountGroup" = 'Total' THEN T1."Total" ELSE 0 END) AS "TOTAL PATRIMONIO"
FROM
  (
  SELECT 
      COALESCE("AccountGroup", 'Total') AS "AccountGroup",
      SUM("TotalDebit") AS "TotalDebit",
      SUM("TotalCredit") AS "TotalCredit",
      SUM("Total") AS "Total"
  FROM (
      SELECT 
          LEFT("Account", 5) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) NOT IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 2) = '3.'
      GROUP BY LEFT("Account", 5)
      UNION ALL
      SELECT 
          LEFT("Account", 3) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 2) = '3.'
      GROUP BY LEFT("Account", 3)
  ) AS subquery
  GROUP BY GROUPING SETS ("AccountGroup",())
  ORDER BY "AccountGroup" ASC
  ) T1
  
UNION ALL

--3.1 	    Aportes para Futuros Aumentos de Capital
SELECT
'3.1' AS "#",
'Aportes para Futuros Aumentos de Capital' AS "DESCRIPCION DE MOVIMIENTOS",
  SUM(CASE WHEN T1."AccountGroup" = '30101' THEN T1."Total" ELSE 0 END) AS "301.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30201' THEN T1."Total" ELSE 0 END) AS "302.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30202' THEN T1."Total" ELSE 0 END) AS "302.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30203' THEN T1."Total" ELSE 0 END) AS "302.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30204' THEN T1."Total" ELSE 0 END) AS "302.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30301' THEN T1."Total" ELSE 0 END) AS "303.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30302' THEN T1."Total" ELSE 0 END) AS "303.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30303' THEN T1."Total" ELSE 0 END) AS "303.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30304' THEN T1."Total" ELSE 0 END) AS "303.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30401' THEN T1."Total" ELSE 0 END) AS "304.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30501' THEN T1."Total" ELSE 0 END) AS "305.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30502' THEN T1."Total" ELSE 0 END) AS "305.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30503' THEN T1."Total" ELSE 0 END) AS "305.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30601' THEN T1."Total" ELSE 0 END) AS "306.01M",
  SUM(CASE WHEN T1."AccountGroup" = '307' THEN T1."Total" ELSE 0 END) AS "307",
  SUM(CASE WHEN T1."AccountGroup" = '308' THEN T1."Total" ELSE 0 END) AS "308",
  SUM(CASE WHEN T1."AccountGroup" = 'Total' THEN T1."Total" ELSE 0 END) AS "TOTAL PATRIMONIO"
FROM
  (
      SELECT 
      COALESCE("AccountGroup", 'Total') AS "AccountGroup",
      SUM("TotalDebit") AS "TotalDebit",
      SUM("TotalCredit") AS "TotalCredit",
      SUM("Total") AS "Total"
  FROM (
      SELECT 
          LEFT("Account", 5) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) NOT IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 3) = '3.1'
      GROUP BY LEFT("Account", 5)
      UNION ALL
      SELECT 
          LEFT("Account", 3) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 3) = '3.1'
      GROUP BY LEFT("Account", 3)
  ) AS subquery
  GROUP BY GROUPING SETS ("AccountGroup",())
  ORDER BY "AccountGroup" ASC
  ) T1
  
UNION ALL
--3.2 	    Distribución de dividendos
SELECT
'3.2' AS "#",
'Distribución de dividendos' AS "DESCRIPCION DE MOVIMIENTOS",
  SUM(CASE WHEN T1."AccountGroup" = '30101' THEN T1."Total" ELSE 0 END) AS "301.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30201' THEN T1."Total" ELSE 0 END) AS "302.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30202' THEN T1."Total" ELSE 0 END) AS "302.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30203' THEN T1."Total" ELSE 0 END) AS "302.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30204' THEN T1."Total" ELSE 0 END) AS "302.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30301' THEN T1."Total" ELSE 0 END) AS "303.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30302' THEN T1."Total" ELSE 0 END) AS "303.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30303' THEN T1."Total" ELSE 0 END) AS "303.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30304' THEN T1."Total" ELSE 0 END) AS "303.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30401' THEN T1."Total" ELSE 0 END) AS "304.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30501' THEN T1."Total" ELSE 0 END) AS "305.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30502' THEN T1."Total" ELSE 0 END) AS "305.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30503' THEN T1."Total" ELSE 0 END) AS "305.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30601' THEN T1."Total" ELSE 0 END) AS "306.01M",
  SUM(CASE WHEN T1."AccountGroup" = '307' THEN T1."Total" ELSE 0 END) AS "307",
  SUM(CASE WHEN T1."AccountGroup" = '308' THEN T1."Total" ELSE 0 END) AS "308",
  SUM(CASE WHEN T1."AccountGroup" = 'Total' THEN T1."Total" ELSE 0 END) AS "TOTAL PATRIMONIO"
FROM
  (
      SELECT 
      COALESCE("AccountGroup", 'Total') AS "AccountGroup",
      SUM("TotalDebit") AS "TotalDebit",
      SUM("TotalCredit") AS "TotalCredit",
      SUM("Total") AS "Total"
  FROM (
      SELECT 
          LEFT("Account", 5) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) NOT IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 3) = '3.2'
      GROUP BY LEFT("Account", 5)
      UNION ALL
      SELECT 
          LEFT("Account", 3) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 3) = '3.2'
      GROUP BY LEFT("Account", 3)
  ) AS subquery
  GROUP BY GROUPING SETS ("AccountGroup",())
  ORDER BY "AccountGroup" ASC
  ) T1
  
UNION ALL
--3.3 	    Ajustes Realizados
SELECT
'3.3.' AS "#",
'Ajustes Realizados' AS "DESCRIPCION DE MOVIMIENTOS",
  SUM(CASE WHEN T1."AccountGroup" = '30101' THEN T1."Total" ELSE 0 END) AS "301.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30201' THEN T1."Total" ELSE 0 END) AS "302.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30202' THEN T1."Total" ELSE 0 END) AS "302.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30203' THEN T1."Total" ELSE 0 END) AS "302.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30204' THEN T1."Total" ELSE 0 END) AS "302.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30301' THEN T1."Total" ELSE 0 END) AS "303.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30302' THEN T1."Total" ELSE 0 END) AS "303.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30303' THEN T1."Total" ELSE 0 END) AS "303.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30304' THEN T1."Total" ELSE 0 END) AS "303.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30401' THEN T1."Total" ELSE 0 END) AS "304.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30501' THEN T1."Total" ELSE 0 END) AS "305.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30502' THEN T1."Total" ELSE 0 END) AS "305.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30503' THEN T1."Total" ELSE 0 END) AS "305.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30601' THEN T1."Total" ELSE 0 END) AS "306.01M",
  SUM(CASE WHEN T1."AccountGroup" = '307' THEN T1."Total" ELSE 0 END) AS "307",
  SUM(CASE WHEN T1."AccountGroup" = '308' THEN T1."Total" ELSE 0 END) AS "308",
  SUM(CASE WHEN T1."AccountGroup" = 'Total' THEN T1."Total" ELSE 0 END) AS "TOTAL PATRIMONIO"
FROM
  (  SELECT 
      COALESCE("AccountGroup", 'Total') AS "AccountGroup",
      SUM("TotalDebit") AS "TotalDebit",
      SUM("TotalCredit") AS "TotalCredit",
      SUM("Total") AS "Total"
  FROM (
      SELECT 
          LEFT("Account", 5) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) NOT IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 4) = '3.3.'
      GROUP BY LEFT("Account", 5)
      UNION ALL
      SELECT 
          LEFT("Account", 3) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 4) = '3.3.'
      GROUP BY LEFT("Account", 3)
  ) AS subquery
  GROUP BY GROUPING SETS ("AccountGroup",())
  ORDER BY "AccountGroup" ASC
  ) T1
  
UNION ALL

--3.3.1       Propuestos por auditoria externa: detallar concepto e importancia por separado
SELECT
'3.3.1' AS "#",
'Propuestos por auditoria externa: detallar concepto e importancia por separado' AS "DESCRIPCION DE MOVIMIENTOS",
  SUM(CASE WHEN T1."AccountGroup" = '30101' THEN T1."Total" ELSE 0 END) AS "301.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30201' THEN T1."Total" ELSE 0 END) AS "302.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30202' THEN T1."Total" ELSE 0 END) AS "302.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30203' THEN T1."Total" ELSE 0 END) AS "302.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30204' THEN T1."Total" ELSE 0 END) AS "302.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30301' THEN T1."Total" ELSE 0 END) AS "303.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30302' THEN T1."Total" ELSE 0 END) AS "303.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30303' THEN T1."Total" ELSE 0 END) AS "303.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30304' THEN T1."Total" ELSE 0 END) AS "303.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30401' THEN T1."Total" ELSE 0 END) AS "304.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30501' THEN T1."Total" ELSE 0 END) AS "305.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30502' THEN T1."Total" ELSE 0 END) AS "305.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30503' THEN T1."Total" ELSE 0 END) AS "305.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30601' THEN T1."Total" ELSE 0 END) AS "306.01M",
  SUM(CASE WHEN T1."AccountGroup" = '307' THEN T1."Total" ELSE 0 END) AS "307",
  SUM(CASE WHEN T1."AccountGroup" = '308' THEN T1."Total" ELSE 0 END) AS "308",
  SUM(CASE WHEN T1."AccountGroup" = 'Total' THEN T1."Total" ELSE 0 END) AS "TOTAL PATRIMONIO"
FROM
  (
      SELECT 
      COALESCE("AccountGroup", 'Total') AS "AccountGroup",
      SUM("TotalDebit") AS "TotalDebit",
      SUM("TotalCredit") AS "TotalCredit",
      SUM("Total") AS "Total"
  FROM (
      SELECT 
          LEFT("Account", 5) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) NOT IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 5) = '3.3.1'
      GROUP BY LEFT("Account", 5)
      UNION ALL
      SELECT 
          LEFT("Account", 3) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 5) = '3.3.1'
      GROUP BY LEFT("Account", 3)
  ) AS subquery
  GROUP BY GROUPING SETS ("AccountGroup",())
  ORDER BY "AccountGroup" ASC
  ) T1
  
UNION ALL
--3.3.2       Realizados por la Compañía, detallar concepto e importe por separado
SELECT
'3.3.2' AS "#",
'Realizados por la Compañía, detallar concepto e importe por separado' AS "DESCRIPCION DE MOVIMIENTOS",
  SUM(CASE WHEN T1."AccountGroup" = '30101' THEN T1."Total" ELSE 0 END) AS "301.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30201' THEN T1."Total" ELSE 0 END) AS "302.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30202' THEN T1."Total" ELSE 0 END) AS "302.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30203' THEN T1."Total" ELSE 0 END) AS "302.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30204' THEN T1."Total" ELSE 0 END) AS "302.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30301' THEN T1."Total" ELSE 0 END) AS "303.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30302' THEN T1."Total" ELSE 0 END) AS "303.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30303' THEN T1."Total" ELSE 0 END) AS "303.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30304' THEN T1."Total" ELSE 0 END) AS "303.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30401' THEN T1."Total" ELSE 0 END) AS "304.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30501' THEN T1."Total" ELSE 0 END) AS "305.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30502' THEN T1."Total" ELSE 0 END) AS "305.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30503' THEN T1."Total" ELSE 0 END) AS "305.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30601' THEN T1."Total" ELSE 0 END) AS "306.01M",
  SUM(CASE WHEN T1."AccountGroup" = '307' THEN T1."Total" ELSE 0 END) AS "307",
  SUM(CASE WHEN T1."AccountGroup" = '308' THEN T1."Total" ELSE 0 END) AS "308",
  SUM(CASE WHEN T1."AccountGroup" = 'Total' THEN T1."Total" ELSE 0 END) AS "TOTAL PATRIMONIO"
FROM
  (
      SELECT 
      COALESCE("AccountGroup", 'Total') AS "AccountGroup",
      SUM("TotalDebit") AS "TotalDebit",
      SUM("TotalCredit") AS "TotalCredit",
      SUM("Total") AS "Total"
  FROM (
      SELECT 
          LEFT("Account", 5) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) NOT IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 5) = '3.3.2'
      GROUP BY LEFT("Account", 5)
      UNION ALL
      SELECT 
          LEFT("Account", 3) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 5) = '3.3.2'
      GROUP BY LEFT("Account", 3)
  ) AS subquery
  GROUP BY GROUPING SETS ("AccountGroup",())
  ORDER BY "AccountGroup" ASC
  ) T1
  
UNION ALL
--4. 	    RESULTADO DE LA GESTION
--  Utilidad de la gestión
SELECT
'4.' AS "#",
'RESULTADO DE GESTION' AS "DESCRIPCION DE MOVIMIENTOS",
  SUM(CASE WHEN T1."AccountGroup" = '30101' THEN T1."Total" ELSE 0 END) AS "301.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30201' THEN T1."Total" ELSE 0 END) AS "302.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30202' THEN T1."Total" ELSE 0 END) AS "302.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30203' THEN T1."Total" ELSE 0 END) AS "302.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30204' THEN T1."Total" ELSE 0 END) AS "302.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30301' THEN T1."Total" ELSE 0 END) AS "303.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30302' THEN T1."Total" ELSE 0 END) AS "303.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30303' THEN T1."Total" ELSE 0 END) AS "303.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30304' THEN T1."Total" ELSE 0 END) AS "303.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30401' THEN T1."Total" ELSE 0 END) AS "304.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30501' THEN T1."Total" ELSE 0 END) AS "305.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30502' THEN T1."Total" ELSE 0 END) AS "305.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30503' THEN T1."Total" ELSE 0 END) AS "305.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30601' THEN T1."Total" ELSE 0 END) AS "306.01M",
  SUM(CASE WHEN T1."AccountGroup" = '307' THEN T1."Total" ELSE 0 END) AS "307",
  SUM(CASE WHEN T1."AccountGroup" = '308' THEN T1."Total" ELSE 0 END) AS "308",
  SUM(CASE WHEN T1."AccountGroup" = 'Total' THEN T1."Total" ELSE 0 END) AS "TOTAL PATRIMONIO"
FROM
(

SELECT 
      COALESCE("AccountGroup", 'Total') AS "AccountGroup",
      SUM("TotalDebit") AS "TotalDebit",
      SUM("TotalCredit") AS "TotalCredit",
      SUM("Total") AS "Total"
  FROM (
      SELECT 
          LEFT("Account", 5) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) NOT IN ('307', '308') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 2) = '4.'
      GROUP BY LEFT("Account", 5)
      UNION ALL
      SELECT 
          LEFT("Account", 3) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) IN ('307') AND
          "RefDate" >= fdesde AND
          "RefDate" <= fhasta AND
          LEFT("LineMemo", 2) = '4.'
      GROUP BY LEFT("Account", 3)
      UNION ALL      
      SELECT 
      "AccountGroup",
      SUM("TotalDebit") AS "TotalDebit",
      SUM("TotalCredit") AS "TotalCredit",
      SUM("Total") AS "Total"
FROM
(
SELECT 
    LEFT("Account", 3) AS "AccountGroup",
    SUM("Debit") AS "TotalDebit",
    SUM("Credit") AS "TotalCredit",
    SUM("Credit" - "Debit") AS "Total"
FROM JDT1
WHERE 
    LEFT("Account", 1) = '3' AND
    LEFT("Account", 3) IN ('308') AND
    "RefDate" >= fdesde AND
    "RefDate" <= fhasta AND
    LEFT("LineMemo", 2) NOT IN ('1.', '2.', '3.')
GROUP BY LEFT("Account", 3)
UNION ALL
SELECT
CASE WHEN "AccountGroup" = 'Total' THEN '308' ELSE '0' END AS "AccountGroup",
"Debit",
"Credit",
"Total"
FROM(
SELECT
    COALESCE("AccountGroup", 'Total') AS "AccountGroup",
    SUM("Debit") AS "Debit",
    SUM("Credit") AS "Credit",
    SUM("Credit" - "Debit") AS "Total"
FROM
(
    SELECT
        LEFT("Account",1) AS "AccountGroup",
        "Debit",
        "Credit"
    FROM
        JDT1
    WHERE
        LEFT("Account",1) IN (4,5) AND
        "RefDate" >= fdesde AND
        "RefDate" <= fhasta
)
GROUP BY GROUPING SETS (("AccountGroup"), ())
ORDER BY "AccountGroup" ASC
)
WHERE "AccountGroup" = 'Total'
) AS subquery
GROUP BY "AccountGroup"
ORDER BY "AccountGroup" ASC
) AS subquery
GROUP BY GROUPING SETS ("AccountGroup",())
ORDER BY "AccountGroup" ASC

) T1
  
UNION ALL
--  Saldos al 31 de diciembre de 2022
SELECT
'' AS "#",
'Saldo al ' || TO_NVARCHAR(TO_DATE(fhasta, 'YYYY-MM-DD'), 'DD "de" Month "de" YYYY') AS "DESCRIPCION DE MOVIMIENTOS",
  SUM(CASE WHEN T1."AccountGroup" = '30101' THEN T1."Total" ELSE 0 END) AS "301.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30201' THEN T1."Total" ELSE 0 END) AS "302.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30202' THEN T1."Total" ELSE 0 END) AS "302.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30203' THEN T1."Total" ELSE 0 END) AS "302.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30204' THEN T1."Total" ELSE 0 END) AS "302.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30301' THEN T1."Total" ELSE 0 END) AS "303.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30302' THEN T1."Total" ELSE 0 END) AS "303.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30303' THEN T1."Total" ELSE 0 END) AS "303.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30304' THEN T1."Total" ELSE 0 END) AS "303.04M",
  SUM(CASE WHEN T1."AccountGroup" = '30401' THEN T1."Total" ELSE 0 END) AS "304.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30501' THEN T1."Total" ELSE 0 END) AS "305.01M",
  SUM(CASE WHEN T1."AccountGroup" = '30502' THEN T1."Total" ELSE 0 END) AS "305.02M",
  SUM(CASE WHEN T1."AccountGroup" = '30503' THEN T1."Total" ELSE 0 END) AS "305.03M",
  SUM(CASE WHEN T1."AccountGroup" = '30601' THEN T1."Total" ELSE 0 END) AS "306.01M",
  SUM(CASE WHEN T1."AccountGroup" = '307' THEN T1."Total" ELSE 0 END) AS "307",
  SUM(CASE WHEN T1."AccountGroup" = '308' THEN T1."Total" ELSE 0 END) AS "308",
  SUM(CASE WHEN T1."AccountGroup" = 'Total' THEN T1."Total" ELSE 0 END) AS "TOTAL PATRIMONIO"
FROM
  (
    
SELECT 
      COALESCE("AccountGroup", 'Total') AS "AccountGroup",
      SUM("TotalDebit") AS "TotalDebit",
      SUM("TotalCredit") AS "TotalCredit",
      SUM("Total") AS "Total"
  FROM (
      SELECT 
          LEFT("Account", 5) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) NOT IN ('307', '308') AND
          "RefDate" <= fhasta AND
          "RefDate" >= fdesde
      GROUP BY LEFT("Account", 5)
      UNION ALL
      SELECT 
          LEFT("Account", 3) AS "AccountGroup",
          SUM("Debit") AS "TotalDebit",
          SUM("Credit") AS "TotalCredit",
          SUM("Credit" - "Debit") AS "Total"
      FROM JDT1
      WHERE 
          LEFT("Account", 1) = '3' AND
          LEFT("Account", 3) IN ('307') AND
          "RefDate" <= fhasta AND
          "RefDate" >= fdesde
      GROUP BY LEFT("Account", 3)
      UNION ALL      
      SELECT 
      "AccountGroup",
      SUM("TotalDebit") AS "TotalDebit",
      SUM("TotalCredit") AS "TotalCredit",
      SUM("Total") AS "Total"
FROM
(
SELECT 
    LEFT("Account", 3) AS "AccountGroup",
    SUM("Debit") AS "TotalDebit",
    SUM("Credit") AS "TotalCredit",
    SUM("Credit" - "Debit") AS "Total"
FROM JDT1
WHERE 
    LEFT("Account", 1) = '3' AND
    LEFT("Account", 3) IN ('308') AND
    "RefDate" <= fhasta AND
    "RefDate" >= fdesde
GROUP BY LEFT("Account", 3)
UNION ALL
SELECT
CASE WHEN "AccountGroup" = 'Total' THEN '308' ELSE '0' END AS "AccountGroup",
"Debit",
"Credit",
"Total"
FROM(
SELECT
    COALESCE("AccountGroup", 'Total') AS "AccountGroup",
    SUM("Debit") AS "Debit",
    SUM("Credit") AS "Credit",
    SUM("Credit" - "Debit") AS "Total"
FROM
(
    SELECT
        LEFT("Account",1) AS "AccountGroup",
        "Debit",
        "Credit"
    FROM
        JDT1
    WHERE
        LEFT("Account",1) IN (4,5) AND
        "RefDate" <= fhasta AND
        "RefDate" >= fdesde
)
GROUP BY GROUPING SETS (("AccountGroup"), ())
ORDER BY "AccountGroup" ASC
)
WHERE "AccountGroup" = 'Total'
) AS subquery
GROUP BY "AccountGroup"
ORDER BY "AccountGroup" ASC
) AS subquery
GROUP BY GROUPING SETS ("AccountGroup",())
ORDER BY "AccountGroup" ASC

  ) T1;

END;