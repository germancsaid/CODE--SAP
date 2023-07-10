ALTER PROCEDURE ACB_FLUJO_DE_FONDOS (in fdesde date, in fhasta date)
AS
BEGIN
-- GTP: FLUJO DE FONDOS
--  FLUJO DE FONDOS POR ACTIVIDADES OPERATIVAS
SELECT
'A' AS "#",
'FLUJO DE FONDOS POR ACTIVIDADES OPERATIVAS' AS "CONCEPTO",
  0 AS A,
  0 AS B
  FROM DUMMY
UNION ALL
SELECT
'' AS "#",
'Utilidad Neta del Periodo' AS "CONCEPTO",
  0 AS A,
  0 AS B
  FROM DUMMY
UNION ALL
SELECT
'A.1' AS "#",
'Partidas que no han generado movimientos de fondos' AS "CONCEPTO",
  0 AS A,
  0 AS B
  FROM DUMMY
UNION ALL
SELECT
'A.1.1.' AS "#",
'Depreciación de bienes de uso' AS "CONCEPTO",
  "Total_A" AS A,
  "Total_B" AS B
  FROM 
  (

    SELECT
        SUM("Total2") - SUM("Total3") AS "Total_A",
        SUM("Total1") - SUM("Total2") AS "Total_B"
    FROM (
        SELECT
            LEFT("Account", 5) AS "Account",
            SUM("Debit") - SUM("Credit") AS "Total3",
            0 AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2023-05-30'
        GROUP BY LEFT("Account", 5)
        UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            SUM("Debit") - SUM("Credit") AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2022-12-31'
        GROUP BY LEFT("Account", 5)
                UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            0 AS "Total2",
            SUM("Debit") - SUM("Credit") AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2021-12-31'
        GROUP BY LEFT("Account", 5)

        UNION ALL

        SELECT --TABLA 4 ACCOUNT
            '10480' AS "Account",
            0 AS "Saldo3_A",
            0 AS "Saldo2_A",
            0 AS "Saldo1_A"
            FROM
                DUMMY
    ) AS subquery
    WHERE "Account" IN ('10480', '10580')
    GROUP BY LEFT("Account",1)

  )
UNION ALL
SELECT
'A.1.2.' AS "#",
'Reserva para primas en mora' AS "CONCEPTO",
  "Total_A" AS A,
  "Total_B" AS B
  FROM 
  (
    SELECT
        "Account",
        SUM("Total3") AS "Total3",
        SUM("Total2") AS "Total2",
        SUM("Total1") AS "Total1",
        SUM("Total2") - SUM("Total3") AS "Total_A",
        SUM("Total1") - SUM("Total2") AS "Total_B"
    FROM (
        SELECT
            LEFT("Account", 5) AS "Account",
            SUM("Debit") - SUM("Credit") AS "Total3",
            0 AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2023-05-30'
        GROUP BY LEFT("Account", 5)
        UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            SUM("Debit") - SUM("Credit") AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2022-12-31'
        GROUP BY LEFT("Account", 5)
                UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            0 AS "Total2",
            SUM("Debit") - SUM("Credit") AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2021-12-31'
        GROUP BY LEFT("Account", 5)

        UNION ALL

        SELECT --TABLA 4 ACCOUNT
            '10287' AS "Account",
            0 AS "Saldo3_A",
            0 AS "Saldo2_A",
            0 AS "Saldo1_A"
            FROM
                DUMMY
    ) AS subquery
    WHERE "Account" = '10287'
    GROUP BY "Account"
    ORDER BY "Account"

  )

UNION ALL
SELECT
'A.1.3.' AS "#",
'Previsión para Inversiones' AS "CONCEPTO",
  "Total_A" AS A,
  "Total_B" AS B
  FROM 
  (
    SELECT
        "Account",
        SUM("Total3") AS "Total3",
        SUM("Total2") AS "Total2",
        SUM("Total1") AS "Total1",
        SUM("Total2") - SUM("Total3") AS "Total_A",
        SUM("Total1") - SUM("Total2") AS "Total_B"
    FROM (
        SELECT
            LEFT("Account", 5) AS "Account",
            SUM("Debit") - SUM("Credit") AS "Total3",
            0 AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2023-05-30'
        GROUP BY LEFT("Account", 5)

        UNION ALL
        
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            SUM("Debit") - SUM("Credit") AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2022-12-31'
        GROUP BY LEFT("Account", 5)

        UNION ALL

        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            0 AS "Total2",
            SUM("Debit") - SUM("Credit") AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2021-12-31'
        GROUP BY LEFT("Account", 5)

        UNION ALL

        SELECT --TABLA 4 ACCOUNT
            '10489' AS "Account",
            0 AS "Saldo3_A",
            0 AS "Saldo2_A",
            0 AS "Saldo1_A"
            FROM
                DUMMY
    ) AS subquery
    WHERE "Account" = '10489'
    GROUP BY "Account"
    ORDER BY "Account"

  )

