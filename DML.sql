use editorial

--2.1. Listar los títulos pertenecientes al editor 1389. Por cada fila, listar el título, el tipo y la 
--fecha de publicación

select titulo, genero, fecha_publicacion from titulos where editorial_id = 1389	

--2.2. Tomando las ventas mostrar el id de título, el título y el total de ventas que se obtiene 
--de multiplicar la cantidad por precio. Renombrar a la columna calculada como “Total 
--de venta”.

select t.titulo_id, t.titulo, sum(v.cantidad * t.regalias) as 'Total de Ventas'  
from ventas as v, titulos as t where v.titulo_id = t.titulo_id group by t.titulo_id, t.titulo

select * from ventas as v, titulos as t where v.titulo_id = t.titulo_id

--2.3. Listar los id de almacén, números de orden y la cantidad para las ventas que realizo el 
--título “Prolonged Data Deprivation: Four Case Studies” el día 29 de mayo de 2013

select * from ventas

select v.almacen_id, v.numero_orden, v.cantidad from ventas as v, titulos as t 
where v.titulo_id = t.titulo_id  and t.titulo = 'Prolonged Data Deprivation: Four Case Studies' and v.fecha_orden = '2013-05-29'

--2.4. Listar el nombre, la inicial del segundo nombre y el apellido de los empleados de las 
--editoriales “Lucerne Publishing” y “New Moon Books”

select em.nombre, em.inicial_segundo_nombre, em.apellido  
from empleados as em, editoriales as ed where em.editorial_id = ed.editorial_id and ed.editorial_nombre in('Lucerne Publishing','New Moon Books')  

--2.5. Mostrar los títulos que no sean de la editorial “Algodata Infosystems”. Informar titulo 
--y Editorial

select * from editoriales as e, titulos as t where e.editorial_id = t.editorial_id and e.editorial_nombre <> 'Algodata Infosystems'

--2.6. Listar los títulos que tengan más regalías que cualquier otro título. 

select distinct t2.titulo from titulos as t1, titulos as t2 where t1.regalias < t2.regalias 

--2.7. Informar los empleados contratados en febrero, junio y agosto de cualquier año. 
--Mostrar apellido, nombre y fecha de contratación y ordenar por mes empezando por 
--los de febrero.

select apellido, nombre, fecha_contratacion from empleados
where MONTH(fecha_contratacion) in ('02','05','08') order by MONTH(fecha_contratacion)

--2.8. Informar las ventas de los siguientes títulos: 'Cooking with Computers: Surreptitious 
--Balance Sheets', 'The Psychology of Computer Cooking', 'Emotional Security: A New 
--Algorithm'. Mostrar titulo, nombre de almacén, fecha de orden, número de orden y 
--cantidad. Ordenar por títulos.

select t.titulo, a.almacen_nombre, v.fecha_orden, v.numero_orden, v.cantidad 
from ventas as v, titulos as t, almacenes as a 
where v.titulo_id = t.titulo_id and a.almacen_id = v.almacen_id
and t.titulo in ( 'Cooking with Computers: Surreptitious Balance Sheets', 'The Psychology of Computer Cooking', 'Emotional Security: A New Algorithm')
order by v.cantidad, t.titulo

--2.9. Informar las publicaciones del año 2011 exceptuando las de los géneros business, 
--psychology y trad_cook. Mostrar titulo y género. Ordenar por género y titulo.

select titulo, genero from titulos where YEAR(fecha_publicacion) = 2011 and genero not in('business', 'psychology', 'trad_cook') 
order by genero,titulo

--4.1. Mostrar los nombres de los autores que empiecen con “L”

select autor_nombre from autores where autor_nombre like 'l%'

--4.2. Mostrar los nombres de los autores que tengan una “A” en su nombre.

select autor_nombre from autores where autor_nombre like '%a%'

--4.3. Mostrar los nombres de los autores que empiecen con letras que van de la T a la Y

