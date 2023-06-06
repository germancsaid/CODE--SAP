import pymongo

# Configurar la conexión a MongoDB
cliente = pymongo.MongoClient("mongodb://localhost:27017/")

# Seleccionar la base de datos
db = cliente["scrumz"]

# Seleccionar la colección
coleccion = db["event_backlogs"]

# Hacer la consulta para obtener todos los documentos de la colección
documentos = coleccion.find()

# Recorrer los documentos y hacer algo con ellos
for documento in documentos:
    print(documento)