UNION ALL
SELECT
'A.1.4.' AS "#",
'Amortización de cargos diferidos' AS "CONCEPTO",
  "Total_A" AS A,
  "Total_B" AS B
  FROM 
  (
    SELECT
        "Account",
        SUM("Total3") AS "Total3",
        SUM("Total2") AS "Total2",
        SUM("Total1") AS "Total1",
        SUM("Total2") - SUM("Total3") AS "Total_A",
        SUM("Total1") - SUM("Total2") AS "Total_B"
    FROM (
        SELECT
            LEFT("Account", 5) AS "Account",
            SUM("Debit") - SUM("Credit") AS "Total3",
            0 AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2023-05-30'
        GROUP BY LEFT("Account", 5)
        UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            SUM("Debit") - SUM("Credit") AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2022-12-31'
        GROUP BY LEFT("Account", 5)
                UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            0 AS "Total2",
            SUM("Debit") - SUM("Credit") AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2021-12-31'
        GROUP BY LEFT("Account", 5)

        UNION ALL

        SELECT --TABLA 4 ACCOUNT
            '10885' AS "Account",
            0 AS "Saldo3_A",
            0 AS "Saldo2_A",
            0 AS "Saldo1_A"
            FROM
                DUMMY
        
    ) AS subquery
    WHERE "Account" = '10885'
    GROUP BY "Account"
    ORDER BY "Account"

  )

UNION ALL
SELECT
'A.1.5.' AS "#",
'Reservas de riesgos en curso' AS "CONCEPTO",
  "Total_A" AS A,
  "Total_B" AS B
  FROM 
  (
    SELECT
        "Account",
        SUM("Total3") AS "Total3",
        SUM("Total2") AS "Total2",
        SUM("Total1") AS "Total1",
        SUM("Total3") - SUM("Total2") AS "Total_A",
        SUM("Total2") - SUM("Total1") AS "Total_B"
    FROM (
        SELECT
            LEFT("Account", 5) AS "Account",
            SUM("Debit") - SUM("Credit") AS "Total3",
            0 AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2023-05-30'
        GROUP BY LEFT("Account", 5)
        UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            SUM("Debit") - SUM("Credit") AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2022-12-31'
        GROUP BY LEFT("Account", 5)
                UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            0 AS "Total2",
            SUM("Debit") - SUM("Credit") AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2021-12-31'
        GROUP BY LEFT("Account", 5)

        UNION ALL

        SELECT --TABLA 4 ACCOUNT
            '20401' AS "Account",
            0 AS "Saldo3_A",
            0 AS "Saldo2_A",
            0 AS "Saldo1_A"
            FROM
                DUMMY
    ) AS subquery
    WHERE "Account" = '20401'
    GROUP BY "Account"
    ORDER BY "Account"

  )

UNION ALL
SELECT
'A.1.6.' AS "#",
'Reservas técnicas de siniestros' AS "CONCEPTO",
  "Total_A" AS A,
  "Total_B" AS B
  FROM 
  (
    SELECT
        SUM("Total3") AS "Total3",
        SUM("Total2") AS "Total2",
        SUM("Total1") AS "Total1",
        SUM("Total3") - SUM("Total2") AS "Total_A",
        SUM("Total2") - SUM("Total1") AS "Total_B"
    FROM (
        SELECT
            LEFT("Account", 5) AS "Account",
            SUM("Debit") - SUM("Credit") AS "Total3",
            0 AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2023-05-30'
        GROUP BY LEFT("Account", 5)
        UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            SUM("Debit") - SUM("Credit") AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2022-12-31'
        GROUP BY LEFT("Account", 5)
                UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            0 AS "Total2",
            SUM("Debit") - SUM("Credit") AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2021-12-31'
        GROUP BY LEFT("Account", 5)

                UNION ALL

        SELECT --TABLA 4 ACCOUNT
            '20501' AS "Account",
            0 AS "Saldo3_A",
            0 AS "Saldo2_A",
            0 AS "Saldo1_A"
            FROM
                DUMMY
    ) AS subquery
    WHERE "Account" IN ('20501', '20502', '20502')	
    GROUP BY LEFT("Account",1)

  )

UNION ALL
SELECT
'A.1.7.' AS "#",
'Previsión para prima legal sobre resultados' AS "CONCEPTO",
  0 AS A,
  0 AS B
  FROM DUMMY

UNION ALL
SELECT
'A.1.8.' AS "#",
'Previsión para incentivos sobre resultados' AS "CONCEPTO",
  0 AS A,
  0 AS B
  FROM DUMMY

UNION ALL
SELECT
'A.1.9.' AS "#",
'Previsión para aguinaldos' AS "CONCEPTO",
  "Total_A" AS A,
  "Total_B" AS B
  FROM 
  (
    SELECT
        SUM("Total3") AS "Total3",
        SUM("Total2") AS "Total2",
        SUM("Total1") AS "Total1",
        SUM("Total3") - SUM("Total2") AS "Total_A",
        SUM("Total2") - SUM("Total1") AS "Total_B"
    FROM (
        SELECT
            LEFT("Account", 5) AS "Account",
            SUM("Debit") - SUM("Credit") AS "Total3",
            0 AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2023-05-30'
        GROUP BY LEFT("Account", 5)
        UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            SUM("Debit") - SUM("Credit") AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2022-12-31'
        GROUP BY LEFT("Account", 5)
                UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            0 AS "Total2",
            SUM("Debit") - SUM("Credit") AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2021-12-31'
        GROUP BY LEFT("Account", 5)
    ) AS subquery
    WHERE "Account" IN ('20501')	
    GROUP BY LEFT("Account",1)

  )

UNION ALL
SELECT
'A.1.10.' AS "#",
'Previsión para Beneficios Sociales' AS "CONCEPTO",
  0 AS A,
  0 AS B
  FROM DUMMY

