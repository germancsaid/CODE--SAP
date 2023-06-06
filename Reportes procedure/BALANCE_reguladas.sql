CREATE FUNCTION "F_BALANCE_VERTICAL" (FECHAINI DATE, FECHAFIN DATE)
--Select * from "F_BALANCE_VERTICAL" ('20230101', '20230228') 
--1,2,3,6,7
RETURNS TABLE 
(
"query" int,
"nivel" int,
"tipo" int,
"orden" int,
"ordenG" int,
"Codigo_de_cuenta" varchar (25),
"Nombre de cuenta" varchar (100),
"Documento" int,
"tipo documento" int,
"Fecha Contabilizacion" date,
"identificador_linea" int,
"Saldo BS" numeric(19,4),
"Saldo USD" numeric(19,2),
"TC" NUMERIC(19,4)
) 

LANGUAGE SQLSCRIPT AS

BEGIN
RETURN
----nivel 6 / debitos -  creditos / activos
	SELECT	DISTINCT 2 "query", 
			6 "nivel",
			0 "tipo",
			1 "orden",
			(CASE LEFT (T2."FormatCode",1) WHEN '1' THEN 1
			WHEN '7' THEN 7--2 
			ELSE 0 END )"ordenG",
			T2."FormatCode"		"Codigo_de_cuenta",
			T2."AcctName"		"Nombre de cuenta", 
			T1."TransId"		"Documento",
			T0."TransType"		"tipo documento",
			T0."RefDate"		"Fecha Contabilizacion",
			T1."Line_ID"		"identificador_linea",
			(T1."Debit"-T1."Credit")"Saldo BS",
			(T1."SYSDeb"-T1."SYSCred") 	"Saldo USD",
			IFNULL((SELECT "Rate" FROM ORTT WHERE "Currency"='USD' and "RateDate"=current_date),0)"TC"
			
	FROM OJDT T0  INNER JOIN JDT1 T1 ON T0."TransId" = T1."TransId" INNER JOIN OACT T2 ON T1."Account" = T2."AcctCode" 
	LEFT OUTER JOIN OJDT TX On T0."TransId" = TX."StornoToTr", "TIPOCAMBIO_R" (:FECHAFIN)
	WHERE 
	IFNULL(T0."StornoToTr", '0') = '0' 
	AND (IFNULL( TX."RefDate",'') = '' OR IFNULL( TX."RefDate",'') > :FECHAFIN)
	AND T2."GroupMask" IN (1) --activos, - balance
	AND T2."AcctName" <> 'INACTIVO'
	AND T0."RefDate" BETWEEN :FECHAINI AND :FECHAFIN ---NIVEL5_ACTIVOS
	UNION
----nivel 6 / creditos - debitos / pasivos---------------------

	SELECT	DISTINCT 2 "query", 
			6 "nivel",
			0 "tipo",
			2 "orden",
			(CASE LEFT (T2."FormatCode",1) WHEN '2' THEN 2
			WHEN '3' THEN 3
			WHEN '7' THEN 7--4
			WHEN '6' THEN 6--4 
			ELSE 0 END )"ordenG",
			T2."FormatCode"		"Codigo_de_cuenta",
			T2."AcctName"		"Nombre de cuenta", 
			T1."TransId"		"Documento",
			T0."TransType"		"tipo documento",
			T0."RefDate"		"Fecha Contabilizacion",
			T1."Line_ID"		"identificador_linea",
			(T1."Credit"-T1."Debit")"Saldo BS",
			(T1."SYSCred"-T1."SYSDeb")  "Saldo USD",		
			IFNULL((SELECT "Rate" FROM ORTT WHERE "Currency"='USD' and "RateDate"=current_date),0)"TC"
	FROM OJDT T0 INNER JOIN JDT1 T1 ON T0."TransId" = T1."TransId" INNER JOIN OACT T2 ON T1."Account" = T2."AcctCode" 
	LEFT OUTER JOIN OJDT TX On T0."TransId" = TX."StornoToTr" ,"TIPOCAMBIO_R" (:FECHAFIN)
	WHERE --t0.transtype='30' /*AND T0.[Number] ='100006043'*/ 
	IFNULL(T0."StornoToTr",'0') = '0' 
	AND (IFNULL( TX."RefDate",'') = '' OR IFNULL (TX."RefDate",'') > :FECHAFIN )
	AND T2."GroupMask" IN (2) --pasivo, patrimonio - balance
	AND T2."AcctName" <> 'INACTIVO'
	AND T0."RefDate" BETWEEN :FECHAINI AND :FECHAFIN  
	UNION
----nivel 6 / creditos - debitos / patrimonio
	SELECT	DISTINCT 2 "query", 
			6 "nivel",
			0 "tipo",
			2 "orden",
			(CASE LEFT (T2."FormatCode",1) WHEN '2' THEN 2
			WHEN '3' THEN 3
			WHEN '7' THEN 7--4
			WHEN '6' THEN 6--4 
			ELSE 0 END )"ordenG",
			T2."FormatCode"		"Codigo_de_cuenta",
			T2."AcctName"		"Nombre de cuenta",
			T1."TransId"		"Documento",
			T0."TransType"		"tipo documento",
			T0."RefDate" 		"Fecha Contabilizacion",
			T1."Line_ID"		"identificador_linea",
			(T1."Credit"-T1."Debit")"Saldo BS",
			(T1."SYSCred"-T1."SYSDeb") "Saldo USD",
			IFNULL((SELECT "Rate" FROM ORTT WHERE "Currency"='USD' and "RateDate"=current_date),0)"TC"
				
	FROM OJDT T0  INNER JOIN JDT1 T1 ON T0."TransId" = T1."TransId" INNER JOIN OACT T2 ON T1."Account" = T2."AcctCode" 
	LEFT OUTER JOIN OJDT TX On T0."TransId" = TX."StornoToTr","TIPOCAMBIO_R" (:FECHAFIN)
	WHERE 
	IFNULL(T0."StornoToTr", '0') = '0' 
	AND (IFNULL( TX."RefDate",'')= '' OR IFNULL( TX."RefDate",'') > :FECHAFIN )
	AND T2."GroupMask" IN (3) --pasivo, patrimonio - balance
	AND T2."AcctName" <> 'INACTIVO'
	AND T0."RefDate" BETWEEN :FECHAINI AND :FECHAFIN ---nivel6_patrimonio
	---------------------
	UNION
