/* NOC_REGION_MASTER */

create table practice.noc_region_master
(
	noc_id integer primary key generated always as identity,
	noc_name varchar(5) not null,
	region varchar(100) not null,
	region_desc varchar(200)
);

/* ATHLETE_EVENTS */

create table practice.athlete_events
(
	event_id integer primary key generated always as identity,
	ath_name varchar(200) not null,
	ath_sex varchar(1) not null,
	ath_age varchar(3) not null,
	ath_height varchar(10) not null, 
	ath_weight varchar(10) not null, 
	ath_team varchar(300) not null,
	noc_name varchar(5) not null,
	game varchar(100),
	event_year integer,
	event_season varchar(50),
	event_city varchar(50),
	sport varchar(100),
	event_desc varchar(500),
	medal varchar(100),
	noc_id integer default 0,
	constraint noc_con
	foreign key(noc_id) 
	references practice.noc_region_master(noc_id)
	on
	delete
	set
	null
	on
	update
	cascade
);

/* Update Scripts */

update
	practice.athlete_events ae
set
	noc_id = (
	select
		distinct nrm.noc_id
	from
		practice.noc_region_master nrm
	where
		nrm.noc_name = ae.noc_name);

alter table practice.athlete_events drop column noc_name;