create table practice.noc_region_master
(
	noc_id integer primary key generated always as identity,
	noc_name varchar(5) not null,
	region varchar(100) not null,
	region_desc varchar(200)
);

select
	*
from
	practice.noc_region_master;

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

select
	*
from
	practice.athlete_events;

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

/* How many olympics games have been held? */
select
	count(*)
from
	practice.athlete_events ae ;

/* List down all Olympics games held so far. */
select
	distinct(game)
from
	practice.athlete_events
order by
	game;

/*
Mention the total no of nations who participated in each olympics game? */
select
	count(distinct ath_team)
from
	practice.athlete_events ;

/*
Which year saw the highest and lowest no of countries participating in olympics? */

(
select
	event_year,
	count(ath_team) as cnt,
	'Lowest' as Lowest_Highest
from
	practice.athlete_events
group by
	event_year
order by
	cnt
limit 1)
union
(
select
	event_year,
	count(ath_team) as cnt,
	'Highest' as Lowest_Highest
from
	practice.athlete_events
group by
	event_year
order by
	cnt desc
limit 1);

/* What if there are ties? This is an optimal solution.*/
select
	event_year,
	cnt,
	Lowest_Highest
from
	(
	select
		event_year,
		count(ath_team) as cnt,
		'Lowest' as Lowest_Highest,
		rank() over (
	order by
		count(ath_team)) as my_rank
	from
		practice.athlete_events
	group by
		event_year) subquery
where
	my_rank <= 1
union 
select
	event_year,
	cnt,
	Lowest_Highest
from
	(
	select
		event_year,
		count(ath_team) as cnt,
		'Highest' as Lowest_Highest,
		rank() over (
	order by
		count(ath_team) desc) as my_rank
	from
		practice.athlete_events
	group by
		event_year) subquery
where
	my_rank <= 1;

/*
Which nation has participated in all of the olympic games? */
select
	distinct(ath_team)
from
	practice.athlete_events
where
	game =
all(
	select
		distinct(game)
	from
		practice.athlete_events);

/*
Identify the sport which was played in all summer olympics. */
select
	distinct(sport)
from
	practice.athlete_events
where
	sport =
all(
	select
		distinct(sport)
	from
		practice.athlete_events
	where
		lower(event_season) like 'summer%');

/*
Which Sports were just played only once in the olympics? */
select
	sport
from
	practice.athlete_events
group by
	sport
having
	count(sport) = 1
order by
	sport;

/*
Fetch the total no of sports played in each olympic games.  */
select
	distinct(game),
	count(distinct sport) as cnt
from
	practice.athlete_events
group by
	game;

/*
Fetch details of the oldest athletes to win a gold medal.  */
select
	ath_name,
	ath_sex,
	ath_age,
	ath_height, 
	ath_weight, 
	ath_team
from
	practice.athlete_events
where
	medal = 'Gold'
order by
	ath_age desc
limit 1;
--This will fetch details of all oldest athletes. (Optimized solution)
select 
	ath_name,
	ath_sex,
	ath_age,
	ath_height, 
	ath_weight, 
	ath_team
from
	(
	select
		ath_name,
		ath_sex,
		ath_age,
		ath_height,
		ath_weight,
		ath_team,
		rank() over(
	order by
		ath_age desc) as rnk
	from
		practice.athlete_events
	where
		medal = 'Gold')
where
	rnk <= 1;

/*
Find the Ratio of male and female athletes participated in all olympic games. */
select
	count(ath_sex),
	'Male' as gender
from
	practice.athlete_events
where
	ath_sex = 'M'
union
select
	count(ath_sex),
	'Female' as gender
from
	practice.athlete_events
where
	ath_sex = 'F';

--Ratio
select
	round(cnt_m / cnt_f,
	2) as ratio
from
	(
	select
		*
	from
		(
		select
			count(ath_sex) filter(
		where
			ath_sex = 'M') as cnt_m,
			count(ath_sex) filter(
		where
			ath_sex = 'F') as cnt_f
		from
			practice.athlete_events));

/*
Fetch the top 5 athletes who have won the most gold medals. */
select
	ath_name,
		ath_sex,
		ath_age,
		ath_height,
		ath_weight,
		ath_team,
	medal_count
