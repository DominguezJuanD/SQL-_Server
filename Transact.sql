use editorial
--1.1. Definir una variable de memoria, asignar a estala fecha y hora del sistema utilizando el comando select y mostrar el resultado en consola. 

declare @FechaHora smalldatetime
select @FechaHora = GETDATE()
print  'Fecha y Hora: ' + cast(@FechaHora as varchar(20))

--1.2. Definir las variables necesarias para calcular el área de un triángulo; asignar valores (sin utilizar select) y hacer uso de los operadores aritméticos y de la precedencia de los mismos. 

declare @Base tinyint, @altura tinyint, @Area decimal(4,2)
set @Base = 3
set @altura = 2 
set @Area = @Base * @altura / 2
print 'El area de un triangulo: ' + cast(@Area as varchar(5))

--1.3. Utilizando la DB Editorial definir una consulta donde solo se obtenga como resultado los primeros 30 caracteres de la dirección del autor. 

select left(direccion,6) from autores 


--1.4. Escribir una consulta donde sólo se obtenga el apellido y el nombre de los autores separados por coma, 
--sin que se consideren los espacios a la derecha del contenido de las columnas. 
--Establezca un nombre a la columna de resultados.

select RTRIM(CONCAT(autor_nombre,',',autor_apellido)) as 'Nombre y Apellido' from autores

--1.5. Utilizando DATEPART seleccionar las ventas del año 2015. 

select * from ventas where DATEPART(YEAR,fecha_orden) = 2015

--1.6. Algunas ventas cuentan con un plazo de 60 días; Sobre estas se quiere saber cuál es la fecha correspondiente de pago y el trimestre que le corresponde. 
--Informar número de orden, fecha de la orden, el término de pago, la fecha de pago y el trimestre del pago. 

select numero_orden, fecha_orden, forma_pago, DATEADD(DAY, 60,fecha_orden) as 'fecha de pago', DATEPART(QUARTER,DATEADD(DAY, 60,fecha_orden)) as 'trimestre del pago' 
from ventas 
where forma_pago = '60 días'

--2.1. Generar un procedimiento almacenado que reciba 2 fechas como parámetros y 
--muestre las órdenes recibidas en ese periodo. Mostrar todas las columnas de ventas. 
--Después informar la cantidad de almacenes que realizaron órdenes y el total de titulos ordenados.

--drop procedure DesdeHasta
go
create procedure DesdeHasta 
	@desde date,
	@hasta date
	as 
	select *
	from ventas 
	where fecha_orden between @desde and @hasta

	declare @cantAlmacen int,@totalTitulos int
	select @cantAlmacen = COUNT(distinct almacen_id), @totalTitulos = sum(cantidad)
	from ventas 
	where fecha_orden between @desde and @hasta
	 
	print 'cantidad de titulos: ' + cast(@cantAlmacen as char)
	print ' cantidad de libros: ' + cast(@totalTitulos as char)

exec DesdeHasta '2014-09-13','2015-01-01'

--2.2. Generar procedimientos almacenados para efectuar el alta en las tablas titulos, titulos_autor y ventas: Cada procedimiento 
--almacenado deberá llamarse sp_insert_<nombre_tabla> donde <nombre_tabla> es el nombre de la entidad en la cual se realizará el alta y 
--deberá tener tantos parámetros de entrada como atributos tenga cada entidad (exceptuando los atributos de tipo identidad). 
--Dar 3 ejemplos de invocación de cada procedimiento almacenado

--select * from titulos
--delete titulos where titulo_id = 'JD1234'
go

create procedure sp_insert_titulos 
	@titulo_id varchar(6),
	@titulo varchar(80),
	@genero char(12),
	@editorial_id char(4),
	@precio money,
	@adenlanto money,
	@regalias int,
	@venta_anual int,
	@notas varchar(200),
	@fecha_publciacion datetime
	as
	insert into titulos(titulo_id, titulo, genero, editorial_id, precio, adelanto, regalias, venta_anual ,notas ,fecha_publicacion) 
	values (@titulo_id, @titulo, @genero, @editorial_id, @precio, @adenlanto, @regalias, @venta_anual, @notas, @fecha_publciacion)

