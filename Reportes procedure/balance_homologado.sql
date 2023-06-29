CREATE PROCEDURE ACB_FIN_REG_BALANCE_HOMOLOGADO (in fdesde date, in fhasta date) 

AS BEGIN 
-- GTP: BALANCE HOMOLOGADO
-- CALL ACB_FIN_REG_BALANCE_HOMOLOGADO('2023-01-01','2023-01-31')
SELECT nivel0,
  nivel1,
  codigo,
  REPLACE(REPLACE(nombre, 'MN', ''), 'ME', '') AS nombre,
  saldo
FROM (
    --2
    SELECT nivel0,
      nivel1,
      codigo,
      nombre,
      saldo,
      CASE
        WHEN COUNT(*) OVER (PARTITION BY codigo) > 1 THEN CASE
          WHEN ROW_NUMBER() OVER (
            PARTITION BY codigo
            ORDER BY codigo
          ) = 1 THEN 1
          ELSE 2
        END
        ELSE 1
      END AS contador_linea
    FROM (
        SELECT CASE
            WHEN LEFT(T0."AcctCode", 1) = '1' THEN 'ACTIVO'
            WHEN LEFT(T0."AcctCode", 1) = '2' THEN 'PASIVO'
            WHEN LEFT(T0."AcctCode", 1) = '3' THEN 'PATRIMONIO'
            WHEN LEFT(T0."AcctCode", 1) = '6' THEN 'DEUDORAS'
            WHEN LEFT(T0."AcctCode", 1) = '7' THEN 'ACREEDORAS'
          END AS nivel0,
          T2."AcctName" nivel1,
          LEFT(T0."AcctCode", 5) AS codigo,
          T3."AcctName" AS nombre,
          CASE
            WHEN SUM(T1."Debit" - T1."Credit") IS NULL THEN SUM(0)
            ELSE SUM(T1."Debit" - T1."Credit")
          END AS saldo
        FROM OACT T0
          LEFT JOIN (
            SELECT "RefDate",
              "Account",
              "Debit",
              "Credit"
            FROM JDT1
            WHERE "RefDate" BETWEEN fdesde AND fhasta
          ) T1 ON T1."Account" = T0."AcctCode"
          LEFT JOIN (
            --3
            --TABLA DE HOMOLOGACION
            SELECT "AcctCode",
              "AcctName"
            FROM (
                SELECT LEFT("AcctCode", 5) AS "AcctCode",
                  CASE
                    WHEN LEFT("AcctCode", 5) IN (10101, 10102) THEN 'Disponibilidades'
                    WHEN LEFT("AcctCode", 5) IN (10401, 10489, 10404, 10402, 10480) THEN 'Inversiones'
                    WHEN LEFT("AcctCode", 5) IN (
                      10201,
                      10202,
                      10205,
                      10206,
                      10207,
                      10208,
                      10209,
                      10210,
                      10211,
                      10212,
                      10213,
                      10214,
                      10215,
                      10222,
                      10223,
                      10224,
                      10226,
                      10228,
                      10278,
                      10279,
                      10287,
                      10288,
                      10289
                    ) THEN 'Exigible Técnico'
                    WHEN LEFT("AcctCode", 5) IN (
                      10301,
                      10302,
                      10303,
                      10304,
                      10305,
                      10306,
                      10307,
                      10308,
                      10309,
                      10378,
                      10379,
                      10389,
                      10405,
                      10702
                    ) THEN 'Otras cuentas por cobrar'
                    WHEN LEFT("AcctCode", 5) IN (10601, 10689) THEN 'Bienes realizables'
                    WHEN LEFT("AcctCode", 5) IN (10501, 10502, 10503, 10504, 10505, 10580, 10403) THEN 'Bienes de Uso'
                    WHEN LEFT("AcctCode", 5) IN (10701, 10703, 10801, 10804, 10885) THEN 'Otros Activos' --WHEN LEFT("AcctCode",5) IN (60301M01,60901M03) THEN 'Cuentas Contingentes Deudoras'
                    --WHEN LEFT("AcctCode",5) IN (60101M,60102M96,60201M02,60201M02,60901M02,60901M0101,60901M0102,60901M0103,60901M0104,60901M0105,60901M0106) THEN 'Cuentas de Orden Deudoras'
                    WHEN LEFT("AcctCode", 5) IN (20101, 20301) THEN 'Obligaciones con Bancos y Entidades Financieras'
                    WHEN LEFT("AcctCode", 5) IN (
                      20201,
                      20202,
                      20203,
                      20204,
                      20205,
                      20206,
                      20207,
                      20208,
                      20209,
                      20210,
                      20211,
                      20212,
                      20213,
                      20214,
                      20215,
                      20216,
                      20217,
                      20218,
                      20219,
                      20220,
                      20221,
                      20222,
                      20224,
                      20225,
                      20226,
                      20227,
                      20228
                    ) THEN 'Obligaciones Técnicas'
                    WHEN LEFT("AcctCode", 5) IN (
                      20302,
                      20303,
                      20304,
                      20305,
                      20306,
                      20307,
                      20308,
                      20309,
                      20310,
                      20311,
                      20701,
                      20702,
                      20801,
                      20802,
                      20803,
                      20804
                    ) THEN 'Otras cuentas por pagar'
                    WHEN LEFT("AcctCode", 5) IN (20401, 20402, 20403, 20404) THEN 'Reservas Técnicas de Seguros'
                    WHEN LEFT("AcctCode", 5) IN (20501, 20502, 20503, 20504, 20505, 20506) THEN 'Reservas Técnicas de Siniestros'
                    WHEN LEFT("AcctCode", 5) IN (20312) THEN 'Valores en circulación'
                    WHEN LEFT("AcctCode", 5) IN (30101) THEN 'Capital social'
                    WHEN LEFT("AcctCode", 5) IN (30201, 30202, 30203, 30204, 30304, 30401) THEN 'Aportes no capitalizados'
                    WHEN LEFT("AcctCode", 5) IN (30301, 30302, 30303, 30501, 30502, 30503, 30601) THEN 'Reservas'
                    WHEN LEFT("AcctCode", 5) IN (30701, 30702, 30801, 30802) THEN 'Resultados acumulados' --WHEN LEFT("AcctCode",5) IN (70901M0301,70301M01) THEN Cuentas contingentes acreedoras
                    --WHEN LEFT("AcctCode",5) IN (70901M0101,70901M0102,70901M0202,70201M01) THEN Cuentas de orden acreedoras
                    --WHEN LEFT("AcctCode",5) IN (70101M,70102M,70103M,70104M,70105M,70106M) THEN Cuentas de orden acreedoras
                    ELSE ''
                  END AS "AcctName"
                FROM OACT
                WHERE LENGTH("AcctCode") = 6
              )
            WHERE LENGTH("AcctName") <> 0
          ) T2 ON LEFT(T0."AcctCode", 5) = T2."AcctCode"
          LEFT JOIN (
            SELECT "AcctCode",
              "AcctName"
            FROM OACT
            WHERE LENGTH("AcctCode") = 6
          ) T3 ON LEFT(T0."AcctCode", 5) = LEFT(T3."AcctCode", 5)
        WHERE T0."Postable" = 'Y'
          AND LEFT(T0."AcctCode", 1) IN ('1', '2', '3', '6', '7')
        GROUP BY CASE
            WHEN LEFT(T0."AcctCode", 1) = '1' THEN 'ACTIVO'
            WHEN LEFT(T0."AcctCode", 1) = '2' THEN 'PASIVO'
            WHEN LEFT(T0."AcctCode", 1) = '3' THEN 'PATRIMONIO'
            WHEN LEFT(T0."AcctCode", 1) = '6' THEN 'DEUDORAS'
            WHEN LEFT(T0."AcctCode", 1) = '7' THEN 'ACREEDORAS'
          END,
          T2."AcctName",
          LEFT(T0."AcctCode", 5),
          T3."AcctName"
      ) --1
  ) --2
