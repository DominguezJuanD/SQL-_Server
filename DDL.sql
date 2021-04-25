CREATE DATABASE Aerolineas

use Aerolineas

drop table Aeronave
go

create table Aeronave(
	IdAeronave char(5) not null, 
	Matricula char(5) not null,
	Modelo char(4) not null,
	MaximoPasajeros smallint,
	MaximoCarga tinyint,
	constraint pk_aeronave_idaeronave primary key (IdAeronave),
	constraint ck_aeronave_idaeronave_valor check (IdAeronave like '[A-F0-9][A-F0-9][A-F0-9][A-F0-9][A-F0-9]'),
	constraint uq_aeronave_matricula unique (Matricula),
	constraint ck_aeronave_matricula_valor check (Matricula like 'LV___'),
	constraint ck_aerovave_modelo_valor check (modelo like '[A,B,J][0-9][0-9][0-9]'),
	constraint ck_aeronave_maximopasajeros_valormenor check (MaximoPasajeros > 0),
	constraint ck_aeronave_maximocarga_valormenor check (MaximoCarga > 0)
)
create index ix_aeronave_matricula on Aeronave(Matricula)

insert into Aeronave(IdAeronave,Matricula,Modelo,MaximoPasajeros,MaximoCarga)
 values ('fd343','lvlya','b234',-4,-12)

 create table Ciudades(
	IdCiudad int identity(0,1),
	Nombre varchar (50) not null,
	constraint pk_ciudades_idciudad primary key (IdCiudad)
 ) 
create index ix_ciudades_idciudades on Ciudades(IdCiudad)

create table Aeropuertos(
	IdAeropuerto char(3) not null,
	IdCiudad int not null,
	constraint pk_aeropuerto_idaeropuerto primary key (IdAeropuerto),
	constraint ck_aeropuerto_idaeropuerto_valor check ( IdAeropuerto like '[A-Z][A-Z][A-Z]'),
	constraint fk_aeropuerto_idciudad foreign key (IdCiudad) references Ciudades(IdCiudad)
 )
create index ix_aeropuertos_idaeropuerto on Aeropuertos(IdAeropuerto)


 create table Dias(
	IdDia tinyint identity(0,1),
	Nombre varchar (15) not null,
	constraint uk_dias_iddias primary key (IdDia),
	constraint ck_dias_iddias_valormaximo check(IdDia < 7)
 )

 create table Ruta(
	IdRuta smallint identity(0,1),
	DistanciaKms smallint,
	TiempoMinutos smallint,
	IdAeropuerto char(3) not null,
	constraint pk_ruta_idruta primary key (IdRuta),
	constraint ck_ruta_distanciakms_rango check (DistanciaKms > 0),
	constraint ck_ruta_tiempominutos_rango check (TiempoMinutos > 0),
	constraint uk_ruta_idaeropuerto_origen foreign key (IdAeropuerto) references Aeropuertos(IdAeropuerto),
	constraint uk_ruta_idaeropuerto_destino foreign key (IdAeropuerto) references Aeropuertos(IdAeropuerto)
 )

 create table Ruta_Dia_Aeronave(
	Horario numeric(4,2),
	VueloNumero char(6) not null,
	Habilitado_hasta date not null,
	IdRuta smallint not null,
	IdDia tinyint not null,
	IdAeronave char(5),
	Constraint ck_ruta_dia_aeronave_horario CHECK (FLOOR(Horario) <= 23 AND Horario%1 < 0.60),
	constraint ck_ruta_dia_aeronave_vuelonumero check (VueloNumero like '[A-Z][A-Z][0-9][0-9][0-9][0-9]'),
	constraint ck_ruta_dia_aeronave_habilitado_hasta_fecha check (Habilitado_hasta > getdate() and Habilitado_hasta < GETDATE()+365),
	constraint pk_ruta_dia_aeronave primary key(IdRuta,IdDia,IdAeronave),
	constraint fk_ruta_dia_aeronave_dias foreign key (IdDia) references Dias(IdDia),
	constraint fk_ruta_dia_aeronave_aeronaves foreign key (IdAeronave) references Aeronave(IdAeronave),
	constraint fk_ruta_dia_aeronave_rutas foreign key (IdRuta) references Ruta(IdRuta)
 )

 create table Vuelos(
	Fecha date not null,
	IdRuta smallint not null,
	IdDia tinyint not null,
	IdAeronave char(5),
	constraint ck_vuelos_fecha_valor check ( Fecha >= getdate()),
	constraint pk_vuelos_ruta_dia_aeronave_fecha primary key(IdRuta,IdDia,IdAeronave,Fecha),
	constraint fk_vuelos_ruta_dia_aeronave foreign key (IdRuta,IdDia,IdAeronave) references Ruta_Dia_Aeronave(IdRuta,IdDia,IdAeronave)
 )

 create table Pasajeros (
	IdPasajero int identity(0,1),
	PaisOrigen char(2) default 'AR',
	TipoDocumento char(3) default 'DNI',
	NumeroDocumento int not null,
	Nombre char(50) not null,	
	constraint pk_pasajeros_idpasajero primary key (IdPasajero),
	constraint ck_pasajeros_numerodocumento check (NumeroDocumento > 0),
	constraint uk_pasajeros_valores_unicos unique (IdPasajero,TipoDocumento,NumeroDocumento)

 )

 create table Pasajes(
	Asiento char(3) not null,
	Fecha date not null,
	IdRuta smallint not null,
	IdDia tinyint not null,
	IdAeronave char(5),
	IdPasajero int not null,
	constraint ck_pasajes_asiento check (Asiento like '[A-H][0-9][0-9]'),
	constraint uk_pasajes_valores_unicos unique(IdRuta,IdDia,IdAeronave,Fecha,Asiento),
	constraint fk_pasajes_ruta_dia_aeropuerto_fecha foreign key (IdRuta,IdDia,IdAeronave,Fecha) references Vuelos(IdRuta,IdDia,IdAeronave,Fecha),
	constraint fk_pasajes_pasajeros foreign key (IdPasajero) references Pasajeros(IdPasajero)
 )