select * from autores where autor_nombre like '[t-y]%'

--.4. Mostrar los títulos que no tengan un “Computer” en su titulo

select * from titulos where titulo  not like '%Computer%'

select ISNULL(inicial_segundo_nombre,'f') from empleados

--5.1. Listar los empleados ordenados por apellido, por nombre y por inicial del segundo nombre.

select * from empleados order by apellido, nombre, inicial_segundo_nombre

--5.2. Listar los títulos pertenecientes al género ‘business’. Por cada fila, listar el id, el título 
--y el precio. Ordenar los datos por precio en forma descendente e id de artículo en 
--forma ascendente

select * from titulos where genero = 'business' order by precio, titulo_id asc

--6.1. Mostrar el promedio de venta anual de todos los títulos 

select AVG(venta_anual) as 'Promedio' from titulos 

--6.2. Mostrar el máximo de adelanto de todos los títulos 

select MAX(adelanto) as 'Maximo' from titulos

--6.3. Informar cuantos planes de regalías tiene el título MC3021

select COUNT(*) as 'cantidad de planes' from plan_regalias where titulo_id = 'MC3021'

--6.4. Obtener el total de ventas realizadas a 30 días en el año 2014 

select COUNT(*) as 'Total de ventas en 2014' from ventas as v where YEAR(v.fecha_orden) = 2014 and v.forma_pago = '30 días'

--6.5. Informar cuantas formas de pago existen 

select COUNT(distinct forma_pago) as 'cant Forma de pgo' from ventas 

--7.1. Informar cuantos títulos tiene cada autor. Mostrar código de autor y cantidad de libros.

select autor_id, COUNT(titulo_id) as 'Cantidad de titulos' 
from titulo_autor 
group by autor_id

--7.2. Informar el total de unidades vendidas por número de orden del almacén 7131. Mostrar número de orden y total vendido. 

select numero_orden, SUM(cantidad) as 'Totales vendido' 
from ventas
where almacen_id = 7131 
group by numero_orden

--7.3. Informar la última orden generada por cada almacén con forma de pago a 30 días y 60 días. Mostrar código de almacén, fecha de la orden y forma de pago. Ordenar por fecha de orden.

select almacen_id, MAX(fecha_orden) as Fecha, forma_pago 
from ventas 
where forma_pago in('30 días','60 días') 
group by almacen_id, forma_pago order by Fecha

--7.4. Informar el nivel de cargo más alto alcanzado por algún empleado de cada editorial. Mostrar Nombre de la editorial y nivel de cargo. Ordenar por nivel de cargo máximo empezando por el mayor

select ed.editorial_nombre, MAX(em.nivel_cargo) as 'max nivel de cargo' 
from empleados as em, editoriales as ed 
where em.editorial_id = ed.editorial_id 
group by em.editorial_id, ed.editorial_nombre 


select ed.editorial_nombre, nivel as 'max nivel de cargo' 
from editoriales as ed 
inner join 
	(select MAX(nivel_cargo) as nivel, editorial_id 
	from empleados 
	group by editorial_id) 
	as em on ed.editorial_id = em.editorial_id

--7.5. Mostrar los tres primeros géneros más vendidos. Mostrar género y total de ventas ordenado por mayor total de venta. 

select top 3 t.genero, sum(v.cantidad * t.precio) as Total_Ventas 
from ventas as v, titulos as t 
where v.titulo_id = t.titulo_id 
group by t.genero 
order by Total_Ventas desc

--7.6. Informar aquellos títulos que tengan más de un autor. Mostrar código de título y cantidad de autores. 

select titulo_id, COUNT(distinct autor_id) as Total_Autores 
from titulo_autor 
group by titulo_id having COUNT(distinct autor_id) > 1

--7.7. Informar el total de regalías obtenidas por cada título que haya tenido 40 o más unidades vendidas. 
--Mostrar el título y el monto en pesos de las regalías y ordenar por mayor regalía primero. 