WHERE contador_linea = 1
ORDER BY 
    CASE
        WHEN nivel0 = 'ACTIVO' THEN 1
        WHEN nivel0 = 'DEUDORAS' THEN 2
        WHEN nivel0 = 'PASIVO' THEN 3
        WHEN nivel0 = 'PATRIMONIO' THEN 4
        WHEN nivel0 = 'ACREEDORAS' THEN 5
        ELSE 6
    END ASC,
    CASE nivel1
        WHEN 'Disponibilidades' THEN 1
        WHEN 'Inversiones' THEN 2
        WHEN 'Exigible Técnico' THEN 3
        WHEN 'Otras cuentas por cobrar' THEN 4
        WHEN 'Bienes realizables' THEN 5
        WHEN 'Bienes de Uso' THEN 6
        WHEN 'Otros Activos' THEN 7
        WHEN 'Cuentas Contingentes Deudoras' THEN 8
        WHEN 'Cuentas de Orden Deudoras' THEN 9
        WHEN 'Obligaciones con Bancos y Entidades Financieras' THEN 10
        WHEN 'Obligaciones Técnicas' THEN 11
        WHEN 'Otras cuentas por pagar' THEN 12
        WHEN 'Reservas Técnicas de Seguros' THEN 13
        WHEN 'Reservas Técnicas de Siniestros' THEN 14
        WHEN 'Valores en circulación' THEN 15
        WHEN 'Capital social' THEN 16
        WHEN 'Aportes no capitalizados' THEN 17
        WHEN 'Reservas' THEN 18
        WHEN 'Resultados acumulados' THEN 19
        WHEN 'Cuentas contingentes acreedoras' THEN 20
        WHEN 'Cuentas de orden acreedoras' THEN 21
    END ASC,
    codigo;
END;