exec sp_insert_titulos 'JD1234', 'titlo agregado con SP', 'nuevo', '1389', 25, 1000, 15, 500, 'dejo una nota del nuevo titulo', '2015-05-12'


select * from ventas

go

create procedure sp_insert_ventas
	@almacen_id char(4),
	@numero_orden varchar(20),
	@fecha_orden datetime,
	@cantidad smallint,
	@forma_pago varchar(12),
	@titulo_id varchar(6)
	as
	insert into ventas(almacen_id,numero_orden,fecha_orden,cantidad,forma_pago,titulo_id)
	values (@almacen_id,@numero_orden,@fecha_orden,@cantidad,@forma_pago,@titulo_id)

exec sp_insert_ventas '7066','123456789', '2015-11-03', 55, 'cheque', 'JD1234'

select * from titulo_autor order by autor_id

go

create procedure sp_insert_titulo_autor
	@autor_id varchar(11),
	@titulo_id varchar(6),
	@autor_orden tinyint,
	@procentaje_regalia int
	as
	insert into titulo_autor(autor_id, titulo_id, autor_orden, porcentaje_regalias)
	values (@autor_id, @titulo_id, @autor_orden, @procentaje_regalia)

exec sp_insert_titulo_autor '172-32-1176', 'JD1234', 1, 200

--2.3. Generar procedimientos almacenados para modificación en las tablas titulos, titulos_autor y ventas: Cada procedimiento almacenado deberá llamarse 
--sp_update_<nombre_tabla> y deberá tener tantos parámetros de entrada como atributos tenga cada entidad incluyendo los de tipo identidad. 
--Dar 2 ejemplos de invocación de cada procedimiento almacenado. 

select * from titulos
go
create procedure sp_update_titulos 
	@titulo_id varchar(6),
	@titulo varchar(80),
	@genero char(12),
	@editorial_id char(4),
	@precio money,
	@adenlanto money,
	@regalias int,
	@venta_anual int,
	@notas varchar(200),
	@fecha_publicacion datetime
	as
	update titulos set titulo=@titulo, genero=@genero, editorial_id=@editorial_id, precio=@precio, adelanto=@adenlanto, 
						regalias=@regalias, venta_anual=@venta_anual ,notas=@notas ,fecha_publicacion = @fecha_publicacion 
	where titulo_id=@titulo_id

exec sp_update_titulos 'pc9999','Net Etiquette', 'popular_comp', '1389', 25, 1000, 15, 500, 'dejo nota por que de modifico este titulo', '2019-11-20'

select * from ventas
go

create procedure sp_update_ventas
	@almacen_id char(4),
	@fecha_orden datetime,
	@cantidad smallint,
	@forma_pago varchar(12),
	@titulo_id varchar(6),
	@numero_orden varchar(20)
	as
	update ventas set almacen_id=@almacen_id, fecha_orden=@fecha_orden, cantidad=@cantidad, forma_pago=@fecha_orden, titulo_id=@titulo_id 
	where numero_orden=@numero_orden

exec sp_update_ventas '7066','123456789', '2015-11-03', 55, 'cheque', 'JD1234'

select * from titulo_autor order by autor_id
go
create procedure sp_update_titulo_autor
	@autor_id varchar(11),
	@titulo_id varchar(6),
	@autor_orden tinyint,
	@procentaje_regalia int
	as
	update titulo_autor set titulo_id=@titulo_id, autor_orden=@autor_orden, porcentaje_regalias=@procentaje_regalia where autor_id = @autor_id
	

exec sp_update_titulo_autor '172-32-1176', 'JD1234', 1, 200


--2.4. Generar procedimientos almacenados para Baja en las tablas titulos, titulos_autor y ventas: Cada procedimiento almacenado deberá llamarse 
--sp_delete_<nombre_tabla> y deberá tener un parámetro de entrada el id autonumerado. 
--Dar 1 ejemplo de invocación- 

select * from titulos
go
create procedure sp_delete_titulos 
	@titulo_id varchar(6)
	as
	delete from titulos 
	where titulo_id=@titulo_id

exec sp_delete_titulos 'pc9999'