----nivel 6 / debitos -  creditos / orden deudora
	SELECT	DISTINCT 2 "query", 
			6 "nivel",
			0 "tipo",
			2 "orden",
			(CASE LEFT (T2."FormatCode",1) WHEN '2' THEN 2
			WHEN '3' THEN 3
			WHEN '6' THEN 6--4 
			ELSE 0 END )"ordenG",
			T2."FormatCode"		"Codigo_de_cuenta",
			T2."AcctName"		"Nombre de cuenta", 
			T1."TransId"		"Documento",
			T0."TransType"		"tipo documento",
			T0."RefDate"		"Fecha Contabilizacion",
			T1."Line_ID"		"identificador_linea",
			(T1."Debit"-T1."Credit")"Saldo BS",
			(T1."SYSDeb"-T1."SYSCred") 	"Saldo USD",
			IFNULL((SELECT "Rate" FROM ORTT WHERE "Currency"='USD' and "RateDate"=current_date),0)"TC"
			
	FROM OJDT T0  INNER JOIN JDT1 T1 ON T0."TransId" = T1."TransId" INNER JOIN OACT T2 ON T1."Account" = T2."AcctCode" 
	LEFT OUTER JOIN OJDT TX On T0."TransId" = TX."StornoToTr", "TIPOCAMBIO_R" (:FECHAFIN)
	WHERE 
	IFNULL(T0."StornoToTr", '0') = '0' 
	AND (IFNULL( TX."RefDate",'') = '' OR IFNULL( TX."RefDate",'') > :FECHAFIN)
	AND T2."GroupMask" IN (6) --activos, - balance
	AND T2."AcctName" <> 'INACTIVO'
	AND T0."RefDate" BETWEEN :FECHAINI AND :FECHAFIN ---NIVEL5_ACTIVOS 
    UNION
----nivel 6 / debitos -  creditos / orden acreedora
	SELECT	DISTINCT 2 "query", 
			6 "nivel",
			0 "tipo",
			1 "orden",
			(CASE LEFT (T2."FormatCode",1) WHEN '1' THEN 1
			WHEN '7' THEN 7--2
			ELSE 0 END )"ordenG",
			T2."FormatCode"		"Codigo_de_cuenta",
			T2."AcctName"		"Nombre de cuenta", 
			T1."TransId"		"Documento",
			T0."TransType"		"tipo documento",
			T0."RefDate"		"Fecha Contabilizacion",
			T1."Line_ID"		"identificador_linea",
			(T1."Debit"-T1."Credit")"Saldo BS",
			(T1."SYSDeb"-T1."SYSCred") 	"Saldo USD",
			IFNULL((SELECT "Rate" FROM ORTT WHERE "Currency"='USD' and "RateDate"=current_date),0)"TC"
			
	FROM OJDT T0  INNER JOIN JDT1 T1 ON T0."TransId" = T1."TransId" INNER JOIN OACT T2 ON T1."Account" = T2."AcctCode" 
	LEFT OUTER JOIN OJDT TX On T0."TransId" = TX."StornoToTr", "TIPOCAMBIO_R" (:FECHAFIN)
	WHERE 
	IFNULL(T0."StornoToTr", '0') = '0' 
	AND (IFNULL( TX."RefDate",'') = '' OR IFNULL( TX."RefDate",'') > :FECHAFIN)
	AND T2."GroupMask" IN (7) --activos, - balance
	AND T2."AcctName" <> 'INACTIVO'
	AND T0."RefDate" BETWEEN :FECHAINI AND :FECHAFIN ---NIVEL5_ACTIVOS 
--AGRUPACIONES
	UNION
-----AGRUPACION nivel 1 / debitos -  creditos ACTIVOS
	SELECT	DISTINCT 2 "query", 
			1 "nivel",
			1 "tipo",	
			1 "orden",		
			(CASE LEFT (T2."FormatCode",1) WHEN '1' THEN 1
			WHEN '2' THEN 2
			WHEN '3' THEN 3
			WHEN '4' THEN 4
			WHEN '5' THEN 5
			WHEN '6' THEN 6
			WHEN '7' THEN 7
			ELSE 0 END )"ordenG",
			(CASE LEFT (T2."FormatCode",1) WHEN '1' THEN '1'
			WHEN '2' THEN '2'
			WHEN '3' THEN '3'
			WHEN '4' THEN '4'
			WHEN '5' THEN '5'
			WHEN '6' THEN '6'
			WHEN '7' THEN '7' 
			ELSE '' END )"Codigo_de_cuenta",
			(CASE LEFT (T2."FormatCode",1) WHEN '1' THEN T10."AcctName"
			WHEN '3' THEN T10."AcctName"
			WHEN '2' THEN T10."AcctName"
			WHEN '4' THEN T10."AcctName"
			WHEN '5' THEN T10."AcctName"
			WHEN '6' THEN T10."AcctName"
 			WHEN '7' THEN T10."AcctName"
			ELSE '' END )	"Nombre de cuenta",
			T1."TransId"		"Documento",
			T0."TransType"		"tipo documento",
			T0."RefDate"		"Fecha Contabilizacion",
			T1."Line_ID"		"identificador_linea",
			(T1."Debit"-T1."Credit")	"Saldo BS",
			(T1."SYSDeb"-T1."SYSCred") 	"Saldo USD",
			IFNULL((SELECT "Rate" FROM ORTT WHERE "Currency"='USD' and "RateDate"=current_date),0)"TC"

	FROM OJDT T0  INNER JOIN JDT1 T1 ON T0."TransId" = T1."TransId" INNER JOIN OACT T2 ON T1."Account" = T2."AcctCode" --t1.account
	LEFT OUTER JOIN OJDT TX ON T0."TransId" = TX."StornoToTr"
	LEFT JOIN OACT T6 ON T6."AcctCode" = T2."FatherNum" -- nivel 5
	LEFT JOIN OACT T7 ON T7."AcctCode" = T6."FatherNum" --nivel 4
	LEFT JOIN OACT T8 ON T8."AcctCode" = T7."FatherNum" --nivel 3
	LEFT JOIN OACT T9 ON T9."AcctCode" = T8."FatherNum" --nivel 2
	LEFT JOIN OACT T10 ON T10."AcctCode" = T9."FatherNum" , "TIPOCAMBIO_R" (:FECHAFIN)
	WHERE 
	IFNULL(T0."StornoToTr", '0') = '0' 
	AND (IFNULL(TX."RefDate",'')= '' OR IFNULL(TX."RefDate",'') > :FECHAFIN)
	AND T2."GroupMask" in (1) --activos, diferidos activos... - balance
	AND T2."AcctName" <> 'INACTIVO'
	AND T0."RefDate" BETWEEN :FECHAINI and :FECHAFIN ---nivel 1 activos y gastos operacionales
	---------------------
	UNION
