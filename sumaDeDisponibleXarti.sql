--esto suma los disponibles de almacen DIS-CEN && DIS-OR
--solo de un articulo que es la variable
SELECT SUM("Disponible") 
FROM(SELECT T0."ItemCode", T0."WhsCode",(T0."OnHand"-T0."IsCommited"+T0."OnOrder") AS "Disponible" 
    FROM OITW T0 
    WHERE T0."WhsCode" = 'DIS-CEN' OR T0."WhsCode" = 'DIS-OR' 
    ORDER BY T0."ItemCode")
WHERE "ItemCode" = 'CER0000116' --AQUI VA UNA VARIABLE


--------------------------------------------------------------------------------------------------------------------------------
/******************** NOTA DE VENTA ********************/
--------------------------------------------------------------------------------------------------------------------------------

IF (object_type = '17' and (transaction_type ='A' OR transaction_type ='U'))
THEN 

DECLARE Suma BIGINT;
DECLARE Limite BIGINT;
DECLARE ValidacionDisponible INT:=0;

SELECT SUM("Disponible") INTO Suma
FROM(SELECT T1."ItemCode", T1."WhsCode",((T1."OnHand"-T1."IsCommited"+T1."OnOrder")*999999999999999) AS "Disponible" 
    FROM OITW T1
    INNER JOIN RDR1 T0 ON T1."ItemCode" = T0."ItemCode" 
    WHERE (T1."WhsCode" = 'DIS-CEN' OR T1."WhsCode" = 'DIS-OR') 
    AND T0."DocEntry" = list_of_cols_val_tab_del);
    
SELECT Suma+2 INTO Limite FROM DUMMY; 
--< >
--EL SELECT DEBE SALIR VACIO PARA QUE PASE LA VALIDACION
SELECT COUNT(T0."DocEntry") INTO ValidacionDisponible
FROM RDR1 T0 
INNER JOIN OITM T1 ON T0."ItemCode" = T1."ItemCode" 
INNER JOIN OITW T2 ON T1."ItemCode" = T2."ItemCode" 
WHERE T0."DocEntry" = list_of_cols_val_tab_del AND T1."InvntItem" = 'Y' AND T0."WhsCode" = T2."WhsCode" 
AND ((T0."Quantity")<=Limite+(T0."Quantity")); --AND T0."U_VTAEXT" = 'NO';
--no permite poner cantidad mayor que los almacenes
IF :ValidacionDisponible = 0 THEN
error:='101';	
error_message:='Cantidad disponible total en almacen DIS-CEN + DIS-OR, no abastecen la candidad que requiere.';
--error_message:=Limite;
END IF;
END IF;	