UNION ALL
SELECT
'A.1.11.' AS "#",
'Reserva legal' AS "CONCEPTO",
  "Total_A" AS A,
  "Total_B" AS B
  FROM 
  (
    SELECT
        "Account",
        SUM("Total3") AS "Total3",
        SUM("Total2") AS "Total2",
        SUM("Total1") AS "Total1",
        SUM("Total3") - SUM("Total2") AS "Total_A",
        SUM("Total2") - SUM("Total1") AS "Total_B"
    FROM (
        SELECT
            LEFT("Account", 5) AS "Account",
            SUM("Debit") - SUM("Credit") AS "Total3",
            0 AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2023-05-30'
        GROUP BY LEFT("Account", 5)
        UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            SUM("Debit") - SUM("Credit") AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2022-12-31'
        GROUP BY LEFT("Account", 5)
                UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            0 AS "Total2",
            SUM("Debit") - SUM("Credit") AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2021-12-31'
        GROUP BY LEFT("Account", 5)
    ) AS subquery
    WHERE "Account" = '30301'
    GROUP BY "Account"
    ORDER BY "Account"

  )
UNION ALL
SELECT
'A.1.12.' AS "#",
'Ajuste global del patrimonio' AS "CONCEPTO",
  "Total_A" AS A,
  "Total_B" AS B
  FROM 
  (
    SELECT
        "Account",
        SUM("Total3") AS "Total3",
        SUM("Total2") AS "Total2",
        SUM("Total1") AS "Total1",
        SUM("Total3") - SUM("Total2") AS "Total_A",
        SUM("Total2") - SUM("Total1") AS "Total_B"
    FROM (
        SELECT
            LEFT("Account", 5) AS "Account",
            SUM("Debit") - SUM("Credit") AS "Total3",
            0 AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2023-05-30'
        GROUP BY LEFT("Account", 5)
        UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            SUM("Debit") - SUM("Credit") AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2022-12-31'
        GROUP BY LEFT("Account", 5)
                UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            0 AS "Total2",
            SUM("Debit") - SUM("Credit") AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2021-12-31'
        GROUP BY LEFT("Account", 5)
    ) AS subquery
    WHERE "Account" = '30501'
    GROUP BY "Account"
    ORDER BY "Account"

  )

UNION ALL
SELECT
'A.1.13.' AS "#",
'Ajuste Resultados Acumulados' AS "CONCEPTO",
COALESCE("Total_A", 0) AS A,
COALESCE("Total_B", 0) AS B
  FROM 
  (
    SELECT
        T1."Account" AS "Account",
        SUM(T1."Saldo3_A") - SUM(T1."Saldo2_A") + SUM(T2."Saldo3_B") - SUM(T2."Saldo2_B") AS "Total_A",
        SUM(T1."Saldo2_A") - SUM(T1."Saldo1_A") + SUM(T2."Saldo2_B") - SUM(T2."Saldo1_B") AS "Total_B"
    FROM (
        SELECT --TABLA 1==============| Saldo3_A = 2023 | Saldo2_A = 2022 | Saldo1_A = 2021 | ==================
            -- Esta tabla agrupa por los 5 digitos Activo Pasivo y Patrimonio y trae el total en su año respectivo
            LEFT("Account", 5) AS "Account",
            SUM("Debit") - SUM("Credit") AS "Saldo3_A",
            0 AS "Saldo2_A",
            0 AS "Saldo1_A"
            FROM
                JDT1
            WHERE
                LEFT("Account", 1) IN (1, 2, 3) AND
                "RefDate" <= '2023-05-30' --Cambiar por input fhasta
            GROUP BY LEFT("Account", 5)
            
        UNION ALL
        
        SELECT --TABLA 2
            LEFT("Account", 5) AS "Account",
            0 AS "Saldo3_A",
            SUM("Debit") - SUM("Credit") AS "Saldo2_A",
            0 AS "Saldo1_A"
            FROM
                JDT1
            WHERE
                LEFT("Account", 1) IN (1, 2, 3) AND
                "RefDate" <= '2022-12-31' --Cambiar por input year -1
            GROUP BY LEFT("Account", 5)
        
        UNION ALL
        
        SELECT --TABLA 3
            LEFT("Account", 5) AS "Account",
            0 AS "Saldo3_A",
            0 AS "Saldo2_A",
            SUM("Debit") - SUM("Credit") AS "Saldo1_A"
            FROM
                JDT1
            WHERE
                LEFT("Account", 1) IN (1, 2, 3) AND
                "RefDate" <= '2021-12-31' --Cambiar por input year - 2
            GROUP BY LEFT("Account", 5)
        
        UNION ALL

        SELECT --TABLA 4 ACCOUNT
            '20802' AS "Account",
            0 AS "Saldo3_A",
            0 AS "Saldo2_A",
            0 AS "Saldo1_A"
            FROM
                DUMMY
    ) AS T1
    LEFT JOIN (

        SELECT
            '20802' AS "Account",
            SUM("Saldo3_B") AS "Saldo3_B",
            SUM("Saldo2_B") AS "Saldo2_B",
            SUM("Saldo1_B") AS "Saldo1_B"
        FROM (
            SELECT --TABLA 1==============| Saldo3_B = 2023 | Saldo2_B = 2022 | Saldo1_B = 2021 | ==================
                -- Esta tabla agrupa por los 5 digitos Activo Pasivo y Patrimonio y trae el total en su año respectivo
                LEFT("Account", 5) AS "Account",
                SUM("Debit") - SUM("Credit") AS "Saldo3_B",
                0 AS "Saldo2_B",
                0 AS "Saldo1_B"
                FROM
                    JDT1
                WHERE
                    LEFT("Account", 1) IN (1, 2, 3) AND
                    "RefDate" <= '2023-05-30' --Cambiar por input fhasta
                GROUP BY LEFT("Account", 5)
                
            UNION ALL
            
            SELECT --TABLA 2
                LEFT("Account", 5) AS "Account",
                0 AS "Saldo3_B",
                SUM("Debit") - SUM("Credit") AS "Saldo2_B",
                0 AS "Saldo1_B"
                FROM
                    JDT1
                WHERE
                    LEFT("Account", 1) IN (1, 2, 3) AND
                    "RefDate" <= '2022-12-31' --Cambiar por input year -1
                GROUP BY LEFT("Account", 5)
            
            UNION ALL
            
            SELECT --TABLA 3
                LEFT("Account", 5) AS "Account",
                0 AS "Saldo3_B",
                0 AS "Saldo2_B",
                SUM("Debit") - SUM("Credit") AS "Saldo1_B"
                FROM
                    JDT1
                WHERE
                    LEFT("Account", 1) IN (1, 2, 3) AND
                    "RefDate" <= '2021-12-31' --Cambiar por input year - 2
                GROUP BY LEFT("Account", 5)
        
        ) AS subquery
        WHERE "Account" = '20803' -- Cuenta contable 5 digitos BG
        GROUP BY "Account"

    ) T2 ON T1."Account" = T2."Account"
    
    WHERE T1."Account" = '20802' -- Cuenta contable 5 digitos BG
    GROUP BY T1."Account", T2."Account"

  )
