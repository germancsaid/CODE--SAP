import pyhdb
connection = pyhdb.connect(
    host="<hostname>",
    port=<port_number>,
    user="<username>",
    password="<password>"
)
cursor = connection.cursor()
cursor.execute("SELECT 'Hello Python World' FROM DUMMY")
rows = cursor.fetchall()
for row in rows:
    print(row)
connection.close()