select * from ventas
--drop procedure sp_delete_ventas
go
create procedure sp_delete_ventas
	@almacen_id char(4),
	@titulo_id varchar(6),
	@numero_orden varchar(20)
	as
	delete from ventas
	where almacen_id = @almacen_id and titulo_id=@titulo_id and numero_orden = @numero_orden

exec sp_delete_ventas '7066', 'JD1234', '123456789'


select * from titulo_autor order by autor_id
go
create procedure sp_delete_titulo_autor
	@autor_id varchar(11),
	@titulo_id varchar(6)
	as
	delete from titulo_autor 
	where autor_id = @autor_id and titulo_id = @titulo_id

exec sp_delete_titulo_autor '172-32-1176', 'JD1234'

--3.1. Dado el código de un título se deben obtener las ventas del mismo. Si el título ha sido vendido, 
--se debe detallar las ventas correspondientes. 
--Si no se ha vendido el título, debe aparecer un mensaje que diga que el título no se ha vendido. 

select * from editoriales
go
create procedure consultaVentaTitulo
	@codigoTitulo varchar(10)
	as
	if exists(select * from ventas where titulo_id = @codigoTitulo)
		select * from ventas where titulo_id = @codigoTitulo
	else
		print 'El Titulo no se ha Vendido...'

exec consultaVentaTitulo 'BU1032'

--3.2. Generar un procedimiento almacenado utilizando estructuras llamado sp_crud_editorial con los 
--siguientes parámetros para realizar las operaciones CRUD sobre la tabla Editoriales.  
	--3.2.1. Si el parámetro @accion es ‘C’ (crear):Verificar si no existe el código de título, 
	--en ese caso insertar en la tabla una fila con los valores de los parámetros 

select * from editoriales
--drop procedure sp_crud_editorial
go
create procedure sp_crud_editorial
	@codigoTitulo varchar(10),
	@editorial_nombre varchar(40),
	@ciudad varchar(20),
	@estado char(2),
	@pais varchar(40),
	@accion as char
	as
	if @accion = 'C'
		begin
		if not exists(select * from ventas where titulo_id = @codigoTitulo)
			insert into editoriales (editorial_id, editorial_nombre,ciudad,estado,pais)
			values(@codigoTitulo,@editorial_nombre,@ciudad,@estado,@pais)
		else
			print 'el tituloID: ' + @codigoTitulo + ' se encuentra en la tabla...' 
		end
	else
		begin
		if @accion = 'R'
			begin
			if exists(select * from editoriales where editorial_id = @codigoTitulo)
				select * from editoriales where editorial_id = @codigoTitulo
			else
				print 'El TutuloID: ' + @codigoTitulo + ' no se encuentra en la tabla...'
			end
		else
			begin
				if @accion = 'U'
					begin
						if exists(select * from editoriales where editorial_id = @codigoTitulo)
							insert into editoriales (editorial_nombre) values (@editorial_nombre)
					end
				else
				print 'a'
			end
		end
exec sp_crud_editorial '9934','nuevo','posadas','MS','ARG', 'R' 


--3.3. Las ventas tienen diferentes categorías: menores a 30 piezas consideradas pequeñas, de 30 a 50 consideradas medianas, 
--y más de 50, son consideradas excelentes. Desplegar las órdenes de venta señalando que categoría de venta se trata. 

select v.*, case 
				when v.cantidad < 20 then 'pequeñas'
				when v.cantidad between 20 and 30 then 'mediana'
				else 'excelentes'
			end as 'categoria'
from ventas as v 


--3.4. Mostrar en una tabla de doble entrada los totales de ventas anuales por almacén. 
--Disponer los distintos almacenes en las filas y los años 2012, 2013 y 2014 en columnas. 

select v.almacen_id, 
	sum(case when YEAR(fecha_orden) = 2012 then v.cantidad else 0 end) as '2012',
	sum(case when YEAR(fecha_orden) = 2013 then v.cantidad else 0 end) as '2013',
	sum(case when YEAR(fecha_orden) = 2014 then v.cantidad else 0 end) as '2014'
from ventas as v group by v.almacen_id

--4.1. Crear una vista que muestre el nombre del empleado, el cargo y la editorial para que trabaja. 