-----AGRUPACION nivel 1 / creditos - debitos PASIVO PATRIMONIO
	SELECT	DISTINCT 2 "query", 
			1 "nivel",
			1 "tipo",	
			1 "orden",		
			(CASE LEFT (T2."FormatCode",1) WHEN '1' THEN 1
			WHEN '2' THEN 2
			WHEN '3' THEN 3
			WHEN '4' THEN 4
			WHEN '5' THEN 5
			WHEN '6' THEN 6
			WHEN '7' THEN 7
			ELSE 0 END )"ordenG",
			(CASE LEFT (T2."FormatCode",1) WHEN '1' THEN '1'
			WHEN '2' THEN '2'
			WHEN '3' THEN '3'
			WHEN '4' THEN '4'
			WHEN '5' THEN '5'
			WHEN '6' THEN '6'
			WHEN '7' THEN '7' 
			ELSE '' END )"Codigo_de_cuenta",
			(CASE LEFT (T2."FormatCode",1) WHEN '1' THEN T10."AcctName"
			WHEN '3' THEN T10."AcctName"
			WHEN '2' THEN T10."AcctName"
			WHEN '4' THEN T10."AcctName"
			WHEN '5' THEN T10."AcctName"
			WHEN '6' THEN T10."AcctName"
 			WHEN '7' THEN T10."AcctName"
			ELSE '' END )	"Nombre de cuenta",
			T1."TransId"	"Documento",
			T0."TransType"	"tipo documento",
			T0."RefDate"	"Fecha Contabilizacion",
			T1."Line_ID"	"identificador_linea",
			(T1."Credit"-T1."Debit")"Saldo BS",
			(T1."SYSCred"-T1."SYSDeb")"Saldo USD",
			IFNULL((SELECT "Rate" FROM ORTT WHERE "Currency"='USD' and "RateDate"=current_date),0)"TC"
			
	FROM OJDT T0  INNER JOIN JDT1 T1 ON T0."TransId" = T1."TransId" INNER JOIN OACT T2 ON T1."Account" = T2."AcctCode" 
	LEFT OUTER JOIN OJDT TX On T0."TransId" = TX."StornoToTr"
	LEFT JOIN OACT T6 ON T6."AcctCode" = T2."FatherNum" -- nivel 5
	LEFT JOIN OACT T7 ON T7."AcctCode" = T6."FatherNum" --nivel 4
	LEFT JOIN OACT T8 ON T8."AcctCode" = T7."FatherNum" --nivel 3
	LEFT JOIN OACT T9 ON T9."AcctCode" = T8."FatherNum" --nivel 2
	LEFT JOIN OACT T10 ON T10."AcctCode" = T9."FatherNum" --nivel 1 ,"TIPOCAMBIO_R" (:FECHAFIN)
	WHERE 
	IFNULL(T0."StornoToTr", '0') = '0' 
	AND (IFNULL(TX."RefDate",'')= '' OR IFNULL(TX."RefDate",'') > :FECHAFIN )
	AND T2."GroupMask" IN (2, 3) --pasivo, patrimonio, diferido pasivo - balance
	AND T2."AcctName" <> 'INACTIVO'
	AND T0."RefDate" BETWEEN :FECHAINI AND :FECHAFIN --- NIVEL 1 PASIVO - PATRIMONIO , 7 -9 
	UNION
-----AGRUPACION nivel 1 / debitos -  creditos DEUDORAS
	SELECT	DISTINCT 2 "query", 
			1 "nivel",
			1 "tipo",	
			1 "orden",		
			(CASE LEFT (T2."FormatCode",1) WHEN '1' THEN 1
			WHEN '2' THEN 2
			WHEN '3' THEN 3
			WHEN '4' THEN 4
			WHEN '5' THEN 5
			WHEN '6' THEN 6
			WHEN '7' THEN 7
			ELSE 0 END )"ordenG",
			(CASE LEFT (T2."FormatCode",1) WHEN '1' THEN '1'
			WHEN '2' THEN '2'
			WHEN '3' THEN '3'
			WHEN '4' THEN '4'
			WHEN '5' THEN '5'
			WHEN '6' THEN '6'
			WHEN '7' THEN '7' 
			ELSE '' END )"Codigo_de_cuenta",
			(CASE LEFT (T2."FormatCode",1) WHEN '1' THEN T10."AcctName"
			WHEN '3' THEN T10."AcctName"
			WHEN '2' THEN T10."AcctName"
			WHEN '4' THEN T10."AcctName"
			WHEN '5' THEN T10."AcctName"
			WHEN '6' THEN T10."AcctName"
 			WHEN '7' THEN T10."AcctName"
			ELSE '' END )	"Nombre de cuenta",
			T1."TransId"		"Documento",
			T0."TransType"		"tipo documento",
			T0."RefDate"		"Fecha Contabilizacion",
			T1."Line_ID"		"identificador_linea",
			(T1."Debit"-T1."Credit")	"Saldo BS",
			(T1."SYSDeb"-T1."SYSCred") 	"Saldo USD",
			IFNULL((SELECT "Rate" FROM ORTT WHERE "Currency"='USD' and "RateDate"=current_date),0)"TC"

	FROM OJDT T0  INNER JOIN JDT1 T1 ON T0."TransId" = T1."TransId" INNER JOIN OACT T2 ON T1."Account" = T2."AcctCode" --t1.account
	LEFT OUTER JOIN OJDT TX ON T0."TransId" = TX."StornoToTr"
	LEFT JOIN OACT T6 ON T6."AcctCode" = T2."FatherNum" -- nivel 5
	LEFT JOIN OACT T7 ON T7."AcctCode" = T6."FatherNum" --nivel 4
	LEFT JOIN OACT T8 ON T8."AcctCode" = T7."FatherNum" --nivel 3
	LEFT JOIN OACT T9 ON T9."AcctCode" = T8."FatherNum" --nivel 2
	LEFT JOIN OACT T10 ON T10."AcctCode" = T9."FatherNum" , "TIPOCAMBIO_R" (:FECHAFIN)
	WHERE 
	IFNULL(T0."StornoToTr", '0') = '0' 
	AND (IFNULL(TX."RefDate",'')= '' OR IFNULL(TX."RefDate",'') > :FECHAFIN)
	AND T2."GroupMask" in (6) --activos, diferidos activos... - balance
	AND T2."AcctName" <> 'INACTIVO'
	AND T0."RefDate" BETWEEN :FECHAINI and :FECHAFIN ---nivel 1 activos y gastos operacionales
	---------------------
	UNION
-----AGRUPACION nivel 1 / debitos -  creditos ACREEDORAS
	SELECT	DISTINCT 2 "query", 
			1 "nivel",
			1 "tipo",	
			1 "orden",		
			(CASE LEFT (T2."FormatCode",1) WHEN '1' THEN 1
			WHEN '2' THEN 2
			WHEN '3' THEN 3
			WHEN '4' THEN 4
			WHEN '5' THEN 5
			WHEN '6' THEN 6
			WHEN '7' THEN 7
			ELSE 0 END )"ordenG",
			(CASE LEFT (T2."FormatCode",1) WHEN '1' THEN '1'
			WHEN '2' THEN '2'
			WHEN '3' THEN '3'
			WHEN '4' THEN '4'
			WHEN '5' THEN '5'
			WHEN '6' THEN '6'
			WHEN '7' THEN '7' 
			ELSE '' END )"Codigo_de_cuenta",
			(CASE LEFT (T2."FormatCode",1) WHEN '1' THEN T10."AcctName"
			WHEN '3' THEN T10."AcctName"
			WHEN '2' THEN T10."AcctName"
			WHEN '4' THEN T10."AcctName"
			WHEN '5' THEN T10."AcctName"
			WHEN '6' THEN T10."AcctName"
 			WHEN '7' THEN T10."AcctName"
			ELSE '' END )	"Nombre de cuenta",
			T1."TransId"		"Documento",
			T0."TransType"		"tipo documento",
			T0."RefDate"		"Fecha Contabilizacion",
			T1."Line_ID"		"identificador_linea",
			(T1."Debit"-T1."Credit")	"Saldo BS",
			(T1."SYSDeb"-T1."SYSCred") 	"Saldo USD",
			IFNULL((SELECT "Rate" FROM ORTT WHERE "Currency"='USD' and "RateDate"=current_date),0)"TC"

	FROM OJDT T0  INNER JOIN JDT1 T1 ON T0."TransId" = T1."TransId" INNER JOIN OACT T2 ON T1."Account" = T2."AcctCode" --t1.account
	LEFT OUTER JOIN OJDT TX ON T0."TransId" = TX."StornoToTr"
	LEFT JOIN OACT T6 ON T6."AcctCode" = T2."FatherNum" -- nivel 5
	LEFT JOIN OACT T7 ON T7."AcctCode" = T6."FatherNum" --nivel 4
	LEFT JOIN OACT T8 ON T8."AcctCode" = T7."FatherNum" --nivel 3
	LEFT JOIN OACT T9 ON T9."AcctCode" = T8."FatherNum" --nivel 2
	LEFT JOIN OACT T10 ON T10."AcctCode" = T9."FatherNum" , "TIPOCAMBIO_R" (:FECHAFIN)
	WHERE 
	IFNULL(T0."StornoToTr", '0') = '0' 
	AND (IFNULL(TX."RefDate",'')= '' OR IFNULL(TX."RefDate",'') > :FECHAFIN)
	AND T2."GroupMask" in (7) --activos, diferidos activos... - balance
	AND T2."AcctName" <> 'INACTIVO'
	AND T0."RefDate" BETWEEN :FECHAINI and :FECHAFIN ---nivel 1 activos y gastos operacionales
	---------------------
	UNION