from
	(
	select
		ath_name,
		ath_sex,
		ath_age,
		ath_height,
		ath_weight,
		ath_team,
		count(medal) as medal_count,
		rank() over (
	order by
		count(medal) desc) as rnk
	from
		practice.athlete_events
	where
		medal = 'Gold'
	group by
		ath_name,
		ath_sex,
		ath_age,
		ath_height,
		ath_weight,
		ath_team)
where
	rnk <= 5;

/*
Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).  */
select
	ath_name,
		ath_sex,
		ath_age,
		ath_height,
		ath_weight,
		ath_team,
	medal_count
from
	(
	select
		ath_name,
		ath_sex,
		ath_age,
		ath_height,
		ath_weight,
		ath_team,
		count(medal) as medal_count,
		rank() over (
	order by
		count(medal) desc) as rnk
	from
		practice.athlete_events
	where
		medal in('Gold', 'Silver', 'Bronze')
	group by
		ath_name,
		ath_sex,
		ath_age,
		ath_height,
		ath_weight,
		ath_team)
where
	rnk <= 5;

/*
Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won. */
select
	ath_team,
	medal_count
from
	(
	select
		ath_team,
		count(medal) as medal_count,
		rank() over (
	order by
		count(medal) desc) as rnk
	from
		practice.athlete_events
	group by
		ath_team)
where
	rnk <= 5;

/*
List down total gold, silver and bronze medals won by each country.  */
select
	ath_team,
	count(medal) filter(
where
	medal = 'Gold') as gold_medals,
	count(medal) filter(
where
	medal = 'Silver') as silver_medals,
	count(medal) filter(
where
	medal = 'Bronze') as bronze_medals
from
	practice.athlete_events
group by
	ath_team
order by
	ath_team;

/* 
List down total gold, silver and bronze medals won by each country corresponding to each olympic games. */
select
	ath_team,
	sport,
	count(medal) filter(
where
	medal = 'Gold') as gold_medals,
	count(medal) filter(
where
	medal = 'Silver') as silver_medals,
	count(medal) filter(
where
	medal = 'Bronze') as bronze_medals
from
	practice.athlete_events
group by
	ath_team,
	sport
order by
	ath_team,
	sport;

/*
Identify which country won the most gold, most silver and most bronze medals in each olympic games. */
select
	*
from
	(
	select
		'Gold' as medal_type,
		ath_team,
		sport,
		medals_cnt
	from
		(
		select
			ath_team,
			sport,
			count(medal) as medals_cnt
		from
			practice.athlete_events
		where
			medal = 'Gold'
		group by
			ath_team,
			sport)
union
	select
		'Silver' as medal_type,
		ath_team,
		sport,
		medals_cnt
	from
		(
		select
			ath_team,
			sport,
			count(medal) as medals_cnt
		from
			practice.athlete_events
		where
			medal = 'Silver'
		group by
			ath_team,
			sport)
union
	select
		'Bronze' as medal_type,
		ath_team,
		sport,
		medals_cnt
	from
		(
		select
			ath_team,
			sport,
			count(medal) as medals_cnt
		from
			practice.athlete_events
		where
			medal = 'Bronze'
		group by
			ath_team,
			sport)
)
order by
	medal_type,
	ath_team,
	sport,
	medals_cnt;

/*
Identify which country won the most medals in each olympic games. */
select
	game,
	ath_team,
	medals_cnt
from
	(
	select
		*
	from
		(
		select
			game,
			ath_team,
			count(medal) as medals_cnt,
			rank() over (
		partition by game
		order by
			count(medal) desc) as rnk
		from
			practice.athlete_events
		where
			medal not in ('NA', 'Unknown Event')
		group by
			game,
			ath_team)
	where
		rnk <= 1)
order by
	game,
	ath_team,
	medals_cnt;

/*
Which countries have never won gold medal but have won silver/bronze medals? */
select
	distinct(ath_team)
from
	practice.athlete_events
where
	medal not in ('Gold')
	and medal in ('Silver', 'Bronze');

/*
In which Sport/event, Egypt has won highest medals.  */
select
	sport,
	count(medal) as medal_cnt
from
	practice.athlete_events
where
	medal not in ('NA', 'Unknown Event')
	and ath_team = 'Egypt'
group by
	sport
order by
	medal_cnt desc
limit 1;

/*
Break down all olympic games where Finland won medal for Hockey and how many medals. */
select
	sport,
	count(medal) as medal_cnt
from
	practice.athlete_events
where
	medal not in ('NA', 'Unknown Event')
	and ath_team = 'Finland'
group by
	sport
order by
	sport;
