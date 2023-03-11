IF (object_type = '17' and (transaction_type ='A' OR transaction_type ='U')) --0
    THEN
    DECLARE VALRDR INT;

    SELECT COUNT(T0."DocEntry") INTO VALRDR
    FROM RDR1 T0
    INNER JOIN OITW T1 ON T1."ItemCode" = T0."ItemCode" AND T1."WhsCode" = T0."WhsCode"
    WHERE T0."DocEntry" = list_of_cols_val_tab_del AND (T1."OnHand"-T1."IsCommited"+T1."OnOrder"+T0."Quantity") < T0."Quantity" AND
    (T0."U_VTAEXT" = 'NO' AND T0."U_VTATRA"='NO' AND T0."U_VTAOR"='NO');
    IF :VALRDR > 0 THEN --1
        error:='7001';   
        error_message:='La cantidad reservada sobrepasa el disponible.';
    ELSE --1
        SELECT COUNT(T0."DocEntry") INTO VALRDR
        FROM RDR1 T0
        INNER JOIN OITW T1 ON T1."ItemCode" = T0."ItemCode" AND T1."WhsCode" = T0."WhsCode"
        INNER JOIN (SELECT "ItemCode", ("OnHand"-"IsCommited"+"OnOrder") AS "DispEXT" FROM OITW WHERE "WhsCode" = 'DIS-EXT') 
                        T2 ON T2."ItemCode" = T0."ItemCode"
        WHERE T0."DocEntry" = list_of_cols_val_tab_del AND (T1."OnHand"-T1."IsCommited"+T1."OnOrder"+T0."Quantity"+T2."DispEXT") < T0."Quantity" AND
        (T0."U_VTAEXT" = 'SI' AND T0."U_VTATRA"='NO' AND T0."U_VTAOR"='NO');
        IF :VALRDR > 0 THEN --2
            error:='7002';   
            error_message:='La cantidad en almacen + DIS-EXT abastece el requerimiento.';
        ELSE --2
            SELECT COUNT(T0."DocEntry") INTO VALRDR
            FROM RDR1 T0
            INNER JOIN OITW T1 ON T1."ItemCode" = T0."ItemCode" AND T1."WhsCode" = T0."WhsCode"
            INNER JOIN (SELECT "ItemCode", ("OnHand"-"IsCommited"+"OnOrder") AS "DispTRA" FROM OITW WHERE "WhsCode" = 'DIS-TRA') 
                            T2 ON T2."ItemCode" = T0."ItemCode"
            WHERE T0."DocEntry" = list_of_cols_val_tab_del AND (T1."OnHand"-T1."IsCommited"+T1."OnOrder"+T0."Quantity"+T2."DispTRA") < T0."Quantity" AND
            (T0."U_VTAEXT" = 'NO' AND T0."U_VTATRA"='SI' AND T0."U_VTAOR"='NO');
            IF :VALRDR > 0 THEN --3
                error:='7003';   
                error_message:='La cantidad en almacen + DIS-TRA abastece el requerimiento.';
            ELSE --3
                SELECT COUNT(T0."DocEntry") INTO VALRDR
                FROM RDR1 T0
                INNER JOIN OITW T1 ON T1."ItemCode" = T0."ItemCode" AND T1."WhsCode" = T0."WhsCode"
                INNER JOIN (SELECT "ItemCode", ("OnHand"-"IsCommited"+"OnOrder") AS "DispOR" FROM OITW WHERE "WhsCode" = 'DIS-OR') 
                                T2 ON T2."ItemCode" = T0."ItemCode"
                WHERE T0."DocEntry" = list_of_cols_val_tab_del AND (T1."OnHand"-T1."IsCommited"+T1."OnOrder"+T0."Quantity"+T2."DispOR") < T0."Quantity" AND
                (T0."U_VTAEXT" = 'NO' AND T0."U_VTATRA"='NO' AND T0."U_VTAOR"='SI');
                IF :VALRDR > 0 THEN --4
                    error:='7004';   
                    error_message:='La cantidad en almacen + DIS-OR abastece el requerimiento.';
                ELSE --4
                    SELECT COUNT(T0."DocEntry") INTO VALRDR
                    FROM RDR1 T0
                    INNER JOIN OITW T1 ON T1."ItemCode" = T0."ItemCode" AND T1."WhsCode" = T0."WhsCode"
                    INNER JOIN (SELECT "ItemCode", ("OnHand"-"IsCommited"+"OnOrder") AS "DispTRA" FROM OITW WHERE "WhsCode" = 'DIS-TRA') 
                                    T2 ON T2."ItemCode" = T0."ItemCode"
                    INNER JOIN (SELECT "ItemCode", ("OnHand"-"IsCommited"+"OnOrder") AS "DispOR" FROM OITW WHERE "WhsCode" = 'DIS-OR') 
                                    T3 ON T3."ItemCode" = T0."ItemCode"
                    WHERE T0."DocEntry" = list_of_cols_val_tab_del AND (T1."OnHand"-T1."IsCommited"+T1."OnOrder"+T0."Quantity"+T2."DispTRA"+T3."DispOR") < T0."Quantity" AND 
                    (T0."U_VTAEXT" = 'NO' AND T0."U_VTATRA"='SI' AND T0."U_VTAOR"='SI');
                    IF :VALRDR > 0 THEN --5
                        error:='7005';   
                        error_message:='La cantidad en almacen + DIS-TRA + DIS-OR abastece el requerimiento.';
                    ELSE --5
                        SELECT COUNT(T0."DocEntry") INTO VALRDR
                        FROM RDR1 T0
                        INNER JOIN OITW T1 ON T1."ItemCode" = T0."ItemCode" AND T1."WhsCode" = T0."WhsCode"               
                        INNER JOIN (SELECT "ItemCode", ("OnHand"-"IsCommited"+"OnOrder") AS "DispEXT" FROM OITW WHERE "WhsCode" = 'DIS-EXT') 
                                        T2 ON T2."ItemCode" = T0."ItemCode"
                        INNER JOIN (SELECT "ItemCode", ("OnHand"-"IsCommited"+"OnOrder") AS "DispOR" FROM OITW WHERE "WhsCode" = 'DIS-OR') 
                                        T3 ON T3."ItemCode" = T0."ItemCode"
                        WHERE T0."DocEntry" = list_of_cols_val_tab_del AND (T1."OnHand"-T1."IsCommited"+T1."OnOrder"+T0."Quantity"+T2."DispEXT"+T3."DispOR") < T0."Quantity" AND 
                        (T0."U_VTAEXT" = 'SI' AND T0."U_VTATRA"='NO' AND T0."U_VTAOR"='SI');
                        IF :VALRDR > 0 THEN --6
                            error:='7006';   
                            error_message:='La cantidad en almacen + DIS-EXT + DIS-OR abastece el requerimiento.';
                        ELSE --6
                            SELECT COUNT(T0."DocEntry") INTO VALRDR
                            FROM RDR1 T0
                            INNER JOIN OITW T1 ON T1."ItemCode" = T0."ItemCode" AND T1."WhsCode" = T0."WhsCode"
                            INNER JOIN (SELECT "ItemCode", ("OnHand"-"IsCommited"+"OnOrder") AS "DispEXT" FROM OITW WHERE "WhsCode" = 'DIS-EXT') 
                                            T2 ON T2."ItemCode" = T0."ItemCode"
                            INNER JOIN (SELECT "ItemCode", ("OnHand"-"IsCommited"+"OnOrder") AS "DispTRA" FROM OITW WHERE "WhsCode" = 'DIS-TRA') 
                                            T3 ON T3."ItemCode" = T0."ItemCode"
                            WHERE T0."DocEntry" = list_of_cols_val_tab_del AND (T1."OnHand"-T1."IsCommited"+T1."OnOrder"+T0."Quantity"+T2."DispEXT"+T3."DispTRA") < T0."Quantity" AND 
                            (T0."U_VTAEXT" = 'SI' AND T0."U_VTATRA"='SI' AND T0."U_VTAOR"='NO');
                            IF :VALRDR > 0 THEN --7
                                error:='7007';   
                                error_message:='La cantidad en almacen + DIS-EXT + DIS-TRA abastece el requerimiento.';
                            ELSE --7
                                SELECT COUNT(T0."DocEntry") INTO VALRDR
                                FROM RDR1 T0
                                INNER JOIN OITW T1 ON T1."ItemCode" = T0."ItemCode" AND T1."WhsCode" = T0."WhsCode"
                                INNER JOIN (SELECT "ItemCode", ("OnHand"-"IsCommited"+"OnOrder") AS "DispEXT" FROM OITW WHERE "WhsCode" = 'DIS-EXT') 
                                                T2 ON T2."ItemCode" = T0."ItemCode"
                                INNER JOIN (SELECT "ItemCode", ("OnHand"-"IsCommited"+"OnOrder") AS "DispTRA" FROM OITW WHERE "WhsCode" = 'DIS-TRA') 
                                                T3 ON T3."ItemCode" = T0."ItemCode"
                                INNER JOIN (SELECT "ItemCode", ("OnHand"-"IsCommited"+"OnOrder") AS "DispOR" FROM OITW WHERE "WhsCode" = 'DIS-OR') 
                                                T4 ON T4."ItemCode" = T0."ItemCode"
                                WHERE T0."DocEntry" = list_of_cols_val_tab_del AND (T1."OnHand"-T1."IsCommited"+T1."OnOrder"+T0."Quantity"+T2."DispEXT"+T3."DispTRA"+T4."DispOR") < T0."Quantity" AND 
                                (T0."U_VTAEXT" = 'SI' AND T0."U_VTATRA"='SI' AND T0."U_VTAOR"='SI');
                                IF :VALRDR > 0 THEN --8
                                    error:='7008';   
                                    error_message:='La cantidad en almacen + DIS-EXT + DIS-TRA + DIS-OR abastece el requerimiento.';
                                ELSE --8
                                    SELECT COUNT(T0."DocEntry") INTO VALRDR
                                    FROM RDR1 T0
                                    INNER JOIN OITW T1 ON T1."ItemCode" = T0."ItemCode" AND T1."WhsCode" = T0."WhsCode"
                                    WHERE T0."DocEntry" = list_of_cols_val_tab_del AND (T1."OnHand"-T1."IsCommited"+T1."OnOrder"+T0."Quantity") < T0."Quantity"
                                    AND NOT (T0."WhsCode" = 'DIS-CEN' OR T0."WhsCode" = 'DIS-GRI' OR T0."WhsCode" = 'DIS-OUT');
                                    IF :VALRDR > 0 THEN --9
                                        error:='7009';   
                                        error_message:='La cantidad reservada sobrepasa el disponible.';
                                    END IF; --9
                                END IF; --8
                            END IF; --7
                        END IF; --6
                    END IF; --5
                END IF; --4
            END IF; --3
        END IF; --2
    END IF; --1
END IF; --0