--

---AGRUPACION nivel 2 / creditos - debitos PASIVO PATRIMONIO
	SELECT	DISTINCT 2 "query", 
			2 "nivel",
			0 "tipo",
			2 "orden",	
			(CASE LEFT (T2."FormatCode",1) WHEN '2' THEN 2
			WHEN '3' THEN 3
			WHEN '7' THEN 7
			WHEN '6' THEN 6 
			ELSE 0 END )"ordenG",
			LEFT(T2."FormatCode",3)	|| '' "Codigo_de_cuenta",
			UPPER(T9."AcctName")		"Nombre de cuenta", 
			T1."TransId"		"Documento",
			T0."TransType"		"tipo documento",
			T0."RefDate" 		"Fecha Contabilizacion",
			T1."Line_ID"		"identificador_linea",
			(T1."Credit"-T1."Debit")	"Saldo BS",
			(T1."SYSCred"-T1."SYSDeb")	"Saldo USD",
			IFNULL((SELECT "Rate" FROM ORTT WHERE "Currency"='USD' and "RateDate"=current_date),0)"TC"
			
	FROM OJDT T0  INNER JOIN JDT1 T1 ON T0."TransId" = T1."TransId" INNER JOIN OACT T2 ON T1."Account" = T2."AcctCode" 
	LEFT OUTER JOIN OJDT TX ON T0."TransId" = TX."StornoToTr"
	LEFT JOIN OACT T6 ON T6."AcctCode" = T2."FatherNum" -- nivel 5
	LEFT JOIN OACT T7 ON T7."AcctCode" = T6."FatherNum" --nivel 4
	LEFT JOIN OACT T8 ON T8."AcctCode" = T7."FatherNum" --nivel 3 
	LEFT JOIN OACT T9 ON T9."AcctCode" = T8."FatherNum", "TIPOCAMBIO_R" (:FECHAFIN) --nivel 2
	WHERE --t0.transtype='30' /*AND T0.[Number] ='100006043'*/ 
	IFNULL(T0."StornoToTr", '0') = '0' 
	AND (IFNULL(TX."RefDate",'')= '' OR IFNULL(TX."RefDate",'') > :FECHAFIN)
	AND T2."GroupMask" IN (2, 3) --pasivo, patrimonio - balance
	AND T2."AcctName" <> 'INACTIVO'
	AND T0."RefDate" BETWEEN :FECHAINI AND :FECHAFIN --NIVEL 1 PASIVO Y OTROS INGRESOs
	---------------------
	UNION
-----AGRUPACION nivel 2 / debitos -  creditos ACTIVO
	SELECT	DISTINCT 2 "query", 
			2 "nivel",
			0 "tipo",
			1 "orden",	
			(CASE LEFT (T2."FormatCode",1) WHEN '1' THEN 1
			WHEN '7' THEN 7
			ELSE 0 END )"ordenG",	
			LEFT(T2."FormatCode",3)	|| '' "Codigo_de_cuenta",
			UPPER(T9."AcctName")			"Nombre de cuenta", 
			T1."TransId"		"Documento",
			T0."TransType"		"tipo documento",
			T0."RefDate"		"Fecha Contabilizacion",
			T1."Line_ID"		"identificador_linea",
			(T1."Debit"-T1."Credit")	"Saldo BS",
			(T1."SYSDeb"-T1."SYSCred") 	"Saldo USD",
			IFNULL((SELECT "Rate" FROM ORTT WHERE "Currency"='USD' and "RateDate"=current_date),0)"TC"

	FROM OJDT T0  INNER JOIN JDT1 T1 ON T0."TransId" = T1."TransId" INNER JOIN OACT T2 ON T1."Account" = T2."AcctCode" --t1.account
	LEFT OUTER JOIN OJDT TX On T0."TransId" = TX."StornoToTr"
	LEFT JOIN OACT T6 ON T6."AcctCode" = T2."FatherNum" -- nivel 4
	LEFT JOIN OACT T7 ON T7."AcctCode" = T6."FatherNum" --nivel 3
	LEFT JOIN OACT T8 ON T8."AcctCode" = T7."FatherNum" --nivel 2
	LEFT JOIN OACT T9 ON T9."AcctCode" = T8."FatherNum" ,"TIPOCAMBIO_R" (:FECHAFIN) --nivel 2
	WHERE 
	IFNULL(T0."StornoToTr", '0') = '0' 
	AND (IFNULL(TX."RefDate",'')= '' OR IFNULL(TX."RefDate",'') > :FECHAFIN)
	AND T2."GroupMask" IN (1) --activos, - balance
	AND T2."AcctName" <> 'INACTIVO'
	AND T0."RefDate" BETWEEN :FECHAINI AND :FECHAFIN
	---------------------
	UNION
