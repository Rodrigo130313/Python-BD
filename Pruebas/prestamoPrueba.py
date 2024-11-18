from conexionbd.Conexion import Conexion
from procedimientos_almacenados.prestamoInsertado import InsertarPrestamo

conexion_instancia = Conexion()
conexion = conexion_instancia.conectar()

prestamo = InsertarPrestamo(conexion)

id_estudiante = 3 
id_ejemplar = 1
prestamo.registrar_prestamo(id_estudiante, id_ejemplar)