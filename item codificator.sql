SELECT CONCAT(
  CONCAT(
  CASE WHEN $[OITM."U_Nivel3"] = '' THEN CONCAT(SUBSTR($[OITM."U_Nivel2"],1,4),'.00') ELSE SUBSTR($[OITM."U_Nivel3"],1,7) END,
  CASE WHEN $[OITM."U_Nivel4"] = '' THEN '.000' ELSE SUBSTR($[OITM."U_Nivel4"],8,4) END
  ),
  CASE WHEN $[OITM."U_Nivel5"] = '' THEN '.000' ELSE SUBSTR($[OITM."U_Nivel5"],12,4) END
  )  
  AS ItemCode FROM DUMMY