UNION ALL
SELECT
'A.1.14.' AS "#",
'Ajuste de activos y pasivos no monetarios' AS "CONCEPTO",
  "Total_A" AS A,
  "Total_B" AS B
  FROM 
  (
    SELECT
        "Account",
        SUM("Total3") AS "Total3",
        SUM("Total2") AS "Total2",
        SUM("Total1") AS "Total1",
        SUM("Total3") - SUM("Total2") AS "Total_A",
        SUM("Total2") - SUM("Total1") AS "Total_B"
    FROM (
        SELECT
            LEFT("Account", 5) AS "Account",
            SUM("Debit") - SUM("Credit") AS "Total3",
            0 AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2023-05-30'
        GROUP BY LEFT("Account", 5)
        UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            SUM("Debit") - SUM("Credit") AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2022-12-31'
        GROUP BY LEFT("Account", 5)
                UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            0 AS "Total2",
            SUM("Debit") - SUM("Credit") AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2021-12-31'
        GROUP BY LEFT("Account", 5)
    ) AS subquery
    WHERE "Account" = '30601'
    GROUP BY "Account"
    ORDER BY "Account"

  )
UNION ALL
SELECT
'A.2' AS "#",
'Cambios en Activos y Pasivos' AS "CONCEPTO",
  0 AS A,
  0 AS B
  FROM DUMMY
UNION ALL
SELECT
'A.2.1.' AS "#",
'Exigible técnico' AS "CONCEPTO",
  "Total_A" AS A,
  "Total_B" AS B
  FROM 
  (
    SELECT
        SUM("Total3") AS "Total3",
        SUM("Total2") AS "Total2",
        SUM("Total1") AS "Total1",
        SUM("Total2") - SUM("Total3") AS "Total_A",
        SUM("Total1") - SUM("Total2") AS "Total_B"
    FROM (
        SELECT
            LEFT("Account", 5) AS "Account",
            SUM("Debit") - SUM("Credit") AS "Total3",
            0 AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2023-05-30'
        GROUP BY LEFT("Account", 5)
        UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            SUM("Debit") - SUM("Credit") AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2022-12-31'
        GROUP BY LEFT("Account", 5)
                UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            0 AS "Total2",
            SUM("Debit") - SUM("Credit") AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2021-12-31'
        GROUP BY LEFT("Account", 5)
        
        UNION ALL

        SELECT --TABLA 4 ACCOUNT
            '10885' AS "Account",
            0 AS "Saldo3_A",
            0 AS "Saldo2_A",
            0 AS "Saldo1_A"
            FROM
                DUMMY
    ) AS subquery
    WHERE "Account" IN ('10885', '10201', '10208', '10210', '10211', '10215', '10222', '10223')
    GROUP BY LEFT("Account", 1)

  )
UNION ALL
SELECT
'A.2.2.' AS "#",
'Exigible administrativo' AS "CONCEPTO",
  "Total_A" AS A,
  "Total_B" AS B
  FROM 
  (
    SELECT
        "Account",
        SUM("Total3") AS "Total3",
        SUM("Total2") AS "Total2",
        SUM("Total1") AS "Total1",
        SUM("Total2") - SUM("Total3") AS "Total_A",
        SUM("Total1") - SUM("Total2") AS "Total_B"
    FROM (
        SELECT
            LEFT("Account", 3) AS "Account",
            SUM("Debit") - SUM("Credit") AS "Total3",
            0 AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2023-05-30'
        GROUP BY LEFT("Account", 3)
        UNION ALL
        SELECT
            LEFT("Account", 3) AS "Account",
            0 AS "Total3",
            SUM("Debit") - SUM("Credit") AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2022-12-31'
        GROUP BY LEFT("Account", 3)
                UNION ALL
        SELECT
            LEFT("Account", 3) AS "Account",
            0 AS "Total3",
            0 AS "Total2",
            SUM("Debit") - SUM("Credit") AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2021-12-31'
        GROUP BY LEFT("Account", 3)
         
        UNION ALL

        SELECT --TABLA 4 ACCOUNT
            '103' AS "Account",
            0 AS "Saldo3_A",
            0 AS "Saldo2_A",
            0 AS "Saldo1_A"
            FROM
                DUMMY
    ) AS subquery
    WHERE "Account" = '103'
    GROUP BY "Account"
    ORDER BY "Account"

  )