select v.titulo_id, sum(v.cantidad * t.precio / t.regalias) 
from ventas as v, titulos as t 
where t.titulo_id = v.titulo_id 
group by v.titulo_id 


--7.8. Informar los autores que hayan escrito varios géneros de títulos. Mostrar nombre y cantidad de géneros ordenados por esta última columna empezando por el mayor. 

select t.genero, COUNT(distinct ta.autor_id) as Cant_Generos 
from titulo_autor as ta, titulos as t, autores as a 
where ta.titulo_id = t.titulo_id and ta.autor_id = a.autor_id 
group by t.genero 
having COUNT(distinct ta.autor_id) > 1 
order by Cant_Generos desc

--8.1. Informar las ventas a 60 días. Mostrar el id de título, el título y el total de ventas (cantidad por precio). Renombrar a la columna calculada.

select t.titulo, v.cantidad * t.precio as 'Total de Ventas' 
from titulos as t 
inner join ventas as v on v.titulo_id = t.titulo_id 
where v.forma_pago = '60 días'

--8.2. Informar los autores que hayan escrito varios géneros de libros. Mostrar nombre y cantidad de géneros ordenados por esta última columna empezando por el mayor.

select t.genero, COUNT(distinct ta.autor_id) as Cant_Generos 
from titulos as t 
inner join titulo_autor as ta on ta.titulo_id = t.titulo_id
inner join autores as a on ta.autor_id = a.autor_id 
where ta.titulo_id = t.titulo_id and ta.autor_id = a.autor_id 
group by t.genero 
having COUNT(distinct ta.autor_id) > 1 
order by Cant_Generos desc

--8.3. Informar para que editorial ha trabajado cada autor. Mostrar Apellido y nombre del autor y nombre de la editorial. Ordenar por Apellido y nombre del autor y nombre de la editorial

select a.autor_apellido, a.autor_nombre, ed.editorial_nombre 
from editoriales as ed
inner join titulos as t on ed.editorial_id = t.editorial_id
inner join titulo_autor as ta on t.titulo_id = ta.titulo_id
inner join autores as a on a.autor_id = ta.autor_id order by a.autor_apellido, a.autor_nombre, ed.editorial_nombre

--8.4. Informar las ventas por título. Mostrar título, fecha de orden y cantidad, si no tienen venta al menos mostrar una fila que indique la cantidad en 0. 
--Ordenar por título y mayor cantidad vendida primero.

select t.titulo, v.fecha_orden, isnull(SUM(v.cantidad), 0) as Cantidad_
from titulos as t 
left join ventas as v on t.titulo_id = v.titulo_id
group by t.titulo_id, v.fecha_orden, t.titulo
order by Cantidad_ desc, t.titulo

--8.5. Informar los autores que no tienen títulos. Mostrar nombre y apellido

select a.autor_apellido, a.autor_nombre 
from autores as a
left join titulo_autor as t on a.autor_id = t.autor_id
where t.autor_id is null

--8.6. Informar todos los cargos y los empleados que le corresponden de la editorial 'New Moon Books', si algún cargo está vacante informar como 'Vacante' en apellido. 
--Mostrar descripción del cargo, apellido y nombre. Ordenar por descripción del cargo, apellido y nombre

