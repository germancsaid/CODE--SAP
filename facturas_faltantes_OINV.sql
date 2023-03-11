DECLARE Maximo INTEGER;
Maximo :=0;
SELECT MAX(CAST(T0."NumAtCard" AS INT)) INTO Maximo 
FROM OINV T0 INNER JOIN NNM1 T1 ON T0."Series" = T1."Series" WHERE T0."Series" ='[%0]';


--Nos da una lista de 1 a el numero maximo emitido de factura, funciona bien si se tienen muchas series.

SELECT DISTINCT CAST(T0."NumAtCard" AS INT) AS "Nro Faltante" 
FROM OINV T0 WHERE CAST(T0."NumAtCard" AS INT) <= Maximo AND CAST(T0."NumAtCard" AS INT) NOT IN 
(SELECT CAST(T0."NumAtCard" AS INT) FROM OINV T0 WHERE T0."Series" = '[%0]' ORDER BY CAST(T0."NumAtCard" AS INT) ASC) ORDER BY CAST(T0."NumAtCard" AS INT) ASC;
