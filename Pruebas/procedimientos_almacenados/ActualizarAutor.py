import mysql

class ActualizarAutor:
    def __init__(self, conexion):
        self.conexion = conexion

    def actualizar_autor(self, codigo, nombre=None):
        try:
            cursor = self.conexion.cursor()
            
            cursor.callproc('ActualizarAutor', (codigo, nombre))
            
            self.conexion.commit()
            print("Autor actualizado con éxito.")
            
        except mysql.connector.Error as e:
            print("Error al actualizar el autor:", e)
        finally:
            cursor.close()
