from conexionbd.Conexion import Conexion
from procedimientos_almacenados.consultarLibro import ConsultaLibro

conexion_instancia = Conexion()
conexion = conexion_instancia.conectar()

consulta = ConsultaLibro(conexion)

consulta.consultar_libro(editorial='HarperCollins')