select cargo_descripcion, apellido=isnull(apellido,' sin contratación'), nombre=isnull(nombre,'') 
from empleados as e
inner join editoriales as ed on e.editorial_id = ed.editorial_id 
and ed.editorial_nombre = 'New Moon Books'
 right join cargos as c on c.cargo_id = e.cargo_id

 --8.7. Informar cuantos títulos escribió cada autor inclusive aquellos que no lo hayan hecho aún. 
 --Mostrar nombre y apellido del autor y cantidad. Ordenar por cantidad mayor primero, apellido y nombre. 


 select a.autor_id, COUNT(distinct ta.titulo_id) as cantidad from titulos as t 
 inner join titulo_autor as ta on t.titulo_id = ta.titulo_id
 right join autores as a on ta.autor_id = a.autor_id 
 group by a.autor_id

 select * from autores
 
 --8.8. Informar cuantos títulos “Is Anger the Enemy?” vendió cada almacén. Si un almacén no tuvo ventas del mismo informar con un cero. 
 --Mostrar código de almacén y cantidad. 

 select a.almacen_id, isnull(SUM(v.cantidad),0) as Cantidad 
 from titulos as t
 inner join ventas as v on t.titulo_id = v.titulo_id 
 and t.titulo = 'Is Anger the Enemy?'
 right join almacenes as a on v.almacen_id = a.almacen_id
 group by a.almacen_id

 select * from almacenes

 --8.9. Informar los totales de ventas (pesos) al contado entre abril y septiembre del 2014 por cada almacén. 
 --Mostrar nombre de almacén, y total de venta. Si un almacén no tiene ventas mostrar en cero. 

 select a.almacen_nombre, isnull(Sum(v.cantidad * t.precio),0) as Total_Venta 
 from titulos as t 
 inner join ventas as v on v.titulo_id = t.titulo_id
 and Year(v.fecha_orden) = 2014 and MONTH(v.fecha_orden) between 04 and 09
 right join almacenes as a on a.almacen_id = v.almacen_id
 group by a.almacen_id, a.almacen_nombre

-- con sub consulta para no agrupar por string

select a.almacen_nombre, isnull(t1.Total_Venta,0) as Total_Ventas 
from almacenes as a 
left join (select v.almacen_id, Sum(v.cantidad * t.precio) as Total_Venta 
			from titulos as t 
			inner join ventas as v on v.titulo_id = t.titulo_id
			and Year(v.fecha_orden) = 2014 and MONTH(v.fecha_orden) between 04 and 09
			group by v.almacen_id) as t1 on t1.almacen_id = a.almacen_id

--9.1. Informar las ciudades y estado donde residen los autores, las editoriales y los almacenes descartando valores duplicados. Ordenar por nombre de ciudad. 

select ciudad, estado from autores 
union
select ciudad, estado from editoriales
union 
select ciudad, estado from almacenes order by ciudad

--9.2. Informar cuantos títulos se han publicado primer semestre del 2011 y en el primer semestre del 2015. 
--Mostrar dos columnas y dos filas: en la primera columna la descripción del periodo y en la segunda la cantidad de títulos.

select 'Primer Semestre 2011' as descripcion, COUNT(*) as cantidad 
from titulos 
where YEAR(fecha_publicacion) = 2011 and MONTH(fecha_publicacion) between 1 and 6

union

select 'Primer Semestre 2015' as descripcion, COUNT(*) as cantidad 
from titulos 
where YEAR(fecha_publicacion) = 2015 and MONTH(fecha_publicacion) between 1 and 6

--9.3. Emitir un informe comparativo entre las ventas del año 2012 y el año 2014. El informe debe tener las siguientes columnas: código de título, titulo, 
--año y cantidad de vendida en el año (cada uno correspondiente al código de título de la fila correspondiente). Tener presente que un título puede tener ventas en un año y no en el otro, 
--en cuyo caso debe aparecer igual en el informe el año sin ventas.  Ordenar por título y año.

select v.titulo_id, t.titulo, YEAR(fecha_orden) as anio , v. cantidad
from ventas as v
inner join titulos as t on v.titulo_id = t.titulo_id
where YEAR(fecha_orden) = 2012 

select v.titulo_id, t.titulo, YEAR(fecha_orden) as anio , SUM(v.cantidad) cantidad
from ventas as v
inner join titulos as t on v.titulo_id = t.titulo_id
where YEAR(fecha_orden) = 2012 group by v.titulo_id, YEAR(fecha_orden), t.titulo

union all

