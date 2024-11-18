import mysql.connector
class EliminarUsuario:
    def __init__(self, conexion):
        self.conexion = conexion

    def eliminar_usuario(self, codigo_usuario):
        try:
            cursor = self.conexion.cursor()
            
            cursor.callproc('EliminarUsuario', (codigo_usuario,))
            
            self.conexion.commit()
            print("Usuario eliminado con éxito.")
            
        except mysql.connector.Error as e:
            print("Error al eliminar el usuario:", e)
        finally:
            cursor.close()

