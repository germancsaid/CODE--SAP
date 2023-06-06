import pyHook # biblioteca para el teclado y mouse
import pythoncom
import pyaudio # biblioteca para el micrófono
import cv2 # biblioteca para la cámara

# función para detectar eventos de teclado
def on_keyboard_event(event):
    print('Tecla presionada:', event.Key)
    return True

# función para detectar eventos del mouse
def on_mouse_event(event):
    print('Evento del mouse:', event.MessageName, event.Position)
    return True

# función para detectar eventos del micrófono
def on_microphone_event(in_data, frame_count, time_info, status):
    print('Audio capturado')
    return (in_data, pyaudio.paContinue)

# función para detectar eventos de la cámara
def on_camera_event():
    cap = cv2.VideoCapture(0)
    while(True):
        ret, frame = cap.read()
        cv2.imshow('Capturando video', frame)
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
    cap.release()
    cv2.destroyAllWindows()

# instanciar los objetos de los diferentes eventos
keyboard_hook = pyHook.HookManager()
keyboard_hook.KeyDown = on_keyboard_event
keyboard_hook.HookKeyboard()

mouse_hook = pyHook.HookManager()
mouse_hook.MouseAllButtons = on_mouse_event
mouse_hook.HookMouse()

p = pyaudio.PyAudio()
microphone_stream = p.open(format=pyaudio.paInt16, channels=1, rate=44100, input=True, stream_callback=on_microphone_event)

# llamar a la función para detectar eventos de la cámara
on_camera_event()

# liberar los recursos al finalizar
keyboard_hook.UnhookKeyboard()
mouse_hook.UnhookMouse()
microphone_stream.stop_stream()
microphone_stream.close()
p.terminate()
