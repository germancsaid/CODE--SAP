CREATE PROCEDURE spFacturav3
(
	in DocEntry varchar(9),
	in ObjType int
)
--WITH ENCRYPTION
AS
   
--set dateformat dmy
--set language spanish
-- call spFacturav2('22',13);
BEGIN
	select 
	t0."DocEntry" DocEntry, 
	t0."DocNum" DocNum,
	t0."DocDate" Fecha,
	--T0.U_NUM_FACT 'Numero de factura',
	t0."NumAtCard" as "Numero de factura",
	--T0.CardCode 'Razon Social',
	case T0."DocSubType" when 'IB' then T0."CardName" else t0."U_RAZSOC" end as "Razon Social",
	--T0.LicTradNum 'NIT',
	t0."U_NIT" NIT, 
	t0."U_NROAUTOR" as "Numero de Autorizacion",
	CASE WHEN t0."U_NROAUTOR" = t3."U_NROORDEN"	THEN T3."U_LEYENDA"	ELSE '' END Leyenda,
	CASE WHEN t0."U_NROAUTOR" = t3."U_NROORDEN"	THEN T3."U_ACTIVIDAD" ELSE '' END Actividad,
	t0."U_FECHALIM" as "Fecha fin Dosificación",
	t0."U_CODCTRL" as "Codigo de Control",
	t0."DocTotalSy" as "Total USD",
	--t0.Series,
	t0."Printed" Printed,
	T0."U_ICE" ICE,
	T0."U_EXENTO" EXENTO,
	--T0."DiscSum"/0.87 
	ROUND( (
		(CASE WHEN  'BS'= (SELECT TOP 1 "MainCurncy"  FROM OADM) 
					THEN T0."DocTotal" 
					WHEN 'BS'= (SELECT TOP 1 "SysCurrncy"  FROM OADM) 
					THEN T0."DocTotalSy" 
					ELSE T0."DocTotalFC" 
					END 	) *
		((100	/(100-IFNULL(T0."DiscPrcnt",0))) - 1)
		
		)
		 ,2)
	as "Descuento Cabecera",
	--T0."DiscSumSy"/0.87 
	ROUND( (
		(CASE WHEN  'USD'= (SELECT TOP 1 "MainCurncy"  FROM OADM) 
					THEN T0."DocTotal" 
					WHEN 'USD'= (SELECT TOP 1 "SysCurrncy"  FROM OADM) 
					THEN T0."DocTotalSy" 
					ELSE T0."DocTotalFC" 
					END 	) *
		((100	/(100-IFNULL(T0."DiscPrcnt",0))) - 1)
		
		),2)
	as "Descuento Cabecera USD",
	--ifnull(T1."U_DESCLINEA",0) 