UNION ALL
SELECT
'A.2.3.' AS "#",
'Gastos pagados por anticipado' AS "CONCEPTO",
"Total_A" AS A,
"Total_B" AS B
  FROM 
  (
    SELECT
        SUM("Total2") - SUM("Total3") AS "Total_A",
        SUM("Total1") - SUM("Total2") AS "Total_B"
    FROM (
        SELECT
            LEFT("Account", 5) AS "Account",
            SUM("Debit") - SUM("Credit") AS "Total3",
            0 AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2023-05-30'
        GROUP BY LEFT("Account", 5)
        UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            SUM("Debit") - SUM("Credit") AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2022-12-31'
        GROUP BY LEFT("Account", 5)
                UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            0 AS "Total2",
            SUM("Debit") - SUM("Credit") AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2021-12-31'
        GROUP BY LEFT("Account", 5)
        
        UNION ALL

        SELECT --TABLA 4 ACCOUNT
            '10701' AS "Account",
            0 AS "Saldo3_A",
            0 AS "Saldo2_A",
            0 AS "Saldo1_A"
            FROM
                DUMMY
    ) AS subquery
    WHERE "Account" IN ('10701', '10702')
    GROUP BY LEFT("Account",1)

  )
UNION ALL
SELECT
'A.2.4.' AS "#",
'Activo diferido' AS "CONCEPTO",
"Total_A" AS A,
"Total_B" AS B
  FROM 
  (
    SELECT
        SUM("Total2") - SUM("Total3") AS "Total_A",
        SUM("Total1") - SUM("Total2") AS "Total_B"
    FROM (
        SELECT
            LEFT("Account", 5) AS "Account",
            SUM("Debit") - SUM("Credit") AS "Total3",
            0 AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2023-05-30'
        GROUP BY LEFT("Account", 5)
        UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            SUM("Debit") - SUM("Credit") AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2022-12-31'
        GROUP BY LEFT("Account", 5)
                UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            0 AS "Total2",
            SUM("Debit") - SUM("Credit") AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2021-12-31'
        GROUP BY LEFT("Account", 5)

        UNION ALL

        SELECT --TABLA 4 ACCOUNT
            '10801' AS "Account",
            0 AS "Saldo3_A",
            0 AS "Saldo2_A",
            0 AS "Saldo1_A"
            FROM
                DUMMY
    ) AS subquery
    WHERE "Account" IN ('10801', '10804')
    GROUP BY LEFT("Account",1)

  )
UNION ALL
SELECT
'A.2.5.' AS "#",
'Obligaciones técnicas' AS "CONCEPTO",
  "Total_A" AS A,
  "Total_B" AS B
  FROM 
  (
    SELECT
        "Account",
        SUM("Total3") AS "Total3",
        SUM("Total2") AS "Total2",
        SUM("Total1") AS "Total1",
        SUM("Total3") - SUM("Total2") AS "Total_A",
        SUM("Total2") - SUM("Total1") AS "Total_B"
    FROM (
        SELECT
            LEFT("Account", 3) AS "Account",
            SUM("Debit") - SUM("Credit") AS "Total3",
            0 AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2023-05-30'
        GROUP BY LEFT("Account", 3)
        UNION ALL
        SELECT
            LEFT("Account", 3) AS "Account",
            0 AS "Total3",
            SUM("Debit") - SUM("Credit") AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2022-12-31'
        GROUP BY LEFT("Account", 3)
                UNION ALL
        SELECT
            LEFT("Account", 3) AS "Account",
            0 AS "Total3",
            0 AS "Total2",
            SUM("Debit") - SUM("Credit") AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2021-12-31'
        GROUP BY LEFT("Account", 3)

        UNION ALL

        SELECT --TABLA 4 ACCOUNT
            '202' AS "Account",
            0 AS "Saldo3_A",
            0 AS "Saldo2_A",
            0 AS "Saldo1_A"
            FROM
                DUMMY
    ) AS subquery
    WHERE "Account" = '202'
    GROUP BY "Account"
    ORDER BY "Account"

  )
UNION ALL
SELECT
'A.2.6.' AS "#",
'Obligaciones administrativas' AS "CONCEPTO",
  "Total_A" AS A,
  "Total_B" AS B
  FROM 
  (
    SELECT
        "Account",
        SUM("Total3") AS "Total3",
        SUM("Total2") AS "Total2",
        SUM("Total1") AS "Total1",
        SUM("Total3") - SUM("Total2") AS "Total_A",
        SUM("Total2") - SUM("Total1") AS "Total_B"
    FROM (
        SELECT
            LEFT("Account", 3) AS "Account",
            SUM("Debit") - SUM("Credit") AS "Total3",
            0 AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2023-05-30'
        GROUP BY LEFT("Account", 3)
        UNION ALL
        SELECT
            LEFT("Account", 3) AS "Account",
            0 AS "Total3",
            SUM("Debit") - SUM("Credit") AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2022-12-31'
        GROUP BY LEFT("Account", 3)
                UNION ALL
        SELECT
            LEFT("Account", 3) AS "Account",
            0 AS "Total3",
            0 AS "Total2",
            SUM("Debit") - SUM("Credit") AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2021-12-31'
        GROUP BY LEFT("Account", 3)

        UNION ALL

        SELECT --TABLA 4 ACCOUNT
            '203' AS "Account",
            0 AS "Saldo3_A",
            0 AS "Saldo2_A",
            0 AS "Saldo1_A"
            FROM
                DUMMY
    ) AS subquery
    WHERE "Account" = '203'
    GROUP BY "Account"
    ORDER BY "Account"

  )
