--*********** Inventory Transfer ***********
IF object_type = '67' and (transaction_type = 'U' or transaction_type = 'A') 
THEN call ACB_TN_OWTR (list_of_cols_val_tab_del, transaction_type, error, error_message);
END IF;


ALTER PROCEDURE ACB_TN_OWTR (in id nvarchar(255), in transtype varchar(1), out error int, out errormsg nvarchar(200))

AS BEGIN                                                                                                  --0

IF (transtype = 'U' or transtype = 'A') THEN                                                              --1
    DECLARE NUM INT := 0;

    SELECT COUNT(T0."DocEntry") INTO NUM
    FROM OWTR T0
    WHERE T0."DocEntry" = id
    AND (T0."Filler" <> 
        (SELECT T2."Warehouse" 
        FROM OWTR T0  
        INNER JOIN OUSR T1 ON T0."UserSign" = T1."USERID" 
        INNER JOIN OUDG T2 ON T1."DfltsGroup" = T2."Code"
        WHERE T0."DocEntry" = id )
    );

    IF :NUM > 0 THEN                                                                                      --2
        error := 1;
        errormsg := 'La "Transferencia de stock" de este almacen origen hace mediante una "Solicitud de traslado"';
    END IF;                                                                                               --2
END IF;                                                                                                   --1

END;                                                                                                      --0