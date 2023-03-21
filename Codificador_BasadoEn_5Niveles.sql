/*=================== CODIFICACION POR NIVELES ============================*/
--Codificator

SELECT CONCAT(SUBSTR_BEFORE($[OITM."U_Nivel4"], ' - '),'.000') AS "Item Code" 
FROM DUMMY

-- Nivel 1
SELECT CONCAT(CONCAT("U_Abreviatura",' - '), "U_NameLevel") AS "Nivel 1"
FROM "IB_MEDICAL"."@ITEM_LEVELS" T0
WHERE 1 = 1

-- Nivel 2
SELECT CONCAT(CONCAT("U_Abreviatura",' - '), "U_NameLevel") AS "Nivel 2"
FROM "IB_MEDICAL"."@ITEM_LEVELS" T0 
WHERE "U_Padre" = (SELECT "Code" 
FROM "@ITEM_LEVELS"
WHERE "U_Abreviatura" = SUBSTR_BEFORE($[OITM.U_Nivel1],' - '))

-- Nivel 3
SELECT CONCAT(CONCAT("U_Abreviatura",' - '), "U_NameLevel") AS "Nivel 3"
FROM "IB_MEDICAL"."@ITEM_LEVELS" T0 
WHERE "U_Padre" = (SELECT "Code" 
FROM "@ITEM_LEVELS"
WHERE "U_Abreviatura" = SUBSTR_BEFORE($[OITM.U_Nivel2],' - '))

-- Nivel 4
SELECT CONCAT(CONCAT("U_Abreviatura",' - '), "U_NameLevel") AS "Nivel 4"
FROM "IB_MEDICAL"."@ITEM_LEVELS" T0 
WHERE "U_Padre" = (SELECT "Code" 
FROM "@ITEM_LEVELS"
WHERE "U_Abreviatura" = SUBSTR_BEFORE($[OITM.U_Nivel3],' - '))

-- Nivel 5
SELECT CONCAT(CONCAT("U_Abreviatura",' - '), "U_NameLevel") AS "Nivel 5"
FROM "IB_MEDICAL"."@ITEM_LEVELS" T0 
WHERE "U_Padre" = (SELECT "Code" 
FROM "@ITEM_LEVELS"
WHERE "U_Abreviatura" = SUBSTR_BEFORE($[OITM.U_Nivel4],' - '))