select * from empleados

go
create view vw_editorial
	as
	select nombre, inicial_segundo_nombre,apellido,cargo_id,editorial_id 
	from empleados
go

select * from vw_editorial

--4.2. Crear una vista que permita identificar cada título y alterar las regalías del mismo

select * from titulos 
go

--create view vw_rubros as
	
--drop view vw_update_empleado
go
--4.3. Crear una vista que solo permita modificar la información perteneciente a los empleados de la editorial “GGG&G”

create view vw_update_empleado (EmpleadoID, Nombre,Inicial, Apellido,  cargo, NivelCargo, EditorialID, fecha)
	as
	select em.editorial_id, em.nombre, em.inicial_segundo_nombre, em.apellido, em.cargo_id, em.nivel_cargo, em.editorial_id, em.fecha_contratacion 
	from editoriales as ed 
	inner join empleados as em on ed.editorial_id = em.editorial_id 
	where ed.editorial_nombre = 'GGG&G'

go

select * from vw_update_empleado

update vw_update_empleado set Inicial = 'Y'

--5.1. Crear un SP que permita agregar una fila a ventas. Al hacerlo actualizar la columna titulos.
--venta_anual agregando el valor de especificado en cantidad. 
--Asegurar la operación con una transacción.

go
create procedure sp_insert_update_ventas_titulo
	@almacen_id char(4),
	@numero_orden varchar(20),
	@fecha_orden datetime,
	@cantidad smallint,
	@forma_pago varchar(12),
	@titulo_id varchar(6)
	as
	begin transaction
	insert into ventas (almacen_id, numero_orden, fecha_orden, cantidad, forma_pago, titulo_id)
			values(@almacen_id, @numero_orden, @fecha_orden, @cantidad, @forma_pago, @titulo_id)

	update titulos set venta_anual += @cantidad 
	where titulo_id = @titulo_id
	commit transaction

exec sp_insert_update_ventas_titulo '7066','123456789', '2015-11-03', 55, 'cheque', 'JD1234'
	
select * from ventas
select * from titulos

--5.2. Crear un SP que agregue un registro en título y su correspondiente registro en titulo_autor. 
--Si ocurre un error, por ejemplo la referencia a un autor inexistente, 
--abortar el proceso volviendo al punto de inicio. 

select * from titulo_autor
select * from titulos

select * from plan_regalias

--5.3. Crear un SP similar al anterior que también especifique un plan de regalías predeterminado de mínimo 0, 
--máximo 1000 y regalías a ser especificadas por parámetro. 
--Si ocurre un error, abortar el proceso volviendo al punto de inicio.
go

drop procedure sp_insert_titulos_regalia
go
create procedure sp_insert_titulos_regalia 
	@titulo_id varchar(6),
	@titulo varchar(80),
	@genero char(12),
	@editorial_id char(4),
	@precio money,
	@adenlanto money,
	@regalias int,
	@venta_anual int,
	@notas varchar(200),
	@fecha_publciacion datetime,
	@regalia int
	as
	begin transaction
		begin try
			if not exists(select * from editoriales where editorial_id = @editorial_id)
				throw 50001,'No existe ese id',16
			if @regalia > 1000
				throw 50001,'entre 0 y 1000',16
			insert into titulos(titulo_id, titulo, genero, editorial_id, precio, adelanto, regalias, venta_anual ,notas ,fecha_publicacion) 
			values (@titulo_id, @titulo, @genero, @editorial_id, @precio, @adenlanto, @regalias, @venta_anual, @notas, @fecha_publciacion)
			insert into plan_regalias(titulo_id, rango_minimo, rango_maximo, regalias)
			values(@titulo_id,0,1000,@regalia)
		end try
		begin catch
			DECLARE @ErrorState VARCHAR(256)
			SELECT @ErrorState = error_message()
			ROLLBACK;
			THROW 50001, @ErrorState, 16
		end catch
	commit transaction

exec sp_insert_titulos_regalia'jp4777', 'titlo agregado con SP', 'nuevo', '1389', 25, 1000, 15, 500, 'dejo una nota del nuevo titulo', '2015-05-12',100
