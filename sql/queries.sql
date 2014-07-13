create table agency (id varchar(255) primary key, name varchar(255), url varchar(255), timezone varchar(255), lang varchar(100),phone varchar(100));
load data infile 'agency.txt' into table agency fields terminated by ',' ignore 1 lines;

create table stop_times (trip_id varchar(255), arrival_time time, departure_time time, stop_id varchar(255), stop_sequence int, stop_headsign varchar(255), pickup_type varchar(255), drop_off_type varchar(255), shape_dist_traveled varchar(255));
alter table stop_times add index (trip_id);
alter table stop_times add index (stop_id);
load data infile 'stop_times.txt' into table stop_times fields terminated by ',' enclosed by '"' lines terminated by '\n' ignore 1 lines;

create table routes (route_id varchar(255),agency_id varchar(255),route_short_name varchar(255), route_long_name varchar(255), route_desc varchar(255), route_type varchar(255),route_color varchar(255),route_text_color varchar(255));
alter table routes add primary key (route_id);
load data infile 'routes.txt' into table routes fields terminated by ',' enclosed by '"' lines terminated by '\n' ignore 1 lines;

create table shapes (shape_id varchar(255),shape_pt_lat decimal(20,13),shape_pt_lon decimal(20,13),shape_pt_sequence int,shape_dist_traveled decimal(20,13));
alter table shapes add index (shape_id);
load data infile 'shapes.txt' into table shapes fields terminated by ',' enclosed by '"' lines terminated by '\n' ignore 1 lines;

create table stops (stop_id varchar(255), stop_code varchar(255), stop_name varchar(255),stop_lat decimal(20,13), stop_lon decimal(20,13), location_type varchar(255),parent_station varchar(255),wheelchair_boarding varchar(255),platform_code varchar(255));
alter table stops add primary key (stop_id);
load data infile 'stops.txt' into table stops fields terminated by ',' enclosed by '"' lines terminated by '\n' ignore 1 lines;

create table trips (route_id  varchar(255),service_id varchar(255),trip_id varchar(255),shape_id varchar(255),trip_headsign varchar(255),direction_id varchar(255),block_id varchar(255),wheelchair_accessible varchar(255));
alter table trips add primary key (trip_id);
load data infile 'trips.txt' into table trips fields terminated by ',' enclosed by '"' lines terminated by '\n' ignore 1 lines;

create table calendar (service_id varchar(255),monday int, tuesday int, wednesday int, thursday int, friday int, saturday int, sunday int, start_date datetime, end_date datetime);
alter table calendar add index (service_id);
alter table calendar add index (start_date);
alter table calendar add index (end_date);
load data infile 'calendar.txt' into table calendar fields terminated by ',' enclosed by '"' lines terminated by '\n' ignore 1 lines;


create table calendar_dates (service_id varchar(255), date datetime, exception_type varchar(10));
alter table calendar_dates add index (service_id);
load data infile 'calendar_dates.txt' into table calendar_dates fields terminated by ',' enclosed by '"' lines terminated by '\n' ignore 1 lines;


create table all_trip_duration (route_id varchar(255), trip_id varchar(255), route_long_name varchar(255), departure_time time, stop_id varchar(255), stop_name varchar(255), stop_sequence int);
alter table all_trip_duration add index(trip_id);
alter table all_trip_duration add index (stop_id);


insert into all_trip_duration
select r.route_id, t.trip_id, r.route_long_name, st.departure_time, s.stop_id, s.stop_name, st.stop_sequence 
from trips t
inner join routes r on r.route_id = t.route_id 
inner join stop_times st on st.trip_id = t.trip_id
inner join stops s on st.stop_id = s.stop_id
order by t.trip_id desc



create table all_aggregate_trip (trip_id varchar(255), origin_stop_id varchar(255), 
origin_stop_name varchar(255), departure_time time, destination_stop_id varchar(255), destination_stop_name varchar(255), arrival_time time);
alter table all_aggregate_trip add index(origin_stop_id);
alter table all_aggregate_trip add index (destination_stop_id);

insert into all_aggregate_trip
select start_st.trip_id, start_st.stop_id, start_st.stop_name,
start_st.departure_time, 
td.stop_id, td.stop_name, td.departure_time
from all_trip_duration td
inner join all_trip_duration start_st on td.trip_id = start_st.trip_id
where start_st.stop_id != td.stop_id
and start_st.stop_sequence = 1
and td.stop_sequence = (select max(stop_sequence) 
from all_trip_duration atd
where atd.trip_id = td.trip_id)


select * from routes where agency_id in ('112', '116', '117', '11954', '125', '14', '22', '300', '301', '306', '307','92','CR','LR')


select r.route_id, at.departure_time, 
time_format(abs(timediff(at.departure_time, at.arrival_time)), "%T") as duration
from calendar c
inner join trips t on c.service_id = t.service_id
inner join all_aggregate_trip at on at.trip_id = t.trip_id
inner join routes r on r.route_id = t.route_id
and c.monday = 1
where start_date < '2014-07-15 00:00:00' and end_date > '2014-07-14 00:00:00'
and at.departure_time < '24:00:00'
order by at.departure_time
