CREATE PROCEDURE ACB_TN_OPCH (in id nvarchar(255), in transtype varchar(1), out error int, out errormsg nvarchar(200))
AS
BEGIN
-- APZ: VALIDACIONES PARA FACTURA DE PROVEEDORES

	IF (transtype='A' or transtype='U') --1
	THEN
	
		DECLARE NUM INT:=0;

		SELECT count(t0."DocEntry") into NUM
		FROM OPCH t0 inner join PCH1 t1 ON t0."DocEntry" = t1."DocEntry"
			inner join OITM t3 on t3."ItemCode" = t1."ItemCode" 
			inner join OITB t4 on t4."ItmsGrpCod" = t3."ItmsGrpCod"
			left join OWHS t2 on t2."WhsCode"=t1."WhsCode"
		WHERE t0."DocEntry" = id
			and (/*t4."ItmsGrpCod" = '101' or*/ t2."U_TIPO"='01') ---Grupo de Articulos Importacíón 
			and (ifnull(t1."Project",'')='' or ifnull(t0."Project",'')  = '');
			
		IF :NUM>0
		THEN --2
			error:= 18;
			errormsg := 'El campo "Código de proyecto" es obligatorio en un proceso de importación.';
			NUM:=0;
		ELSE --2

			SELECT count(t0."DocEntry") into NUM
			FROM OPCH t0 inner join PCH1 t1 ON t0."DocEntry" = t1."DocEntry"
				INNER JOIN OPRJ T2 on t1."Project"=T2."PrjCode" or t0."Project"=T2."PrjCode"
				INNER JOIN OITM T3 on t1."ItemCode"=T3."ItemCode"
			WHERE t0."DocEntry" = id and T3."InvntItem"='Y' and T2."U_TIPO"='02';			
			
			IF :NUM>0
			THEN --3
				error := 18;
				errormsg := 'La factura de proveedores solo puede ser asignada a un proyecto de tipo importación';
				NUM := 0;
			ELSE --3
								
				SELECT MAX("LineNum") + 1 into NUM
				FROM PCH1 
				WHERE "DocEntry" = id AND "Price" = 0;
				
				IF IFNULL(:NUM, -1) <> -1 
				THEN --4
					error := 18;
					errormsg := 'La linea '|| CAST(NUM AS VARCHAR (10)) || ' tiene costo 0.';
					NUM:=0;
				END IF;--4
			END IF; --3
		END IF; --2

	END	IF;--1	

END;