-----AGRUPACION nivel 2 / debitos -  creditos DEUDORAS
	SELECT	DISTINCT 2 "query", 
			2 "nivel",
			0 "tipo",
			2 "orden",	
			(CASE LEFT (T2."FormatCode",1) WHEN '1' THEN 1
			WHEN '6' THEN 6
			ELSE 0 END )"ordenG",	
			LEFT(T2."FormatCode",3)	|| '' "Codigo_de_cuenta",
			UPPER(T9."AcctName")			"Nombre de cuenta", 
			T1."TransId"		"Documento",
			T0."TransType"		"tipo documento",
			T0."RefDate"		"Fecha Contabilizacion",
			T1."Line_ID"		"identificador_linea",
			(T1."Debit"-T1."Credit")	"Saldo BS",
			(T1."SYSDeb"-T1."SYSCred") 	"Saldo USD",
			IFNULL((SELECT "Rate" FROM ORTT WHERE "Currency"='USD' and "RateDate"=current_date),0)"TC"

	FROM OJDT T0  INNER JOIN JDT1 T1 ON T0."TransId" = T1."TransId" INNER JOIN OACT T2 ON T1."Account" = T2."AcctCode" --t1.account
	LEFT OUTER JOIN OJDT TX On T0."TransId" = TX."StornoToTr"
	LEFT JOIN OACT T6 ON T6."AcctCode" = T2."FatherNum" -- nivel 4
	LEFT JOIN OACT T7 ON T7."AcctCode" = T6."FatherNum" --nivel 3
	LEFT JOIN OACT T8 ON T8."AcctCode" = T7."FatherNum" --nivel 2
	LEFT JOIN OACT T9 ON T9."AcctCode" = T8."FatherNum" ,"TIPOCAMBIO_R" (:FECHAFIN) --nivel 2
	WHERE 
	IFNULL(T0."StornoToTr", '0') = '0' 
	AND (IFNULL(TX."RefDate",'')= '' OR IFNULL(TX."RefDate",'') > :FECHAFIN)
	AND T2."GroupMask" IN (6) --activos, - balance
	AND T2."AcctName" <> 'INACTIVO'
	AND T0."RefDate" BETWEEN :FECHAINI AND :FECHAFIN
	---------------------
	UNION
-----AGRUPACION nivel 2 / debitos -  creditos ACREEDORAS
	SELECT	DISTINCT 2 "query", 
			2 "nivel",
			0 "tipo",
			1 "orden",	
			(CASE LEFT (T2."FormatCode",1) WHEN '1' THEN 1
			WHEN '7' THEN 7
			ELSE 0 END )"ordenG",	
			LEFT(T2."FormatCode",3)	|| '' "Codigo_de_cuenta",
			UPPER(T9."AcctName")			"Nombre de cuenta", 
			T1."TransId"		"Documento",
			T0."TransType"		"tipo documento",
			T0."RefDate"		"Fecha Contabilizacion",
			T1."Line_ID"		"identificador_linea",
			(T1."Debit"-T1."Credit")	"Saldo BS",
			(T1."SYSDeb"-T1."SYSCred") 	"Saldo USD",
			IFNULL((SELECT "Rate" FROM ORTT WHERE "Currency"='USD' and "RateDate"=current_date),0)"TC"

	FROM OJDT T0  INNER JOIN JDT1 T1 ON T0."TransId" = T1."TransId" INNER JOIN OACT T2 ON T1."Account" = T2."AcctCode" --t1.account
	LEFT OUTER JOIN OJDT TX On T0."TransId" = TX."StornoToTr"
	LEFT JOIN OACT T6 ON T6."AcctCode" = T2."FatherNum" -- nivel 4
	LEFT JOIN OACT T7 ON T7."AcctCode" = T6."FatherNum" --nivel 3
	LEFT JOIN OACT T8 ON T8."AcctCode" = T7."FatherNum" --nivel 2
	LEFT JOIN OACT T9 ON T9."AcctCode" = T8."FatherNum" ,"TIPOCAMBIO_R" (:FECHAFIN) --nivel 2
	WHERE 
	IFNULL(T0."StornoToTr", '0') = '0' 
	AND (IFNULL(TX."RefDate",'')= '' OR IFNULL(TX."RefDate",'') > :FECHAFIN)
	AND T2."GroupMask" IN (7) --activos, - balance
	AND T2."AcctName" <> 'INACTIVO'
	AND T0."RefDate" BETWEEN :FECHAINI AND :FECHAFIN
	---------------------
	UNION


--

---AGRUPACION nivel 3 / creditos - debitos PASIVO PATRIMONIO
	SELECT	DISTINCT 2 "query", 
			3 "nivel",
			0 "tipo",
			2 "orden",		
			(CASE LEFT (T2."FormatCode",1) WHEN '2' THEN 2
			WHEN '3' THEN 3
			ELSE 0 END )"ordenG",		
			LEFT(T2."FormatCode",6)	 "Codigo_de_cuenta",
			T8."AcctName"			"Nombre de cuenta", 
			T1."TransId"			"Documento",
			T0."TransType"		"tipo documento",
			T0."RefDate" 		"Fecha Contabilizacion",
			T1."Line_ID"		"identificador_linea",
			(T1."Credit"-T1."Debit")	"Saldo BS",
			(T1."SYSCred"-T1."SYSDeb")	"Saldo USD",
			IFNULL((SELECT "Rate" FROM ORTT WHERE "Currency"='USD' and "RateDate"=current_date),0)"TC"
	FROM OJDT T0  INNER JOIN JDT1 T1 ON T0."TransId" = T1."TransId" INNER JOIN OACT T2 ON T1."Account" = T2."AcctCode" 
	LEFT OUTER JOIN OJDT TX ON T0."TransId" = TX."StornoToTr"
	left join OACT t6 on t6."AcctCode"=t2."FatherNum" -- nivel 5
	left join OACT t7 on t7."AcctCode"=t6."FatherNum" --nivel 4
	left join OACT t8 on t8."AcctCode"=t7."FatherNum","TIPOCAMBIO_R" (:FECHAFIN) --nivel 3
	WHERE --t0.transtype='30' /*AND T0.[Number] ='100006043'*/ 
	IFNULL(T0."StornoToTr", '0') = '0'  
	--AND IFNULL(TX.STORNOTOTR, '')='' --order by documento
	and ( IFNULL( tx."RefDate",'')= '' or IFNULL( tx."RefDate",'') > :FECHAFIN )
	and T2."GroupMask" in (2, 3) --pasivo, patrimonio - balance
	--group by T2.[FormatCode],t2.acctname, T0.RefDate
	and t2."AcctName" <> 'INACTIVO'
	and t0."RefDate" between :FECHAINI and :FECHAFIN
	-------
	UNION
-----AGRUPACION nivel 3 / debitos -  creditos ACTIVO
	SELECT	distinct 2 "query", 
			3 "nivel",
			0 "tipo",	
			1 "orden",	
			(CASE LEFT (T2."FormatCode",1) WHEN '1' THEN 1
			ELSE 0 END )"ordenG",	
			LEFT(T2."FormatCode",6) "Codigo_de_cuenta",
			t8."AcctName"    		"Nombre de cuenta", 
			t1."TransId"			"Documento",
			t0."TransType"		"tipo documento",
			t0."RefDate"			"Fecha Contabilizacion",
			t1."Line_ID"			"identificador_linea",
			(T1."Debit"-t1."Credit")	"Saldo BS",
			(T1."SYSDeb"-t1."SYSCred")	"Saldo USD",
			IFNULL((SELECT "Rate" FROM ORTT WHERE "Currency"='USD' and "RateDate"=current_date),0)"TC"
	FROM OJDT T0 INNER JOIN JDT1 T1 ON T0."TransId" = T1."TransId" INNER JOIN OACT T2 ON t1."Account" =t2."AcctCode" --t1.account
	LEFT OUTER JOIN OJDT TX On t0."TransId" = TX."StornoToTr"
	LEFT JOIN OACT T6 ON T6."AcctCode" = T2."FatherNum" -- nivel 5
	LEFT JOIN OACT T7 ON T7."AcctCode" = T6."FatherNum" --nivel 4
	LEFT JOIN OACT T8 ON T8."AcctCode" = T7."FatherNum", "TIPOCAMBIO_R" (:FECHAFIN) --nivel 3
	WHERE 
	IFNULL(T0."StornoToTr", '0') = '0' 
	AND (IFNULL(TX."RefDate",'') = '' OR IFNULL(TX."RefDate",'') > :FECHAFIN)
	AND T2."GroupMask" IN (1) --activos, - balance
	AND T2."AcctName" <> 'INACTIVO'
	AND T0."RefDate" BETWEEN :FECHAINI and :FECHAFIN
	---------------------
	UNION
