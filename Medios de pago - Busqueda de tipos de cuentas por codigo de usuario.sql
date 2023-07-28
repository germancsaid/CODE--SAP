/*======  Esta busqueda trae las cuentas de caja donde coincida la sucursal del usuario  =========*/

-- German C Tardio

SELECT "AcctCode"
FROM (
    SELECT T0."AcctCode", T0."AcctName",
    CASE 
        WHEN T0."AcctName" LIKE '%SANTA CRUZ%' THEN 'SCZ'
        WHEN T0."AcctName" LIKE '%COCHABAMBA%' THEN 'CBB' 
        WHEN T0."AcctName" LIKE '%LA PAZ%' THEN 'LPZ'
        WHEN T0."AcctName" LIKE '%SUCRE%' THEN 'SUC'
        WHEN T0."AcctName" LIKE '%TARIJA%' THEN 'TAR'   
        ELSE ''
    END AS "Departamento"
    FROM OACT T0 
    WHERE (LEFT(T0."AcctCode", 5) = '11101' OR LEFT(T0."AcctCode", 5) = '11102')
        AND (T0."AcctName" LIKE '%SANTA CRUZ%' 
        OR T0."AcctName" LIKE '%COCHABAMBA%'
        OR T0."AcctName" LIKE '%LA PAZ%'
        OR T0."AcctName" LIKE '%SUCRE%'
        OR T0."AcctName" LIKE '%TARIJA%')
) AS s
WHERE "Departamento" = (
    SELECT "Departamento"
    FROM (
        SELECT 
        CASE 
            WHEN T0."USER_CODE" LIKE '%SCZ%' THEN 'SCZ'
            WHEN T0."USER_CODE" LIKE '%CBB%' THEN 'CBB' 
            WHEN T0."USER_CODE" LIKE '%LPZ%' THEN 'LPZ'
            WHEN T0."USER_CODE" LIKE '%SUC%' THEN 'SUC'
            WHEN T0."USER_CODE" LIKE '%TAR%' THEN 'TAR'   
            ELSE ''
        END AS "Departamento",
        T0.USER_CODE
        FROM OUSR T0
        WHERE INTERNAL_K = $[USER]
    ) AS s2
);