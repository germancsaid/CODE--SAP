import pyautogui

# Abre la aplicación de conexión remota
pyautogui.hotkey('alt', 'tap')

1. Automatización de tareas con el mouse y el teclado:

La biblioteca pyautogui permite automatizar tareas utilizando el mouse y el teclado de una computadora. Algunas de las funciones y métodos más útiles para la automatización son:

pyautogui.moveTo(x, y, duration=0.0, tween=pyautogui.linear): mueve el cursor del mouse a la posición (x, y) en la pantalla. Los parámetros opcionales duration y tween controlan la velocidad y el movimiento suave del cursor.
pyautogui.click(x=None, y=None, button='left', clicks=1, interval=0.0, duration=0.0, tween=pyautogui.linear): realiza un clic en la posición (x, y) con el botón especificado. Los parámetros opcionales clicks, interval, duration y tween controlan el número de clics, el intervalo entre clics, la duración del clic y el movimiento suave del cursor.
pyautogui.typewrite(message, interval=0.0): escribe el mensaje especificado utilizando el teclado. El parámetro opcional interval controla el tiempo entre pulsaciones de teclas.
pyautogui.press(key, presses=1, interval=0.0): presiona la tecla especificada presses veces. El parámetro opcional interval controla el tiempo entre pulsaciones de teclas.
pyautogui.hotkey(key1, key2, ..., keys='shift', interval=0.0): simula la combinación de teclas especificada.
2. Captura de pantalla y reconocimiento de imágenes:

La biblioteca pyautogui también permite capturar pantallas y reconocer imágenes. Algunas de las funciones y métodos más útiles para la captura de pantalla y el reconocimiento de imágenes son:

pyautogui.screenshot(region=None): captura una captura de pantalla de la región especificada. Si no se especifica una región, se captura toda la pantalla.
pyautogui.locateOnScreen(image, grayscale=False, confidence=0.999): busca una imagen en la pantalla y devuelve las coordenadas de su posición. El parámetro opcional grayscale indica si la imagen debe ser convertida a escala de grises antes de la comparación. El parámetro opcional confidence indica el nivel de confianza mínimo necesario para considerar una coincidencia.
pyautogui.locateAllOnScreen(image, grayscale=False, confidence=0.999): busca todas las instancias de una imagen en la pantalla y devuelve una lista de sus coordenadas.
pyautogui.center(coords): devuelve las coordenadas del centro de un rectángulo especificado por sus coordenadas (left, top, width, height).
3. Configuración y opciones:

La biblioteca pyautogui también ofrece una variedad de opciones y configuraciones para personalizar su comportamiento. Algunas de las funciones y métodos más útiles para la configuración y las opciones son:

pyautogui.PAUSE: establece un tiempo de pausa predeterminado (en segundos) entre las operaciones