-----AGRUPACION nivel 3 / debitos -  creditos DEUDORA
	SELECT	distinct 2 "query", 
			3 "nivel",
			0 "tipo",	
			2 "orden",	
			(CASE LEFT (T2."FormatCode",1) WHEN '1' THEN 1
			WHEN '6' THEN 6
			ELSE 0 END )"ordenG",	
			LEFT(T2."FormatCode",6) "Codigo_de_cuenta",
			t8."AcctName"    		"Nombre de cuenta", 
			t1."TransId"			"Documento",
			t0."TransType"		"tipo documento",
			t0."RefDate"			"Fecha Contabilizacion",
			t1."Line_ID"			"identificador_linea",
			(T1."Debit"-t1."Credit")	"Saldo BS",
			(T1."SYSDeb"-t1."SYSCred")	"Saldo USD",
			IFNULL((SELECT "Rate" FROM ORTT WHERE "Currency"='USD' and "RateDate"=current_date),0)"TC"
	FROM OJDT T0 INNER JOIN JDT1 T1 ON T0."TransId" = T1."TransId" INNER JOIN OACT T2 ON t1."Account" =t2."AcctCode" --t1.account
	LEFT OUTER JOIN OJDT TX On t0."TransId" = TX."StornoToTr"
	LEFT JOIN OACT T6 ON T6."AcctCode" = T2."FatherNum" -- nivel 5
	LEFT JOIN OACT T7 ON T7."AcctCode" = T6."FatherNum" --nivel 4
	LEFT JOIN OACT T8 ON T8."AcctCode" = T7."FatherNum", "TIPOCAMBIO_R" (:FECHAFIN) --nivel 3
	WHERE 
	IFNULL(T0."StornoToTr", '0') = '0' 
	AND (IFNULL(TX."RefDate",'') = '' OR IFNULL(TX."RefDate",'') > :FECHAFIN)
	AND T2."GroupMask" IN (6) --activos, - balance
	AND T2."AcctName" <> 'INACTIVO'
	AND T0."RefDate" BETWEEN :FECHAINI and :FECHAFIN
	---------------------
	UNION
-----AGRUPACION nivel 3 / debitos -  creditos ACREEDORA
	SELECT	distinct 2 "query", 
			3 "nivel",
			0 "tipo",	
			1 "orden",	
			(CASE LEFT (T2."FormatCode",1) WHEN '1' THEN 1
			WHEN '7' THEN 7
			ELSE 0 END )"ordenG",	
			LEFT(T2."FormatCode",6) "Codigo_de_cuenta",
			t8."AcctName"    		"Nombre de cuenta", 
			t1."TransId"			"Documento",
			t0."TransType"		"tipo documento",
			t0."RefDate"			"Fecha Contabilizacion",
			t1."Line_ID"			"identificador_linea",
			(T1."Debit"-t1."Credit")	"Saldo BS",
			(T1."SYSDeb"-t1."SYSCred")	"Saldo USD",
			IFNULL((SELECT "Rate" FROM ORTT WHERE "Currency"='USD' and "RateDate"=current_date),0)"TC"
	FROM OJDT T0 INNER JOIN JDT1 T1 ON T0."TransId" = T1."TransId" INNER JOIN OACT T2 ON t1."Account" =t2."AcctCode" --t1.account
	LEFT OUTER JOIN OJDT TX On t0."TransId" = TX."StornoToTr"
	LEFT JOIN OACT T6 ON T6."AcctCode" = T2."FatherNum" -- nivel 5
	LEFT JOIN OACT T7 ON T7."AcctCode" = T6."FatherNum" --nivel 4
	LEFT JOIN OACT T8 ON T8."AcctCode" = T7."FatherNum", "TIPOCAMBIO_R" (:FECHAFIN) --nivel 3
	WHERE 
	IFNULL(T0."StornoToTr", '0') = '0' 
	AND (IFNULL(TX."RefDate",'') = '' OR IFNULL(TX."RefDate",'') > :FECHAFIN)
	AND T2."GroupMask" IN (7) --activos, - balance
	AND T2."AcctName" <> 'INACTIVO'
	AND T0."RefDate" BETWEEN :FECHAINI and :FECHAFIN
	---------------------
	UNION
--

----AGRUPACION nivel 4 / creditos - debitos PASIVO PATRIMONIO
	SELECT	DISTINCT 2 "query", 
			4 "nivel",
			0 "tipo",	
			2 "orden",	
			(CASE LEFT (T2."FormatCode",1) WHEN '2' THEN 2
			WHEN '3' THEN 3
			ELSE 0 END )"ordenG",	
			LEFT(T2."FormatCode",8)		"Codigo_de_cuenta",
			T7."AcctName"		"Nombre de cuenta", 
			T1."TransId"			"Documento",
			T0."TransType"		"tipo documento",
			T0."RefDate" 		"Fecha Contabilizacion",
			T1."Line_ID"		"identificador_linea",
			(T1."Credit"-T1."Debit")	"Saldo BS",
			(T1."SYSCred"-T1."SYSDeb")"Saldo USD",
			IFNULL((SELECT "Rate" FROM ORTT WHERE "Currency"='USD' and "RateDate"=current_date),0)"TC"
	FROM OJDT T0  INNER JOIN JDT1 T1 ON T0."TransId" = T1."TransId" INNER JOIN OACT T2 ON T1."Account" = T2."AcctCode" 
	LEFT OUTER JOIN OJDT TX ON T0."TransId" = TX."StornoToTr"
	LEFT JOIN OACT T6 ON T6."AcctCode" = T2."FatherNum" -- nivel 5
	LEFT JOIN OACT T7 ON T7."AcctCode" = T6."FatherNum" --nivel 4
	LEFT JOIN OACT T8 ON T8."AcctCode" = T7."FatherNum" , "TIPOCAMBIO_R" (:FECHAFIN) --nivel 2
	WHERE 
	IFNULL(T0."StornoToTr", '0') = '0' 
	AND (IFNULL(TX."RefDate",'') = '' OR IFNULL(TX."RefDate",'') > :FECHAFIN )
	AND T2."GroupMask" IN (2, 3) --pasivo, patrimonio - balance
	AND T2."AcctName" <> 'INACTIVO'
	AND T0."RefDate" BETWEEN :FECHAINI AND :FECHAFIN
	-------
	UNION
