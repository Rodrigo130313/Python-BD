from conexionbd.Conexion import Conexion
from procedimientos_almacenados.ActualizarAutor import ActualizarAutor

conexion_instancia = Conexion()
conexion = conexion_instancia.conectar()

actualizar = ActualizarAutor(conexion)

actualizar.actualizar_autor(1, 'Barbie')
