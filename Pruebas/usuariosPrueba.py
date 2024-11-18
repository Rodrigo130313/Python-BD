from conexionbd.Conexion import Conexion
from procedimientos_almacenados.eliminarUsuario import EliminarUsuario

conexion_instancia = Conexion()
conexion = conexion_instancia.conectar()

eliminar = EliminarUsuario(conexion)

eliminar.eliminar_usuario(1)