select v.titulo_id, t.titulo, YEAR(fecha_orden) as anio , SUM(v.cantidad) cantidad
from ventas as v
inner join titulos as t on v.titulo_id = t.titulo_id
where YEAR(fecha_orden) = 2014 group by v.titulo_id, YEAR(fecha_orden), t.titulo

--10.1. Informar los títulos que no hayan tenido ventas entre el año 2011 y 2013 exceptuando los que se hayan publicado posteriormente. 
--Mostrar título, y nombre de editorial. Resolver este problema dos veces usando In y Exists 

select t.titulo, e.editorial_nombre 
from titulos as t 
inner join editoriales as e on t.editorial_id = e.editorial_id
where t.titulo_id not in( select titulo_id 
						from ventas 
						where YEAR(fecha_orden) between 2011 and 2013) 
and YEAR(fecha_publicacion) <= 2013

--version usando exists

select t.titulo, e.editorial_nombre 
from titulos as t 
inner join editoriales as e on t.editorial_id = e.editorial_id
where not exists( select *
						from ventas as v
						where v.titulo_id = t.titulo_id and 
						YEAR(v.fecha_orden) between 2011 and 2013) 
and YEAR(fecha_publicacion) <= 2013

--10.2. Informar las editoriales que no hayan contratados empleados en el año 2010 excepto que sean Director editorial, 
--Diseñador o Editor. Mostrar nombre de editorial. Ordenar.

select  ed.editorial_nombre
from editoriales as ed
where editorial_id not in(select em.editorial_id 
							from empleados as em
							inner join cargos as c on c.cargo_id = em.cargo_id
							where YEAR(em.fecha_contratacion) = 2010 
							and c.cargo_descripcion not in('Director editorial','Diseñador','Editor'))
order by ed.editorial_nombre

select editorial_id,ca.cargo_descripcion, fecha_contratacion 
from empleados em, cargos ca
where em.cargo_id = ca.cargo_id and YEAR(em.fecha_contratacion) = 2010
 order by editorial_id

--10.3. Informar los autores que han hecho algún título juntos. Mostrar los nombres y apellidos de a pares, ósea en una misma fila apellido y nombre de un autor seguido de  
--apellido y nombre del otro autor. Ordenar por apellido y nombre de un autor seguido de apellido y nombre del otro autor.

select a1.autor_apellido, a1.autor_nombre, a2.autor_apellido, a2.autor_nombre 
from autores as a1, autores as a2, 
	(	select ta1.autor_id autor1, ta2.autor_id autor2
		from titulo_autor as ta1, titulo_autor as ta2
		where ta1.titulo_id = ta2.titulo_id
			and ta1.autor_id > ta2.autor_id -- no tiene que ser <> tiene que ser < para que de distinto 
			--and ta1.autor_orden < ta2.autor_orden
		) as ta where ta.autor1 = a1.autor_id and ta.autor2 = a2.autor_id


--10.4. Informar aquellos títulos que hayan tenido alguna venta mejor que las ventas del título 
--“Onions, Leeks, and Garlic: Cooking Secrets of the Mediterranean”. Mostrar título y género. Ordenar por título. 

select t.titulo, t.genero, (v.cantidad * t.precio) 
from titulos as t 
inner join ventas as v on v.titulo_id = t.titulo_id 
where (v.cantidad * t.precio) > some (select t.precio * v.cantidad as venta
									from titulos as t 
									inner join ventas as v on v.titulo_id = t.titulo_id 
									where t.titulo = 'Onions, Leeks, and Garlic: Cooking Secrets of the Mediterranean')


select distinct tit1.titulo, tit1.genero
from titulos tit1 
inner join ventas vent1 on vent1.titulo_id = tit1.titulo_id
where exists
    (select ven.cantidad, tit.precio
     from titulos tit
     inner join ventas ven on tit.titulo_id = ven.titulo_id 
     where tit.titulo = 'Onions, Leeks, and Garlic: Cooking Secrets of the Mediterranean' 
     AND tit1.precio * vent1.cantidad > ven.cantidad * tit.precio)
