import mysql.connector

class ConsultaLibro:
    def __init__(self, conexion):
        self.conexion = conexion

    def consultar_libro(self, codigo_libro=None, titulo=None, isbn=None, paginas=None, editorial=None):
        try:
            cursor = self.conexion.cursor()
            
            cursor.callproc('ConsultarLibros', (codigo_libro, titulo, isbn, paginas, editorial))
            
            for result in cursor.stored_results():
                libros = result.fetchall()
                for libro in libros:
                    print(libro)
                    
        except mysql.connector.Error as e:
            print("Error al consultar libros:", e)
        finally:
            cursor.close()


