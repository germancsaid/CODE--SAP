CREATE PROCEDURE ACB_EERR_EDV (in fdesde date, in fhasta date, in moneda varchar(3))
AS
BEGIN
-- APZ: ESTADO DE RESULTADOS
-- GTP: AJUSTES 2023
-- call ACB_EERR
-- ZENON
	
	declare tc decimal(10,2);

    --SELECT DE TC
	SELECT COUNT("Rate") INTO tc 
        FROM ORTT 
        WHERE "Currency" = 'USD' 
        AND "RateDate" = current_date
        AND "Rate" > 0;

	IF tc > 0 
    THEN
		SELECT
            CASE
                WHEN IFNULL("Rate",0) > 0 THEN "Rate" 
                ELSE 0 
                END INTO tc
        FROM ORTT 
        WHERE "Currency" = 'USD' 
        AND "RateDate" = current_date;
	END IF;

    --SELECT EERR
	
	SELECT

        LEFT(T0."AcctCode",1) || '' Nivel1Codigo,
		CASE LEFT(T0."AcctCode",1)
            WHEN '4' THEN '4'
            WHEN '5' THEN '5'
            ELSE LEFT(T0."AcctCode",1)
            END || LEFT(T0."AcctCode",1) Nivel1,
		CASE LEFT(T0."AcctCode",1) 
            WHEN '4' THEN 'INGRESOS'
            WHEN '5' THEN 'EGRESOS'
            --WHEN '6' THEN 'CUENTAS DE ORDEN DEUDORA'
            --WHEN '7' THEN 'CUENTAS DE ORDEN ACREEDORA'
            --WHEN '8' THEN 'Otros Gastos'
            END Descripcion_N1,
		LEFT(T0."AcctCode",3)||'' Nivel2,
       (SELECT "AcctName" 
            FROM OACT 
            WHERE "AcctCode" = LEFT(T0."AcctCode",3) || '') Descripcion_N2,
		LEFT(T0."AcctCode",6)Nivel3,
       (SELECT "AcctName" 
            FROM OACT 
            WHERE "AcctCode" = LEFT(T0."AcctCode",6)) Descripcion_N3,
		LEFT(T0."AcctCode",8) Nivel4,
       (SELECT "AcctName" 
            FROM OACT 
            WHERE "AcctCode" = LEFT(T0."AcctCode",8)) Descripcion_N4,
		T0."FatherNum" Nivel5,
       (SELECT "AcctName" 
            FROM OACT 
            WHERE "AcctCode" = T0."FatherNum") Descripcion_N5,
		T0."AcctCode", T0."AcctName",
		CASE IFNULL(T3."PrcCode",'') 
            WHEN '' THEN 'Sin asignar'
            ELSE T3."PrcCode"
            END AS CC,
        '' AS Dimension,
		CASE 
            WHEN moneda = 'USD' AND LEFT(T0."AcctCode",1) = '5' THEN IFNULL(sum((T1."SYSCred" - T1."SYSDeb") * IFNULL((T3."PrcAmount" / T3."OcrTotal"),1)),0)
            WHEN moneda = 'BS' AND LEFT(T0."AcctCode",1) = '5' THEN IFNULL(sum((T1."Credit" - T1."Debit") * IFNULL((T3."PrcAmount" / T3."OcrTotal"),1)),0)
            WHEN moneda = 'USD' AND LEFT(T0."AcctCode",1) = '4' THEN IFNULL(sum((T1."SYSCred" + T1."SYSDeb") * IFNULL((T3."PrcAmount" / T3."OcrTotal"),1)),0)
            WHEN moneda = 'BS' AND LEFT(T0."AcctCode",1) = '4' THEN IFNULL(sum((T1."Credit" + T1."Debit") * IFNULL((T3."PrcAmount" / T3."OcrTotal"),1)),0)
            
            END Saldo,
        tc AS tc

	FROM OACT T0 
    LEFT JOIN JDT1 T1 ON T0."AcctCode" = T1."Account" AND T1."RefDate" between IFNULL(fdesde,'19000101') AND IFNULL(fhasta, current_date)
	LEFT JOIN OCR1 T3 ON T3."OcrCode"= T1."ProfitCode"
	WHERE T0."Postable"='Y' 
    AND LEFT(T0."AcctCode",1) IN ('4','5')--'5'
    AND IFNULL((T1."Credit"-T1."Debit"),0) <> 0
  	GROUP BY T0."AcctCode",T0."FatherNum",T0."AcctName",T1."ProfitCode",T3."PrcCode"
	ORDER BY T0."AcctCode" DESC;

END;