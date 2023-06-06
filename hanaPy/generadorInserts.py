# definir los valores del nuevo usuario
id = 1
nombre = "Juan"
edad = 25

# crear cadena de SQL INSERT
cadena_sql = 'insert into "AF_GANASEGUROS_QA"."TPACTF" values({id}, {nombre}, {edad});'

# formatear la cadena de SQL INSERT con los valores definidos
cadena_sql_formateada = cadena_sql.format(id=id, nombre=nombre, edad=edad)

# imprimir cadena de SQL INSERT formateada
print(cadena_sql_formateada)