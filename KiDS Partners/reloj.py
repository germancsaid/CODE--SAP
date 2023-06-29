import datetime
import time

# Definir la diferencia horaria en horas para GTM +4
diferencia_horaria = -4

while True:
    # Obtener la hora actual
    hora_actual = datetime.datetime.utcnow() + datetime.timedelta(hours=diferencia_horaria)
    
    # Formatear la hora actual
    hora_formateada = hora_actual.strftime('%H:%M:%S')
    
    # Imprimir la hora
    print('Hora GTM -4:', hora_formateada)
    
    # Esperar un segundo
    time.sleep(1)