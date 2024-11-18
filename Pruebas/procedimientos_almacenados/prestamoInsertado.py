import mysql.connector

class InsertarPrestamo:
    def __init__(self, conexion):
        self.conexion = conexion

    def registrar_prestamo(self, id_estudiante: int, id_ejemplar: int):
        try:
            cursor = self.conexion.cursor()

            cursor.callproc('RegistrarPrestamo', (id_estudiante, id_ejemplar))

            self.conexion.commit()
            print("Préstamo registrado con éxito.")
        except mysql.connector.Error as e:
            print("Error al registrar el préstamo:", e)
        finally:
            cursor.close()