order by tit1.titulo

select distinct tit1.titulo, tit1.genero
from titulos tit1, ventas vent1
where exists
    (select ven.cantidad * tit.precio as "total" 
     from titulos tit
     inner join ventas ven on tit.titulo_id = ven.titulo_id 
     where tit.titulo = 'Onions, Leeks, and Garlic: Cooking Secrets of the Mediterranean' 
     AND tit1.precio * vent1.cantidad > ven.cantidad * tit.precio)
order by tit1.titulo

---------version 2---------------
select * from ventas as v
inner join	titulos as t on t.titulo_id = v.titulo_id
where cantidad > some (select * from ventas as v inner join titulos as t on t.titulo_id = v.titulo_id
	where titulo = 'Onions, Leeks, and Garlic: Cooking Secrets of the Mediterranean')

--10.5. Informar los almacenes que hayan vendido más del doble que cualquier otro almacén. 
--Mostrar Nombre de almacén y cantidad. Ordenar por mayor venta primero.

select a.almacen_nombre, SUM(cantidad)
from ventas as v 
inner join almacenes as a on v.almacen_id = a.almacen_id 
group by v.almacen_id, a.almacen_nombre  
having SUM(v.cantidad) > some(select SUM(cantidad * 2)
							from ventas  
							group by almacen_id)

--10.6. Informar el almacén o los almacenes que haya vendido más que todos los otros. Mostrar Nombre de almacén y cantidad. 

select a.almacen_nombre, SUM(cantidad) cant
from ventas as v 
inner join almacenes as a on v.almacen_id = a.almacen_id 
group by v.almacen_id, a.almacen_nombre  
having SUM(cantidad) >= all(select sum(cantidad) as cant
						from ventas 
						group by almacen_id)

--10.7. Informar el o los títulos que se vendieron más que cualquier otro con forma de pago a 60 días. 

select t.titulo, sum(v.cantidad) as cantidad
from ventas as v
inner join titulos as t on v.titulo_id = t.titulo_id
where v.forma_pago = '60 días'
group by v.titulo_id, t.titulo 
having sum(v.cantidad) >= all(select SUM(cantidad) 
								from ventas 
								where forma_pago = '60 días'
								group by titulo_id)


--10.8. Informar cuantos títulos tiene cada autor. Mostrar código de autor, nombre, apellido y cantidad de libros. 			

select a.autor_id, a.autor_nombre, a.autor_apellido, tabla1.cantidad 
from autores as a
inner join (select autor_id, COUNT(distinct titulo_id) as cantidad
			from titulo_autor 
			group by autor_id) as tabla1 on a.autor_id = tabla1.autor_id 

--10.9. Informar el nivel de cargo más alto alcanzado por algún empleado de cada editor. Mostrar Nombre del editor y nivel de cargo. 
--Ordenar por nivel de cargo máximo empezando por el mayor. 

select ed.editorial_nombre, t1.Max_cargo 
from editoriales as ed 
inner join (select editorial_id, MAX(nivel_cargo) as Max_cargo
			from empleados 
			group by editorial_id) as t1 on t1.editorial_id = ed.editorial_id
order by t1.Max_cargo desc

--10.10. Mostrar los tres primeros géneros más vendidos. Mostrar género y total de ventas ordenado por mayor total de venta
--select * from 

select top 3  t.genero, sum(v.cantidad)
from ventas as v 
inner join titulos as t on t.titulo_id = v.titulo_id group by t.genero
order by v.cantidad desc

--select * from 

--10.11. Informar los autores que hayan escrito varios géneros de títulos. Mostrar nombre y 
--cantidad de géneros ordenados por esta última columna empezando por el mayor. 

