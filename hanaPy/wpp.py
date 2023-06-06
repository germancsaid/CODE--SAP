from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import time

# Iniciar el navegador Chrome
driver = webdriver.Chrome()

# Ingresar a WhatsApp Web
driver.get("https://web.whatsapp.com/")
time.sleep(10)  # esperar a que se cargue la página y se escanee el código QR

# Buscar el contacto con quien queremos hablar
contacto = "Nombre del contacto"
search_box = driver.find_element_by_xpath('//*[@id="side"]/div[1]/div/label/div/div[2]')
search_box.send_keys(contacto)
search_box.send_keys(Keys.ENTER)
time.sleep(2)  # esperar a que se cargue el chat

# Escribir el mensaje y enviarlo
mensaje = "Hola, este es un mensaje de prueba enviado desde Python."
mensaje_box = driver.find_element_by_xpath('//*[@id="main"]/footer/div[1]/div[2]/div/div[2]')
mensaje_box.send_keys(mensaje)
mensaje_box.send_keys(Keys.ENTER)

# Cerrar el navegador
driver.quit()