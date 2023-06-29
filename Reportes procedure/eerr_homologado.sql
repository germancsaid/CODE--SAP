ALTER PROCEDURE ACB_FIN_REG_EERR_HOMOLOGADO (in fdesde date, in fhasta date) 

AS BEGIN 
-- GTP: EERR HOMOLOGADO
-- CALL ACB_FIN_REG_EERR_HOMOLOGADO('2023-01-01','2023-01-31')
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
            WHEN LEFT(T0."AcctCode", 1) = '4' THEN 'INGRESOS'
            WHEN LEFT(T0."AcctCode", 1) = '5' THEN 'EGRESOS'
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
                    WHEN LEFT("AcctCode", 5) IN (40101, 40102, 40103, 40104, 40201, 40202, 40301, 40302, 40401, 40402, 40504, 40601, 40602, 40701, 40702, 41101, 41102, 41103, 41301, 41302, 41303, 41304, 41305, 41306, 41501, 41502, 41503, 41504, 41505, 41506, 41201, 41202, 41203, 41701, 41702, 41703, 41901, 41902, 41903, 40901, 40902, 40903, 40904, 40907, 40908, 41402, 41403, 41404, 41405, 41406, 41407, 41408, 41409, 41602, 41603, 41604, 41605, 41606, 41607, 41608, 41609, 41801, 41802, 41803, 42001, 42002, 42003, 42010, 40801, 40802, 40803, 40804, 41001, 41002, 41003, 41004, 41005, 41006, 42101) THEN 'Ingresos Ordinarios'

                    --42201M01, 42201M02, 42206M01) THEN 'Ingresos Ordinarios'

                    WHEN LEFT("AcctCode", 5) IN (50101, 50102, 50103, 50201, 50202, 50301, 50302, 50401, 50402, 50601, 50602, 50701, 50702, 51101, 51102, 51103, 51701, 51702, 51703, 51901, 51902, 51903, 51201, 51202, 51203, 51204, 51301, 51302, 51303, 51501, 51502, 51503, 50901, 50902, 50903, 50904, 50905, 50906, 50908, 50909, 51601, 51401, 51402, 51403, 51602, 51603, 51610, 51802, 51803, 51804, 51805, 51806, 51807, 51808, 51809, 52002, 52003, 52004, 52005, 52006, 52007, 52008, 52009, 50801, 50802, 50803, 50804, 51001, 51002, 51003, 51004, 51005, 51006) THEN 'Gastos ordinarios'

                    --, 52201M01, 52201M06, 52202M05) THEN 'Gastos ordinarios'

                    WHEN LEFT("AcctCode", 5) IN (42401, 42402, 42403, 42305) THEN 'Otros ingresos operativos'
                    -- 42202M01, 42203M01, 42203M02, 42204M01, 42204M02, 42205M01, 42205M02, , 42203M08, 42204M07, 42205M04) THEN 'Otros ingresos operativos'

                    WHEN LEFT("AcctCode", 5) IN (52401, 52402, 52403, 52305) THEN 'Otros gastos operativos'
                    --, 52203M05, 52203M08, 52204M04, 52204M07, 52205M02, 52205M04) THEN 'Otros gastos operativos'

                    WHEN LEFT("AcctCode", 5) IN (42301, 42302, 42303, 42304) THEN 'Recuperación de Activos financieros'
                    -- 42201M03, 42201M04, 42201M05, 42202M03, 42202M04, 42203M06, 42203M07, 42204M05, 42204M06, 42205M03, 42206M02) THEN 'Recuperación de Activos financieros'

                    WHEN LEFT("AcctCode", 5) IN (52301, 52302, 52303, 52304) THEN 'Cargos por incobrabilidad y desvalorización de activos financieros'
                    --, 52201M02, 52201M03, 52201M04, 52201M05, 52202M02, 52202M03, 52202M04, 52203M06, 52203M07, 52204M05, 52204M06, 52205M03, 52206M01) THEN 'Cargos por incobrabilidad y desvalorización de activos financieros'

                    WHEN LEFT("AcctCode", 5) IN (52101, 52102, 52103, 52104, 52105, 52106, 52107, 52108, 52109, 52110, 52111, 52112, 52113, 52114) THEN 'Gastos de Administración'
                    --, 52203M01, 52203M02, 52203M03, 52203M04, 52204M01, 52204M02, 52204M03, 52205M01) THEN 'Gastos de Administración'

                    WHEN LEFT("AcctCode", 5) IN (42501, 42502, 42503, 52501, 52502, 52503) THEN 'Ajuste por inflación, diferencia de cambio y mantenimiento de valor'

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
          AND LEFT(T0."AcctCode", 1) IN ('4', '5')
        GROUP BY CASE
            WHEN LEFT(T0."AcctCode", 1) = '4' THEN 'INGRESOS'
            WHEN LEFT(T0."AcctCode", 1) = '5' THEN 'EGRESOS'
          END,
          T2."AcctName",
          LEFT(T0."AcctCode", 5),
          T3."AcctName"
      ) --1
  ) --2
WHERE contador_linea = 1
ORDER BY 
    CASE
        WHEN nivel0 = 'INGRESOS' THEN 1
        WHEN nivel0 = 'EGRESOS' THEN 2
        ELSE 3
    END ASC,
    CASE nivel1
        WHEN 'Ingresos Ordinarios' THEN 1
        WHEN 'Gastos ordinarios' THEN 2
        WHEN 'Otros ingresos operativos' THEN 3
        WHEN 'Otros gastos operativos' THEN 4
        WHEN 'Recuperación de Activos financieros' THEN 5
        WHEN 'Cargos por incobrabilidad y desvalorización de activos financieros' THEN 6
        WHEN 'Gastos de Administración' THEN 7
        WHEN 'Ajuste por inflación, diferencia de cambio y mantenimiento de valor' THEN 8
    END ASC,
    codigo;
END;