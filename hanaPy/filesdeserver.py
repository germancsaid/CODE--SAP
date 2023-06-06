import paramiko

# Configuración de la conexión SSH
hostname = "200.105.198.6"
port = 10203
username = "actialisap\gtardio"
password = "Acb2020."

# Iniciar la conexión SSH
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(hostname, port, username, password)

# Ejecutar el comando para cambiar de directorio
stdin, stdout, stderr = ssh.exec_command("cd..")

# Imprimir la salida del comando
print(stdout.read().decode())

# Ejecutar el comando para listar los archivos y directorios
stdin, stdout, stderr = ssh.exec_command("ls")

# Imprimir la salida del comando
print(stdout.read().decode())

# Cerrar la conexión SSH
ssh.close()