(
			 	(T1."PriceAfVAT"* --case when t2."Currency" = 'BS' AND (SELECT TOP 1 "MainCurncy"  FROM OADM) = t2."Currency"  then  CASE WHEN T2."Rate">0 THEN T2."Rate" ELSE 1 END  ELSE 1 END)
				CASE WHEN  t1."Currency" = 'BS' THEN 1 ELSE
					CASE WHEN (SELECT TOP 1 "MainCurncy"  FROM OADM)='BS' THEN  T1."Rate" ELSE 
								(SELECT  "Rate" FROM ORTT  WHERE  "Currency" ='BS' AND   "RateDate"= T0."DocDate")
					END
				END		)
				*((100	/(100-IFNULL(T1."DiscPrcnt",0))) - 1 )
		
		*
		(CASE WHEN T0."DocType"= 'S' then 1 else   T1."Quantity" end) ) 

	
	as "Descuento Linea",
	T0."U_TASACERO" as "Tasa Cero",
	t1."PriceBefDi" as "Precio Unitario Neto",
	(
		select max(i0."Street") from CRD1 i0
		where i0."CardCode" = t7."CardCode"	and i0."AdresType" = 'S' and i0."Address" not like '%Ship to%'
	)Direccion,

	t0."DocTotal" as "Total BS",
	t0."Comments" Observaciones, 
	t1."ItemCode" Codigo,
	t1."Dscription" as "Descripción",
	t1."FreeTxt" ComentarioLineas,
	case when t5."InvntItem"='Y' or t5."TreeType"<>'N' then t1."Quantity" else 0 end Cantidad,
	t1."PriceAfVAT" as "Valor Unitario sin Moneda",
	t1."GTotal" as "Total Lineas BS",
	t1."GTotalSC" as "Total Lineas USD",
	t11."City" as "Ciudad_Empresa",
	CASE WHEN ifnull(T12."LogoFile",'')='' THEN '' ELSE cast(T12."BitmapPath" as nvarchar(100))||'\'||T12."LogoFile" END LogoFile,
	ifnull(cast(T10."TaxIdNum" as varchar(32)),'0') NIT_Empresa,
	IFNULL(T13."Title",'')||ifnull(' '||T13."FirstName",'')||ifnull(' '||T13."LastName",'') Contacto,
	t3."U_DIRECCION" Dir_SUC,
	t3."U_TELEFONO" Tel_SUC,
	ifnull(t3."U_CIUDAD",T11."City") Ciudad_SUC,
	t3."U_PAIS" Pais_SUC,
	T10."CompnyName" Nombre_Empresa,
	t11."Street" Dir_Empresa,
	t10."Phone1" Tel_Empresa,
	t10."Fax" Fax_Empresa,
	case when t1."TargetType"<>'-1' then 'A' else '' end Estado,
	T3."U_SUCURSAL" Sucursal,
	CASE T0."Printed" WHEN 'Y' THEN 'COPIA' ELSE 'ORIGINAL' END Original_Copia,
	T9."SlpName" Vendedor,
	t0."DocCur" as "Moneda documento"
	, IFNULL(T3."U_DIRECCION",'') DireccionSucursal
	, IFNULL(T3."U_CIUDAD",'') CiudadSucursal
	, IFNULL(T3."U_PAIS",'') PaisSucursal
	, IFNULL(T3."U_SUCURSAL",'') NombreSucursal
	FROM OINV t0 inner join INV1 t1 on t0."DocEntry" = t1."DocEntry"
							left join OITM t5 on t5."ItemCode" = t1."ItemCode" 
							inner join OJDT t4 on T4."TransId" = T0."TransId"
							inner join OCRD t7 on t7."CardCode" = t0."CardCode"
							inner join OCTG t8 on t8."GroupNum" = t0."GroupNum" 
							inner join OSLP t9 on t9."SlpCode" = t0."SlpCode" 
							inner join NNM1 t2 on t2."Series" = t0."Series"   
							 Left join "@LB_CDC_DOS" t3 on t3."U_SERIE" = t2."SeriesName" and t0."U_NROAUTOR"=t3."U_NROORDEN"  AND (T0."U_SERIECOD" = T3."Code") --and t3."U_ACTIVA" = 'SI'
							 left join OCPR T13 on T0."CardCode"=T13."CardCode" and T0."CntctCode"=T13."CntctCode"
							 
							 ,OADM T10,ADM1 t11, OADP T12
	where t0."DocEntry" = DocEntry and t0."ObjType" = '13'

	UNION ALL

	select 
	t0."DocEntry" DocEntry, 
	t0."DocNum" DocNum,
	t0."DocDate" Fecha,
	--T0.U_NUM_FACT 'Numero de factura',
	t0."NumAtCard" as "Numero de factura",
	--T0.CardCode 'Razon Social',
	case T0."DocSubType" when 'IB' then T0."CardName" else t0."U_RAZSOC" end as "Razon Social",
	--T0.LicTradNum 'NIT',
	t0."U_NIT" NIT,
	t0."U_NROAUTOR" as "Numero de Autorizacion",

	case when t0."U_NROAUTOR" = t3."U_NROORDEN" THEN T3."U_LEYENDA"	ELSE '' END Leyenda,

	case when t0."U_NROAUTOR" = t3."U_NROORDEN"	THEN T3."U_ACTIVIDAD" ELSE '' END Actividad,

	t0."U_FECHALIM" as "Fecha fin Dosificación",
	t0."U_CODCTRL" as "Codigo de Control",
	t0."DocTotalSy" as "Total USD",
	--t0.Series,
	t0."Printed" Printed,
	T0."U_ICE" ICE,
	T0."U_EXENTO" EXENTO,
	--T0."DiscSum"/0.87 
	ROUND((
		(CASE WHEN  'BS'= (SELECT TOP 1 "MainCurncy"  FROM OADM) 
					THEN T0."DocTotal" 
					WHEN 'BS'= (SELECT TOP 1 "SysCurrncy"  FROM OADM) 
					THEN T0."DocTotalSy" 
					ELSE T0."DocTotalFC" 
					END 	) *
		((100	/(100-IFNULL(T0."DiscPrcnt",0))) - 1)
		
		)
		 ,2)
	as "Descuento Cabecera",
	--T0."DiscSumSy"/0.87 
	ROUND((
		(CASE WHEN  'USD'= (SELECT TOP 1 "MainCurncy"  FROM OADM) 
					THEN T0."DocTotal" 
					WHEN 'USD'= (SELECT TOP 1 "SysCurrncy"  FROM OADM) 
					THEN T0."DocTotalSy" 
					ELSE T0."DocTotalFC" 
					END 	) *
		((100	/(100-IFNULL(T0."DiscPrcnt",0))) - 1)
		
		)
		 ,2)
	as "Descuento Cabecera USD",
	--ifnull(T1."U_DESCLINEA",0) 
	(
			 	(T1."PriceAfVAT"* --case when t2."Currency" = 'BS' AND (SELECT TOP 1 "MainCurncy"  FROM OADM) = t2."Currency"  then  CASE WHEN T2."Rate">0 THEN T2."Rate" ELSE 1 END  ELSE 1 END)
				CASE WHEN  t1."Currency" = 'BS' THEN 1 ELSE
					CASE WHEN (SELECT TOP 1 "MainCurncy"  FROM OADM)='BS' THEN  T1."Rate" ELSE 
								(SELECT  "Rate" FROM ORTT  WHERE  "Currency" ='BS' AND   "RateDate"= T0."DocDate")
					END
				END		)
				*((100	/(100-IFNULL(T1."DiscPrcnt",0))) - 1 )
		
		*
		(CASE WHEN T0."DocType"= 'S' then 1 else   T1."Quantity" end) ) 
	
	as "Descuento Linea",
	T0."U_TASACERO" as "Tasa Cero",
	t1."PriceBefDi" as "Precio Unitario Neto",
	(
		select max(i0."Street") from CRD1 i0
		where i0."CardCode" = t7."CardCode"	and i0."AdresType" = 'S' and i0."Address" not like '%Ship to%'
	)Direccion,

	t0."DocTotal" as "Total BS",
	t0."Comments" as Observaciones, 
	t1."ItemCode" Codigo,
	t1."Dscription" as "Descripción",
	t1."FreeTxt" ComentarioLineas,
	case when t5."InvntItem"='Y' or t5."TreeType"<>'N' then t1."Quantity" else 0 end Cantidad,
	t1."PriceAfVAT" as "Valor Unitario sin Moneda",
	t1."GTotal" as "Total Lineas BS",
	t1."GTotalSC" as "Total Lineas USD",
	t11."City" as "Ciudad_Empresa",
	CASE WHEN ifnull(T12."LogoFile",'')='' THEN '' ELSE cast(T12."BitmapPath" as nvarchar(100))||'\'||T12."LogoFile" END LogoFile,
	ifnull(cast(T10."TaxIdNum" as varchar(32)),'0') NIT_Empresa,
	IFNULL(T13."Title",'')||ifnull(' '||T13."FirstName",'')||ifnull(' '||T13."LastName",'') Contacto,
	t3."U_DIRECCION" Dir_SUC,
	t3."U_TELEFONO" Tel_SUC,
	ifnull(t3."U_CIUDAD",T11."City") Ciudad_SUC,
	t3-."U_PAIS" Pais_SUC,
	T10."CompnyName" Nombre_Empresa,
	t11."Street" Dir_Empresa,
	t10."Phone1" Tel_Empresa,
	t10."Fax" Fax_Empresa,
	case when t1."TargetType"<>'-1' then 'A' else '' end Estado,
	T3."U_SUCURSAL" Sucursal,
	'BORRADOR - DOCUMENTO NO VÁLIDO' Original_Copia,
	T9."SlpName" Vendedor,
	t0."DocCur" as "Moneda documento"
	, IFNULL(T3."U_DIRECCION",'') DireccionSucursal
	, IFNULL(T3."U_CIUDAD",'') CiudadSucursal
	, IFNULL(T3."U_PAIS",'') PaisSucursal
	, IFNULL(T3."U_SUCURSAL",'') NombreSucursal
	From ODRF t0 inner join DRF1 t1 on t0."DocEntry" = t1."DocEntry" and t0."ObjType"=t1."ObjType"
							left join OITM t5 on t5."ItemCode" = t1."ItemCode" 
							--inner join OJDT t4 on T4.TransId = T0.TransId
							inner join OCRD t7 on t7."CardCode" = t0."CardCode"
							inner join OCTG t8 on t8."GroupNum" = t0."GroupNum" 
							inner join OSLP t9 on t9."SlpCode" = t0."SlpCode" 
							inner join NNM1 t2 on t2."Series" = t0."Series"   
							Left join "@LB_CDC_DOS" t3 on t3."U_SERIE" = t2."SeriesName" and t0."U_NROAUTOR"=t3."U_NROORDEN" AND (T0."U_SERIECOD" = T3."Code") and t3."U_ACTIVA" = 'SI'
							left join OCPR T13 on T0."CardCode"=T13."CardCode" and T0."CntctCode"=T13."CntctCode"
							 ,OADM T10,ADM1 t11, OADP T12
	where t0."DocEntry" = DocEntry and t0."ObjType" = '13' and (SELECT count(*) FROM OINV WHERE "DocEntry"=DocEntry)=0;


END;