create database f1season2019
	with owner postgres;

create table if not exists team
(
	id serial not null
		constraint team_pk
			primary key,
	name varchar(128) not null,
	"countryOfOrigin" varchar(128)
);

alter table team owner to postgres;

create table if not exists driver
(
	id serial not null
		constraint driver_pk
			primary key,
	name varchar(128),
	fkteam integer not null
		constraint driver_team_id_fk
			references team
);

alter table driver owner to postgres;