UNION ALL
SELECT
'A.2.7.' AS "#",
'Incremento en adelantos financieros' AS "CONCEPTO",
  "Total_A" AS A,
  "Total_B" AS B
  FROM
  (
    SELECT
        "Account",
        SUM("Total3") AS "Total3",
        SUM("Total2") AS "Total2",
        SUM("Total1") AS "Total1",
        SUM("Total3") - SUM("Total2") AS "Total_A",
        SUM("Total2") - SUM("Total1") AS "Total_B"
    FROM (
        SELECT
            LEFT("Account", 5) AS "Account",
            SUM("Debit") - SUM("Credit") AS "Total3",
            0 AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2023-05-30'
        GROUP BY LEFT("Account", 5)
        UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            SUM("Debit") - SUM("Credit") AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2022-12-31'
        GROUP BY LEFT("Account", 5)
                UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            0 AS "Total2",
            SUM("Debit") - SUM("Credit") AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2021-12-31'
        GROUP BY LEFT("Account", 5)

        UNION ALL

        SELECT --TABLA 4 ACCOUNT
            '20101' AS "Account",
            0 AS "Saldo3_A",
            0 AS "Saldo2_A",
            0 AS "Saldo1_A"
            FROM
                DUMMY
    ) AS subquery
    WHERE "Account" = '20101'
    GROUP BY "Account"
    ORDER BY "Account"

  )
UNION ALL
SELECT
'A.2.8.' AS "#",
'Pasivos diferidos' AS "CONCEPTO",
  "Total_A" AS A,
  "Total_B" AS B
  FROM
  (
    SELECT
        SUM("Total3") AS "Total3",
        SUM("Total2") AS "Total2",
        SUM("Total1") AS "Total1",
        SUM("Total3") - SUM("Total2") AS "Total_A",
        SUM("Total2") - SUM("Total1") AS "Total_B"
    FROM (
        SELECT
            LEFT("Account", 5) AS "Account",
            SUM("Debit") - SUM("Credit") AS "Total3",
            0 AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2023-05-30'
        GROUP BY LEFT("Account", 5)
        UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            SUM("Debit") - SUM("Credit") AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2022-12-31'
        GROUP BY LEFT("Account", 5)
                UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            0 AS "Total2",
            SUM("Debit") - SUM("Credit") AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2021-12-31'
        GROUP BY LEFT("Account", 5)

        UNION ALL

        SELECT --TABLA 4 ACCOUNT
            '20802' AS "Account",
            0 AS "Saldo3_A",
            0 AS "Saldo2_A",
            0 AS "Saldo1_A"
            FROM
                DUMMY
    ) AS subquery
    WHERE "Account" IN ('20802', '20803')
    GROUP BY LEFT("Account",1)

  )
UNION ALL
SELECT
'' AS "#",
'Total Fondos por Actividades Operativas' AS "CONCEPTO",
0 AS A,
0 AS B
FROM DUMMY
UNION ALL
SELECT
'B' AS "#",
'FLUJO DE FONDOS POR ACTIVIDADES DE INVERSION' AS "CONCEPTO",
0 AS A,
0 AS B
FROM DUMMY
UNION ALL
SELECT
'B.1' AS "#",
'Inversión en títulos valores' AS "CONCEPTO",
  "Total_A" AS A,
  "Total_B" AS B
  FROM
  (
    SELECT
        "Account",
        SUM("Total3") AS "Total3",
        SUM("Total2") AS "Total2",
        SUM("Total1") AS "Total1",
        SUM("Total2") - SUM("Total3") AS "Total_A",
        SUM("Total1") - SUM("Total2") AS "Total_B"
    FROM (
        SELECT
            LEFT("Account", 5) AS "Account",
            SUM("Debit") - SUM("Credit") AS "Total3",
            0 AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2023-05-30'
        GROUP BY LEFT("Account", 5)
        UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            SUM("Debit") - SUM("Credit") AS "Total2",
            0 AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2022-12-31'
        GROUP BY LEFT("Account", 5)
                UNION ALL
        SELECT
            LEFT("Account", 5) AS "Account",
            0 AS "Total3",
            0 AS "Total2",
            SUM("Debit") - SUM("Credit") AS "Total1"
        FROM
            JDT1
        WHERE
            LEFT("Account", 1) IN (1, 2, 3) AND
            "RefDate" <= '2021-12-31'
        GROUP BY LEFT("Account", 5)
        
        UNION ALL

        SELECT --TABLA 4 ACCOUNT
            '10401' AS "Account",
            0 AS "Saldo3_A",
            0 AS "Saldo2_A",
            0 AS "Saldo1_A"
            FROM
                DUMMY
    ) AS subquery
    WHERE "Account" = '10401'
    GROUP BY "Account"
    ORDER BY "Account"

  )
