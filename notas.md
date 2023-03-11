# Querys_for_sap_b1_hana_sql
In this place...Comandos importantes
https://hanasc93:40000/ControlCenter
https://hanasc93:40000/ExtensionManager
------------------------------------------------------------------------------------------------------
root 		B1Admin1$
B1SiteUser	B1Admin1$
B1ADMIN		B1Admin1$
------------------------------------------------------------------------------------------------------
IMPORT "Z_BASEINI"."*" AS BINARY FROM
'/sapbackup/schema/vtardio/' WITH IGNORE EXISTING THREADS 8
RENAME SCHEMA "Z_BASEINI" TO "BD_PLASTICSUR"
-------------------------------------------------------------------------------------------------------
mkdir NombreCarpeta			// Para crear una carpeta
chmod 777 NombreCarpeta			// Para dar permiso a las carpetas
tar -zcvf Nombre.tar.gz export/ index/  // LLegar al listado  para comprimir 

tar -xzvf archivo.tar.gz    		// para descomprimir
tar -xvzf archivo.tgz
-rm -r NombreArchivo			// para eliminar
sudo systemctl restart b1s		// para reiniciar Service Layer
/etc/init.d/b1s restart
df					// para ver el espacio del server
/etc/init.d/sapb1servertools            // reiniciar servicios sap restart start stop

ls					// visualizar carpetas en linux
..					// retroceder carpetas

-------------------------------------------------------------------------------------------------------
Ip Pública: 190.181.61.166:3390
    hanasc93:30015
IP:  10.2.0.151

User: GETSAP\
Pass:

HANA:
------
Hanastudio: B1Admin
Pass: B1Admin1$
WinSCP:
------
SFTP, puerto 22
10.2.0.150

User: root
pass: B1Admin1$
----------------------
B1SiteUser = B1Admin1$
DRIVER={B1CRHPROXY32};SERVERNODE=hanab1:30015;DATABASE=TAJIBOS_PRD
Select * From PLANILLA_GENERAL('{?@PLA}','{?@GEST}', '{?PROY}','{?SUC}')
