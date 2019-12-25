create database f1season2019
	with owner arthur;

create table team
(
	id serial not null
		constraint team_pk
			primary key,
	name varchar(128) not null,
	"countryOfOrigin" varchar(128),
	logopath varchar(32)
);

alter table team owner to arthur;

create table driver
(
	id serial not null
		constraint driver_pk
			primary key,
	name varchar(128),
	fkteam integer not null
		constraint driver_team_id_fk
			references team
);

alter table driver owner to arthur;