UNION ALL
SELECT
'B.2' AS "#",
    'Inversión en Bienes Inmuebles' AS "CONCEPTO",
    "Total_A" AS A,
    "Total_B" AS B
    FROM
    (
        SELECT
            "Account",
            SUM("Total3") AS "Total3",
            SUM("Total2") AS "Total2",
            SUM("Total1") AS "Total1",
            SUM("Total2") - SUM("Total3") AS "Total_A",
            SUM("Total1") - SUM("Total2") AS "Total_B"
        FROM (
            SELECT
                LEFT("Account", 5) AS "Account",
                SUM("Debit") - SUM("Credit") AS "Total3",
                0 AS "Total2",
                0 AS "Total1"
            FROM
                JDT1
            WHERE
                LEFT("Account", 1) IN (1, 2, 3) AND
                "RefDate" <= '2023-05-30'
            GROUP BY LEFT("Account", 5)
            UNION ALL
            SELECT
                LEFT("Account", 5) AS "Account",
                0 AS "Total3",
                SUM("Debit") - SUM("Credit") AS "Total2",
                0 AS "Total1"
            FROM
                JDT1
            WHERE
                LEFT("Account", 1) IN (1, 2, 3) AND
                "RefDate" <= '2022-12-31'
            GROUP BY LEFT("Account", 5)
                    UNION ALL
            SELECT
                LEFT("Account", 5) AS "Account",
                0 AS "Total3",
                0 AS "Total2",
                SUM("Debit") - SUM("Credit") AS "Total1"
            FROM
                JDT1
            WHERE
                LEFT("Account", 1) IN (1, 2, 3) AND
                "RefDate" <= '2021-12-31'
            GROUP BY LEFT("Account", 5)
            
            UNION ALL

            SELECT --TABLA 4 ACCOUNT
                '10402' AS "Account",
                0 AS "Saldo3_A",
                0 AS "Saldo2_A",
                0 AS "Saldo1_A"
                FROM
                    DUMMY
        ) AS subquery
        WHERE "Account" = '10402'
        GROUP BY "Account"
        ORDER BY "Account"

    )
    UNION ALL
SELECT
'B.3' AS "#",
    'Adquisición de equipo y bienes de uso' AS "CONCEPTO",
    "Total_A" AS A,
    "Total_B" AS B
    FROM 
    (
        SELECT
            SUM("Total3") AS "Total3",
            SUM("Total2") AS "Total2",
            SUM("Total1") AS "Total1",
            SUM("Total2") - SUM("Total3") AS "Total_A",
            SUM("Total1") - SUM("Total2") AS "Total_B"
        FROM (
            SELECT
                LEFT("Account", 5) AS "Account",
                SUM("Debit") - SUM("Credit") AS "Total3",
                0 AS "Total2",
                0 AS "Total1"
            FROM
                JDT1
            WHERE
                LEFT("Account", 1) IN (1, 2, 3) AND
                "RefDate" <= '2023-05-30'
            GROUP BY LEFT("Account", 5)
            UNION ALL
            SELECT
                LEFT("Account", 5) AS "Account",
                0 AS "Total3",
                SUM("Debit") - SUM("Credit") AS "Total2",
                0 AS "Total1"
            FROM
                JDT1
            WHERE
                LEFT("Account", 1) IN (1, 2, 3) AND
                "RefDate" <= '2022-12-31'
            GROUP BY LEFT("Account", 5)
                    UNION ALL
            SELECT
                LEFT("Account", 5) AS "Account",
                0 AS "Total3",
                0 AS "Total2",
                SUM("Debit") - SUM("Credit") AS "Total1"
            FROM
                JDT1
            WHERE
                LEFT("Account", 1) IN (1, 2, 3) AND
                "RefDate" <= '2021-12-31'
            GROUP BY LEFT("Account", 5)
            
            UNION ALL

            SELECT --TABLA 4 ACCOUNT
                '10501' AS "Account",
                0 AS "Saldo3_A",
                0 AS "Saldo2_A",
                0 AS "Saldo1_A"
                FROM
                    DUMMY
        ) AS subquery
        WHERE "Account" IN ('10501', '10502', '10503', '10504', '10505')
        GROUP BY LEFT("Account", 1)

    )
    UNION ALL
SELECT
'' AS "#",
    'Total Fondos por Actividades de Inversión' AS "CONCEPTO",
    0 AS A,
    0 AS B
    FROM DUMMY
    UNION ALL
SELECT
'C' AS "#",
    'FLUJO DE FONDOS POR ACTIVIDADES DE FINANCIAMIENTO' AS "CONCEPTO",
    0 AS A,
    0 AS B
    FROM DUMMY
    UNION ALL
SELECT
'C.1' AS "#",
    'Aporte de capital social' AS "CONCEPTO",
    "Total_A" AS A,
    "Total_B" AS B
    FROM
    (
        SELECT
            "Account",
            SUM("Total3") AS "Total3",
            SUM("Total2") AS "Total2",
            SUM("Total1") AS "Total1",
            SUM("Total3") - SUM("Total2") AS "Total_A",
            SUM("Total2") - SUM("Total1") AS "Total_B"
        FROM (
            SELECT
                LEFT("Account", 5) AS "Account",
                SUM("Debit") - SUM("Credit") AS "Total3",
                0 AS "Total2",
                0 AS "Total1"
            FROM
                JDT1
            WHERE
                LEFT("Account", 1) IN (1, 2, 3) AND
                "RefDate" <= '2023-05-30'
            GROUP BY LEFT("Account", 5)
            UNION ALL
            SELECT
                LEFT("Account", 5) AS "Account",
                0 AS "Total3",
                SUM("Debit") - SUM("Credit") AS "Total2",
                0 AS "Total1"
            FROM
                JDT1
            WHERE
                LEFT("Account", 1) IN (1, 2, 3) AND
                "RefDate" <= '2022-12-31'
            GROUP BY LEFT("Account", 5)
                    UNION ALL
            SELECT
                LEFT("Account", 5) AS "Account",
                0 AS "Total3",
                0 AS "Total2",
                SUM("Debit") - SUM("Credit") AS "Total1"
            FROM
                JDT1
            WHERE
                LEFT("Account", 1) IN (1, 2, 3) AND
                "RefDate" <= '2021-12-31'
            GROUP BY LEFT("Account", 5)
            
            UNION ALL

            SELECT --TABLA 4 ACCOUNT
                '30101' AS "Account",
                0 AS "Saldo3_A",
                0 AS "Saldo2_A",
                0 AS "Saldo1_A"
                FROM
                    DUMMY
        ) AS subquery
        WHERE "Account" = '30101'
        GROUP BY "Account"
        ORDER BY "Account"

    )
    UNION ALL