select a.autor_nombre, a.autor_apellido, tabla1.cantidad 
from autores as a 
inner join (select ta.autor_id, COUNT(distinct t.genero) as cantidad 
			from titulo_autor as ta 
			inner join titulos as t on t.titulo_id = ta.titulo_id 
			group by ta.autor_id) as tabla1 on tabla1.autor_id = a.autor_id
order by cantidad desc

select autor_nombre, cantidad
from autores as a
inner join(
    select ta.autor_id, COUNT(distinct genero) as cantidad
    from titulo_autor as ta
    inner join titulos as t on ta.titulo_id = t.titulo_id
    group by autor_id
    having count(distinct genero) > 1
) as g on g.autor_id = a.autor_id
order by cantidad desc

--10.12. Informar cuantos títulos escribió cada autor inclusive aquellos que no lo hayan hecho aún. 
--Mostrar nombre y apellido del autor y cantidad. Ordenar por cantidad mayor primero, apellido y nombre. 

select a.autor_nombre, a.autor_apellido, isnull(tabla1.cantidad,0) as cantidad
from autores as a 
left join (select ta.autor_id, COUNT(t.titulo_id) as cantidad 
			from titulo_autor as ta 
			inner join titulos as t on t.titulo_id = ta.titulo_id 
			group by ta.autor_id) as tabla1 on a.autor_id = tabla1.autor_id
order by cantidad desc, a.autor_nombre, a.autor_apellido

--10.13. Informar el monto de regalías a pagar por cada autor, inclusive aquellos que no tengan ventas, de las ventas del año 2013 
--de la editorial ‘Binnet & Hardley’. Mostrar apellido y nombre del autor y monto a pagar. 
--Tener en cuenta que hay que operar la regalía del título y sobre esta la regalía del autor respecto a ese libro. 

select a1.autor_nombre,a1.autor_apellido ,isnull((tabla1.cantidad1 * t1.precio * t1.regalias / 100) * ta.porcentaje_regalias, 0) as Total_Pago
from titulos as t1
inner join (select titulo_id, SUM(cantidad) as cantidad1 
			from ventas 
			where YEAR(fecha_orden) = 2013
			group by titulo_id) as tabla1 on t1.titulo_id = tabla1.titulo_id
inner join editoriales as ed on t1.editorial_id = ed.editorial_id and editorial_nombre = 'Binnet & Hardley'
inner join titulo_autor as ta on ta.titulo_id = tabla1.titulo_id
right join autores as a1 on ta.autor_id = a1.autor_id

--12.1. Agregar los nuevos autores Facundo Manes (id 541-54-5643) y Mateo Niro (id 541-25-5641). 
--El primero tiene teléfono 011-4515-9897, dirección Av. Libertador 2354, CP 10445 y 
--el segundo teléfono 011-4554-7856, dirección Av. De Mayo 564, CP 10056. Ambos viven en C.A.B.A. (BA) y están contratados

select * from autores
insert into autores values ('541-54-5643','Facundo', 'Manes', '11-4515-9897', 'Av. Libertador 2354','C.A.B.A.', 'BA', '10445', 1),
							('541-25-5641','Mateo', 'Niro', '11-4554-7856', 'Av. De Mayo 564','C.A.B.A.', 'BA', '10056', 1)

--12.2. Agregar la editorial Planeta (id 5684) ubicada en C.A.B.A. (BA), Argentina. 

select * from editoriales 

insert into editoriales values('9984', 'Planeta', 'C.A.B.A.', 'BA', 'Argentina')

--12.3. Agregar el título Usar el cerebro, ID NC5001, género Neurociencia, de la editorial Planeta, precio $12, adelanto $3000, 
--regalías 18%, publicado el 1º de marzo de 2014. Notas: Conocer nuestra mente para vivir mejor

select * from titulos
insert into titulos (titulo_id, titulo, genero, editorial_id, precio, adelanto, regalias, notas, fecha_publicacion) 
values ('NC5001', 'Usar el cerebro','Neurociencia', (select editorial_id from editoriales where editorial_nombre = 'Planeta'), 12,3000, 18, 'Conocer nuestra mente para vivir mejor', '2014-03-01')