-----AGRUPACION nivel 4 / debitos -  creditos ACTIVO
	SELECT	DISTINCT 2 "query", 
			4 "nivel",
			0 "tipo",	
			1 "orden",	
			(CASE LEFT (T2."FormatCode",1) WHEN '1' THEN 1
			ELSE 0 END )"ordenG",	
			LEFT(T2."FormatCode",8)		"Codigo_de_cuenta",
			T7."AcctName"		"Nombre de cuenta", 
			T1."TransId"			"Documento",
			T0."TransType"		"tipo documento",
			T0."RefDate"			"Fecha Contabilizacion",
			T1."Line_ID"			"identificador_linea",
			(T1."Debit"-T1."Credit")	"Saldo BS",
			(T1."SYSDeb"-T1."SYSCred")	"Saldo USD",
			IFNULL((SELECT "Rate" FROM ORTT WHERE "Currency"='USD' and "RateDate"=current_date),0)"TC"

	FROM OJDT T0  INNER JOIN JDT1 T1 ON T0."TransId" = T1."TransId" INNER JOIN OACT T2 ON T1."Account" = T2."AcctCode" --t1.account
	LEFT OUTER JOIN OJDT TX On T0."TransId" = TX."StornoToTr"
	LEFT JOIN OACT T6 ON T6."AcctCode" = T2."FatherNum" -- nivel 5
	LEFT JOIN OACT T7 ON T7."AcctCode" = T6."FatherNum" --nivel 4
	LEFT JOIN OACT T8 ON T8."AcctCode" = T7."FatherNum","TIPOCAMBIO_R" (:FECHAFIN) --nivel 2
	WHERE 
	IFNULL(T0."StornoToTr", '0') = '0' 
	AND (IFNULL(TX."RefDate",'')= '' OR IFNULL(TX."RefDate",'') > :FECHAFIN)
	AND T2."GroupMask" in (1) --activos, - balance
	AND T2."AcctName" <> 'INACTIVO'
	AND T0."RefDate" BETWEEN :FECHAINI and :FECHAFIN
	---------------------

	UNION
-----AGRUPACION nivel 4 / debitos -  creditos DEURORA
	SELECT	DISTINCT 2 "query", 
			4 "nivel",
			0 "tipo",	
			2 "orden",	
			(CASE LEFT (T2."FormatCode",1) WHEN '1' THEN 1
			WHEN '6' THEN 6
			ELSE 0 END )"ordenG",	
			LEFT(T2."FormatCode",8)		"Codigo_de_cuenta",
			T7."AcctName"		"Nombre de cuenta", 
			T1."TransId"			"Documento",
			T0."TransType"		"tipo documento",
			T0."RefDate"			"Fecha Contabilizacion",
			T1."Line_ID"			"identificador_linea",
			(T1."Debit"-T1."Credit")	"Saldo BS",
			(T1."SYSDeb"-T1."SYSCred")	"Saldo USD",
			IFNULL((SELECT "Rate" FROM ORTT WHERE "Currency"='USD' and "RateDate"=current_date),0)"TC"

	FROM OJDT T0  INNER JOIN JDT1 T1 ON T0."TransId" = T1."TransId" INNER JOIN OACT T2 ON T1."Account" = T2."AcctCode" --t1.account
	LEFT OUTER JOIN OJDT TX On T0."TransId" = TX."StornoToTr"
	LEFT JOIN OACT T6 ON T6."AcctCode" = T2."FatherNum" -- nivel 5
	LEFT JOIN OACT T7 ON T7."AcctCode" = T6."FatherNum" --nivel 4
	LEFT JOIN OACT T8 ON T8."AcctCode" = T7."FatherNum","TIPOCAMBIO_R" (:FECHAFIN) --nivel 2
	WHERE 
	IFNULL(T0."StornoToTr", '0') = '0' 
	AND (IFNULL(TX."RefDate",'')= '' OR IFNULL(TX."RefDate",'') > :FECHAFIN)
	AND T2."GroupMask" in (6) --activos, - balance
	AND T2."AcctName" <> 'INACTIVO'
	AND T0."RefDate" BETWEEN :FECHAINI and :FECHAFIN
	---------------------

	UNION
-----AGRUPACION nivel 4 / debitos -  creditos ACREEDORA
	SELECT	DISTINCT 2 "query", 
			4 "nivel",
			0 "tipo",	
			1 "orden",	
			(CASE LEFT (T2."FormatCode",1) WHEN '1' THEN 1
			WHEN '7' THEN 7
			ELSE 0 END )"ordenG",	
			LEFT(T2."FormatCode",8)		"Codigo_de_cuenta",
			T7."AcctName"		"Nombre de cuenta", 
			T1."TransId"			"Documento",
			T0."TransType"		"tipo documento",
			T0."RefDate"			"Fecha Contabilizacion",
			T1."Line_ID"			"identificador_linea",
			(T1."Debit"-T1."Credit")	"Saldo BS",
			(T1."SYSDeb"-T1."SYSCred")	"Saldo USD",
			IFNULL((SELECT "Rate" FROM ORTT WHERE "Currency"='USD' and "RateDate"=current_date),0)"TC"

	FROM OJDT T0  INNER JOIN JDT1 T1 ON T0."TransId" = T1."TransId" INNER JOIN OACT T2 ON T1."Account" = T2."AcctCode" --t1.account
	LEFT OUTER JOIN OJDT TX On T0."TransId" = TX."StornoToTr"
	LEFT JOIN OACT T6 ON T6."AcctCode" = T2."FatherNum" -- nivel 5
	LEFT JOIN OACT T7 ON T7."AcctCode" = T6."FatherNum" --nivel 4
	LEFT JOIN OACT T8 ON T8."AcctCode" = T7."FatherNum","TIPOCAMBIO_R" (:FECHAFIN) --nivel 2
	WHERE 
	IFNULL(T0."StornoToTr", '0') = '0' 
	AND (IFNULL(TX."RefDate",'')= '' OR IFNULL(TX."RefDate",'') > :FECHAFIN)
	AND T2."GroupMask" in (7) --activos, - balance
	AND T2."AcctName" <> 'INACTIVO'
	AND T0."RefDate" BETWEEN :FECHAINI and :FECHAFIN
	---------------------

	UNION
--

-----AGRUPACION nivel 5 / creditos - debitos PASIVO PATRIMONIO
	SELECT	DISTINCT 2 "query", 
			5 "nivel",
			0 "tipo",	
			2 "orden",	
			(CASE LEFT (T2."FormatCode",1) WHEN '2' THEN 2
			WHEN '3' THEN 3
			WHEN '7' THEN 5
			ELSE 0 END ) "ordenG",	
			LEFT(T2."FormatCode",10)		"Codigo_de_cuenta",
			T6."AcctName"		"Nombre de cuenta", 
			T1."TransId"			"Documento",
			T0."TransType"		"tipo documento",
			T0."RefDate" 		"Fecha Contabilizacion",
			T1."Line_ID"		"identificador_linea",
			(T1."Credit"-T1."Debit")	"Saldo BS",
			(T1."SYSCred"-T1."SYSDeb")"Saldo USD",
			IFNULL((SELECT "Rate" FROM ORTT WHERE "Currency"='USD' and "RateDate"=current_date),0)"TC"
	FROM OJDT T0  INNER JOIN JDT1 T1 ON T0."TransId" = T1."TransId" INNER JOIN OACT T2 ON T1."Account" = T2."AcctCode" 
	LEFT OUTER JOIN OJDT TX ON T0."TransId" = TX."StornoToTr"
	LEFT JOIN OACT T6 ON T6."AcctCode" = T2."FatherNum" -- nivel 5
	LEFT JOIN OACT T7 ON T7."AcctCode" = T6."FatherNum" --nivel 4
	LEFT JOIN OACT T8 ON T8."AcctCode" = T7."FatherNum" , "TIPOCAMBIO_R" (:FECHAFIN) --nivel 2
	WHERE 
	IFNULL(T0."StornoToTr", '0') = '0' 
	AND (IFNULL(TX."RefDate",'') = '' OR IFNULL(TX."RefDate",'') > :FECHAFIN )
	AND T2."GroupMask" IN (2, 3) --pasivo, patrimonio - balance
	AND T2."AcctName" <> 'INACTIVO'
	AND T0."RefDate" BETWEEN :FECHAINI AND :FECHAFIN
	-------
	UNION