SELECT  
'C.2' AS "#",
    'Aportes de los accionistas para aumentos de capital' AS "CONCEPTO",
    "Total_A" AS A,
    "Total_B" AS B
    FROM
    (
        SELECT
            "Account",
            SUM("Total3") AS "Total3",
            SUM("Total2") AS "Total2",
            SUM("Total1") AS "Total1",
            SUM("Total3") - SUM("Total2") AS "Total_A",
            SUM("Total2") - SUM("Total1") AS "Total_B"
        FROM (
            SELECT
                LEFT("Account", 5) AS "Account",
                SUM("Debit") - SUM("Credit") AS "Total3",
                0 AS "Total2",
                0 AS "Total1"
            FROM
                JDT1
            WHERE
                LEFT("Account", 1) IN (1, 2, 3) AND
                "RefDate" <= '2023-05-30'
            GROUP BY LEFT("Account", 5)
            UNION ALL
            SELECT
                LEFT("Account", 5) AS "Account",
                0 AS "Total3",
                SUM("Debit") - SUM("Credit") AS "Total2",
                0 AS "Total1"
            FROM
                JDT1
            WHERE
                LEFT("Account", 1) IN (1, 2, 3) AND
                "RefDate" <= '2022-12-31'
            GROUP BY LEFT("Account", 5)
                    UNION ALL
            SELECT
                LEFT("Account", 5) AS "Account",
                0 AS "Total3",
                0 AS "Total2",
                SUM("Debit") - SUM("Credit") AS "Total1"
            FROM
                JDT1
            WHERE
                LEFT("Account", 1) IN (1, 2, 3) AND
                "RefDate" <= '2021-12-31'
            GROUP BY LEFT("Account", 5)
            
            UNION ALL

            SELECT --TABLA 4 ACCOUNT
                '30202' AS "Account",
                0 AS "Saldo3_A",
                0 AS "Saldo2_A",
                0 AS "Saldo1_A"
                FROM
                    DUMMY
        ) AS subquery
        WHERE "Account" = '30202'
        GROUP BY "Account"
        ORDER BY "Account"

    )
    UNION ALL
SELECT
'C.3' AS "#",
    'Pago de Dividendos' AS "CONCEPTO",
    "Total_A" AS A,
    "Total_B" AS B
    FROM
    (
        SELECT
            "Account",
            SUM("Total3") AS "Total3",
            SUM("Total2") AS "Total2",
            SUM("Total1") AS "Total1",
            -1 * SUM("Total3") AS "Total_A",
            -1 * SUM("Total2") AS "Total_B"
        FROM (
            SELECT
                LEFT("Account", 5) AS "Account",
                SUM("Debit") - SUM("Credit") AS "Total3",
                0 AS "Total2",
                0 AS "Total1"
            FROM
                JDT1
            WHERE
                LEFT("Account", 1) IN (1, 2, 3) AND
                "RefDate" <= '2023-05-30'
            GROUP BY LEFT("Account", 5)
            UNION ALL
            SELECT
                LEFT("Account", 5) AS "Account",
                0 AS "Total3",
                SUM("Debit") - SUM("Credit") AS "Total2",
                0 AS "Total1"
            FROM
                JDT1
            WHERE
                LEFT("Account", 1) IN (1, 2, 3) AND
                "RefDate" <= '2022-12-31'
            GROUP BY LEFT("Account", 5)
                    UNION ALL
            SELECT
                LEFT("Account", 5) AS "Account",
                0 AS "Total3",
                0 AS "Total2",
                SUM("Debit") - SUM("Credit") AS "Total1"
            FROM
                JDT1
            WHERE
                LEFT("Account", 1) IN (1, 2, 3) AND
                "RefDate" <= '2021-12-31'
            GROUP BY LEFT("Account", 5)
            
            UNION ALL

            SELECT --TABLA 4 ACCOUNT
                '20305' AS "Account",
                0 AS "Saldo3_A",
                0 AS "Saldo2_A",
                0 AS "Saldo1_A"
                FROM
                    DUMMY
        ) AS subquery
        WHERE "Account" = '20305'
        GROUP BY "Account"
        ORDER BY "Account"

    )
    UNION ALL
SELECT
'' AS "#",
    'Total Fondos por Actividades de Financiamiento' AS "CONCEPTO",
    0 AS A,
    0 AS B
    FROM DUMMY
    UNION ALL
SELECT
'' AS "#",
    'INCREMENTO (DISMINUCION) NETO DE FONDOS' AS "CONCEPTO",
    0 AS A,
    0 AS B
    FROM DUMMY
    UNION ALL
SELECT
'' AS "#",
    'DISPONIB. REEXPRESADA AL INICIO DE LA GEST.' AS "CONCEPTO",
    0 AS A,
    0 AS B
    FROM DUMMY
    UNION ALL
SELECT
'' AS "#",
    'DISPONIBILIDAD AL CIERRE DE LA GESTIÓN' AS "CONCEPTO",
    0 AS A,
    0 AS B
    FROM DUMMY;
END;