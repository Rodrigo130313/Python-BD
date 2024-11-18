import mysql.connector

# Creo la clase con el nombre "Conexion"
class Conexion:

    #Creo el metodo constructor
    def _init_(self):
        self.conexion = None

    # Metodo para establecer la conexion con la Base de datos
    def conectar(self):
        self.conexion = mysql.connector.connect(
            user='root',
            host='localhost',
            password='Argus',
            database='biblioteca',
            port=3306
        )
        return self.conexion


# Creo una instancia de la clase "Conexion"
conexion = Conexion()

# Se establece la conexion
conexion = conexion.conectar()

# Condicion para verificar si se establecio la conexion correctamente
if conexion.is_connected():
    print("Se establecio la conexion")
else:
    print("No se pudo establecer la conexion")
