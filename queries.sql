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