insert into titulos (titulo_id,titulo,genero,editorial_id,precio,adelanto,regalias,fecha_publicacion,notas)
SELECT 'NC5001','Usar el cerebro','Neurociencia',ed.editorial_id,12,3000,18,'20140301','Conocer nuestra mente para vivir mejor'
from editoriales ed
where ed.editorial_nombre = 'Planeta'

--12.4. Agregar al título “Usar el cerebro” los autores Facundo Manes y Mateo Niro en ese orden. Para el primero las regalías son 70% y para el segundo 30%. 

select * from titulo_autor 
select * from titulos
delete from titulo_autor where titulo_id = 'NC5001'
insert into titulo_autor values ((select autor_id from autores where autor_apellido = 'Manes'),(select titulo_id from titulos  where titulo = 'Usar el cerebro'), 1, 70),
								((select autor_id from autores where autor_apellido = 'Niro'),(select titulo_id from titulos  where titulo = 'Usar el cerebro'), 2, 30)


--12.5. Agregar una venta al almacén 7896 con los siguientes datos: 
	-- Orden JJ3598 
	-- Fecha: 30 de abril del 2015 
	-- Cantidad: 30 
	-- Forma de pago: 30 días 
	-- Título: “Usar el cerebro” 
--delete ventas where numero_orden = 'JJ3598'
insert into ventas
	select '7896','JJ3598', '20140430', 30, '30 días' , t.titulo_id 
	from titulos AS t
	where t.titulo = 'Usar el cerebro'

--12.6. Agregar un plan de regalías a cada título que no lo tenga. El rango mínimo será cero y el máximo 5000. El porcentaje de regalías establecer en 10.

insert into plan_regalias
	select  t.titulo_id, 0, 5000, 10
	from titulos as t 
	where t.titulo_id not in( select titulo_id from plan_regalias)


--12.7. Agregar un plan de regalías a cada título. El rango mínimo será el rango máximo actual más uno, 
--el rango máximo será el doble del rango máximo actual 
--y la regalía será el máximo actual más dos puntos. 

insert into plan_regalias
	select titulo_id, MAX(rango_maximo) + 1, max(rango_maximo) * 2, MAX(regalias) + 2 
	from plan_regalias
	group by titulo_id

--12.8. Subir en un 10% los precios de los títulos de la editorial Algodata Infosystems 

update titulos
set precio = (t.precio * 10 / 100) + t.precio 
from titulos as t 
inner join editoriales as ed on t.editorial_id = ed.editorial_id
where ed.editorial_nombre = 'Algodata Infosystems'

--12.9. A aquellos empleados que en su cargo están en el nivel mínimo (rango inferior) subirle a la al punto medio.

update empleados
	set nivel_cargo = (c.nivel_minimo / 2 + c.nivel_maximo /2) 
	from empleados as em 
	inner join cargos as c on c.cargo_id = em.cargo_id
	where em.nivel_cargo = c.nivel_minimo

--12.10. Cambiar el cargo de los “editores” a “director editorial” a aquellos editores que están a por lo menos 15 puntos del nivel máximo. 
--MJP25939M
update empleados
set cargo_id = (select cargo_id from cargos where cargo_descripcion = 'Director editorial'), nivel_cargo = c.nivel_minimo
	from empleados as em 
	inner join cargos as c on c.cargo_id = em.cargo_id
	where em.nivel_cargo >= c.nivel_maximo - 15
	and c.cargo_descripcion = 'Editor'

--12.11. Borrar los autores que no fueron contratados.
--delete
select * from 
autores where contratado = 0

--12.12. Borrar el título “Usar el cerebro”. Para poder completar esta operación borrar las filas relacionas den las distintas tablas mediante subconsulta. 

select * from titulos where titulo = 'Usar el cerebro'