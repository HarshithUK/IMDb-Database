/*selects all names of the actors who have acted on a movie and a tv show whose production company is TM*/
select name
from person
where id in
(select cast_id from works_mov where mov_id in(select id from movie where prod_company='TM'))
and id in
(select cast_id from works_tv where tv_id in(select id from tv_show where prod_company='TM'));

/*selects all movie names and tv show names who have won awards of the same type*/
select M.name,T.name
from movie as M,tv_show as T
where (M.id,T.id) in(select m.movie_id,t.tv_id from awards_movie as m,awards_tv as t where m.award_type=t.award_type);

/*selects all names of movies which has won an award before the year 2015 and has an average rating of more than 9 by experts*/
select name
from movie
where id in(select movie_id from awards_movie where year < 2015 and is_won=1) and id in(select mov_id from movies_rated_by_exp group by mov_id having avg(rating) > 9);

/*updates rating to 9.5 of those movies who is rated by expert having id as 001 and has a box office collection more than 100000*/
update movies_rated_by_exp
set rating = 9.5
where exp_id='001' and mov_id in(select id from box_office where collection > '100000');

/*give an award to those movies who not only has a budget of more than 1000000 but also has a box office collection of more than 5000000 and has an average rating more than 8 by viewers*/
update awards_movie
set is_won=1
where movie_id in(select id from box_office where budget > '1000000' and collection > '5000000') and movie_id in(select mov_id from movies_rated_by_vie group by mov_id having avg(rating) > 8);

/*selects all ids and names of persons who has neither won an award for a movie nor won for a tv show (not won any award)*/
select id,name from person except (select id,name from person where id in(select cast_id from awards_movie where is_won=1) or id in(select cast_id from awards_tv where is_won=1));

/*gives the minimum, maximum and average ratings given by experts*/
select min(rating), max(rating), avg(rating)
from tv_rated_by_exp;

/*selects name of those movies who has collected the least in box office*/
select name from movie where id in(select id
from box_office where collection in(select min(collection) from box_office));

/*selects ids and names of all tv show directors*/
select id,name
from person
where id in(select cast_id from works_tv where type='Director');

/*selects ids and names of movies who has won an award after 2009*/
select id,name
from movie where id in(select movie_id from awards_movie where year >=2010 and is_won=1);

/*selects names of all male tv-show producers*/
select name
from person where gender='M' and id in(select cast_id from works_tv where type='Producer');

/*selects ids and names of movies which has a duration of more than 2 hours(120 minutes)*/
select id,name
from movie where duration > '120';

/*selects names of movies which is of comedy genre and has a budget of more than 100000*/
select name
from movie where genre = 'Comedy' and id in(select id from box_office where budget > '100000');

/*selects minimum and maximum budget*/
select min(budget), max(budget)
from box_office;

/*selects the names and average rating of top 5 movies based on ratings by experts*/
select name,avg(rating) from (movie inner join movies_rated_by_exp on id = mov_id) group by id order by avg(rating) desc limit 5;

/*selects the names and average rating of top 5 tv shows based on ratings by experts*/
select name,avg(rating) from (tv_show inner join tv_rated_by_exp on id = tv_id) group by id order by avg(rating) desc limit 5;

/*selects the names and average rating of top 5 drama tv shows based on ratings by experts*/
select name,avg(rating) from (tv_show full outer join tv_rated_by_exp on id = tv_id) where genre = 'Drama' group by id order by avg(rating) desc limit 5;

/*delete the movie having an id 013*/
delete from movie where id='013';

/*selects names of personalities who has won an award and was born in USA*/
select name from person where id in (select cast_id from awards_movie where is_won=1) and birthplace='USA';

/*selects names of personalities who has won atleast two awards*/
select name from person where id in (select cast_id from awards_movie group by cast_id having count(*) >= 2);

/*selects names of movies which has incurred a loss (has box-office collections less than its budget) */
select name from movie where id in (select id from box_office where collection < budget);