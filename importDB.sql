--para importar y sobreescribir una base de datos
IMPORT "NAME_PRD"."*" AS BINARY FROM
'C:/sap/carpeta' WITH IGNORE EXISTING THREADS 8
RENAME SCHEMA "NAME_PRD" TO "NEW_NAME";
