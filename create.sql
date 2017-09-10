create table movie
( 
  id varchar(5),
  name varchar(100),
  duration varchar(20),
  genre varchar(20),
  prod_company varchar(50),

  primary key(id)
);

create table box_office
(
  id varchar(5),
  collection varchar(10),
  budget varchar(10),
   
  foreign key(id) references movie on delete cascade
);

create table tv_show
(
  id varchar(5),
  name varchar(100),
  genre varchar(20),
  prod_company varchar(100), 
 
 primary key(id)
);

create table person
(
   id varchar(5),
   name varchar(100),
   gender char check (gender='M' or gender='F'),
   age integer,
   birthplace varchar(15),
   
   primary key(id)
);

create table works_mov
(
   mov_id varchar(5),
   cast_id varchar(5),
   type varchar(100) NOT NULL,
   role varchar(100),
   
   foreign key(mov_id) references movie on delete cascade,
   foreign key(cast_id) references person on delete cascade
);

create table works_tv
(
   tv_id varchar(5),
   cast_id varchar(5),
   type varchar(100) NOT NULL,
   role varchar(100),
   
   foreign key(tv_id) references tv_show on delete cascade,
   foreign key(cast_id) references person on delete cascade
);


create table critics_experts
(
	exp_id varchar(5),
	name varchar(100),
	

	primary key(exp_id)
);

create table critics_viewers
(
	viewer_id varchar(5),
	name varchar(100),

	primary key(viewer_id)
);

create table movies_rated_by_exp
(
	mov_id varchar(5),
	exp_id varchar(5),
	rating decimal(10,2) CHECK (rating >= 0 AND rating <= 10),

	foreign key(mov_id) references movie on delete cascade,
	foreign key(exp_id) references critics_experts on delete cascade
);

create table tv_rated_by_exp
(
	tv_id varchar(5),
	exp_id varchar(5),
	rating decimal(10,2) CHECK (rating >=0 AND rating <= 10),

	foreign key(tv_id) references tv_show on delete cascade,
	foreign key(exp_id) references critics_experts on delete cascade
);

create table movies_rated_by_vie
(
	mov_id varchar(5),
	vie_id varchar(5),
	rating decimal(10,2) CHECK (rating >=0 AND rating <= 10),

	foreign key(mov_id) references movie on delete cascade,
	foreign key(vie_id) references critics_viewers on delete cascade
);

create table tv_rated_by_vie
(
	tv_id varchar(5),
	vie_id varchar(5),
	rating decimal(10,2) CHECK (rating >=0 AND rating <= 10),

	foreign key(tv_id) references tv_show on delete cascade,
	foreign key(vie_id) references critics_viewers on delete cascade
);

create table awards_movie
(
	movie_id varchar(5),
	cast_id varchar(5),
	award_name varchar(100),
	award_type varchar(100),
	year integer check(year>=1929 AND year<=2016),
	is_won integer check(is_won=0 OR is_won=1),
	
	foreign key(movie_id) references movie on delete cascade,
	foreign key(cast_id) references person on delete cascade
);

create table awards_tv
(
	tv_id varchar(5),
	cast_id varchar(5),
	award_name varchar(100),
	award_type varchar(100),
	year integer check(year>=1929 AND year<=2016),
	is_won integer check(is_won=0 OR is_won=1),
	
	foreign key(tv_id) references tv_show on delete cascade,
	foreign key(cast_id) references person on delete cascade
);