-----AGRUPACION nivel 5 / debitos -  creditos ACTIVO
	SELECT	DISTINCT 2 "query", 
			5 "nivel",
			0 "tipo",	
			1 "orden",	
			(CASE LEFT (T2."FormatCode",1) WHEN '1' THEN 1
			WHEN '6' THEN 4
			--WHEN '8' THEN 4 
			ELSE 0 END )"ordenG",	
			LEFT(T2."FormatCode",10)		"Codigo_de_cuenta",
			T6."AcctName"		"Nombre de cuenta", 
			T1."TransId"			"Documento",
			T0."TransType"		"tipo documento",
			T0."RefDate"			"Fecha Contabilizacion",
			T1."Line_ID"			"identificador_linea",
			(T1."Debit"-T1."Credit")	"Saldo BS",
			(T1."SYSDeb"-T1."SYSCred")	"Saldo USD",
			IFNULL((SELECT "Rate" FROM ORTT WHERE "Currency"='USD' and "RateDate"=current_date),0)"TC"

	FROM OJDT T0  INNER JOIN JDT1 T1 ON T0."TransId" = T1."TransId" INNER JOIN OACT T2 ON T1."Account" = T2."AcctCode" --t1.account
	LEFT OUTER JOIN OJDT TX On T0."TransId" = TX."StornoToTr"
	LEFT JOIN OACT T6 ON T6."AcctCode" = T2."FatherNum" -- nivel 5
	LEFT JOIN OACT T7 ON T7."AcctCode" = T6."FatherNum" --nivel 4
	LEFT JOIN OACT T8 ON T8."AcctCode" = T7."FatherNum","TIPOCAMBIO_R" (:FECHAFIN) --nivel 2
	WHERE 
	IFNULL(T0."StornoToTr", '0') = '0' 
	AND (IFNULL(TX."RefDate",'')= '' OR IFNULL(TX."RefDate",'') > :FECHAFIN)
	AND T2."GroupMask" in (1) --activos, - balance
	AND T2."AcctName" <> 'INACTIVO'
	AND T0."RefDate" BETWEEN :FECHAINI and :FECHAFIN
	
	UNION
-----AGRUPACION nivel 5 / debitos -  creditos DEUDORA
	SELECT	DISTINCT 2 "query", 
			5 "nivel",
			0 "tipo",	
			2 "orden",	
			(CASE LEFT (T2."FormatCode",1) WHEN '1' THEN 1
			WHEN '6' THEN 6
			ELSE 0 END )"ordenG",	
			LEFT(T2."FormatCode",10)		"Codigo_de_cuenta",
			T6."AcctName"		"Nombre de cuenta", 
			T1."TransId"			"Documento",
			T0."TransType"		"tipo documento",
			T0."RefDate"			"Fecha Contabilizacion",
			T1."Line_ID"			"identificador_linea",
			(T1."Debit"-T1."Credit")	"Saldo BS",
			(T1."SYSDeb"-T1."SYSCred")	"Saldo USD",
			IFNULL((SELECT "Rate" FROM ORTT WHERE "Currency"='USD' and "RateDate"=current_date),0)"TC"

	FROM OJDT T0  INNER JOIN JDT1 T1 ON T0."TransId" = T1."TransId" INNER JOIN OACT T2 ON T1."Account" = T2."AcctCode" --t1.account
	LEFT OUTER JOIN OJDT TX On T0."TransId" = TX."StornoToTr"
	LEFT JOIN OACT T6 ON T6."AcctCode" = T2."FatherNum" -- nivel 5
	LEFT JOIN OACT T7 ON T7."AcctCode" = T6."FatherNum" --nivel 4
	LEFT JOIN OACT T8 ON T8."AcctCode" = T7."FatherNum","TIPOCAMBIO_R" (:FECHAFIN) --nivel 2
	WHERE 
	IFNULL(T0."StornoToTr", '0') = '0' 
	AND (IFNULL(TX."RefDate",'')= '' OR IFNULL(TX."RefDate",'') > :FECHAFIN)
	AND T2."GroupMask" in (6) --activos, - balance
	AND T2."AcctName" <> 'INACTIVO'
	AND T0."RefDate" BETWEEN :FECHAINI and :FECHAFIN
	UNION
-----AGRUPACION nivel 5 / debitos -  creditos ACREEDORA
	SELECT	DISTINCT 2 "query", 
			5 "nivel",
			0 "tipo",	
			1 "orden",	
			(CASE LEFT (T2."FormatCode",1) WHEN '1' THEN 1
			WHEN '7' THEN 7
			ELSE 0 END )"ordenG",	
			LEFT(T2."FormatCode",10)		"Codigo_de_cuenta",
			T6."AcctName"		"Nombre de cuenta", 
			T1."TransId"			"Documento",
			T0."TransType"		"tipo documento",
			T0."RefDate"			"Fecha Contabilizacion",
			T1."Line_ID"			"identificador_linea",
			(T1."Debit"-T1."Credit")	"Saldo BS",
			(T1."SYSDeb"-T1."SYSCred")	"Saldo USD",
			IFNULL((SELECT "Rate" FROM ORTT WHERE "Currency"='USD' and "RateDate"=current_date),0)"TC"

	FROM OJDT T0  INNER JOIN JDT1 T1 ON T0."TransId" = T1."TransId" INNER JOIN OACT T2 ON T1."Account" = T2."AcctCode" --t1.account
	LEFT OUTER JOIN OJDT TX On T0."TransId" = TX."StornoToTr"
	LEFT JOIN OACT T6 ON T6."AcctCode" = T2."FatherNum" -- nivel 5
	LEFT JOIN OACT T7 ON T7."AcctCode" = T6."FatherNum" --nivel 4
	LEFT JOIN OACT T8 ON T8."AcctCode" = T7."FatherNum","TIPOCAMBIO_R" (:FECHAFIN) --nivel 2
	WHERE 
	IFNULL(T0."StornoToTr", '0') = '0' 
	AND (IFNULL(TX."RefDate",'')= '' OR IFNULL(TX."RefDate",'') > :FECHAFIN)
	AND T2."GroupMask" in (7) --activos, - balance
	AND T2."AcctName" <> 'INACTIVO'
	AND T0."RefDate" BETWEEN :FECHAINI and :FECHAFIN;
	
	END