Drop table if exists netflix;

create table netflix
(
show_id varchar(6),
category varchar(10),		
title varchar(105),
director varchar(210),
casts varchar(1000),
country	varchar(150),
date_added varchar(50),
release_year int,	
rating varchar(10),
duration varchar(15),	
listed_in varchar(105),	
description varchar(250)

);

select * from netflix;

-- 15 Business Problems & Solutions

--1. Count the number of Movies vs TV Shows.

select category, count(show_id) as TOTAL
from netflix
group by category;



--2. Find the most common rating for movies and TV shows

select
	rating,
	category
from
(
select 
	rating, 
	category, 
	count(*),
	rank() over(partition by category order by count(*) desc) as ranking
from netflix
group by rating, category
) as tab1

where ranking = 1;


--3. List all movies released in a specific year (e.g., 2020)

select
	title,
	category,
	release_year
from netflix
where category = 'Movie' and release_year = 2020;


--4. Find the top 5 countries with the most content on Netflix

select
	unnest(string_to_array(country,',')) as updated_country,
	count(*)
from netflix
group by 1
order by 2 desc
limit 5;


--5. Identify the longest movie

select 
	category,
	substring(duration,1,position('m' in duration)-1) :: int as duration
from netflix
where category = 'Movie' and duration  is not null
order by duration desc
limit 1;


--6. Find content added in the last 5 years

select *
from netflix
where to_date(date_added,'FMMonth DD, YYYY') >= current_date - interval '5 years';


--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select * from netflix
where director like '%Rajiv Chilaka%';




--8. List all TV shows with more than 5 seasons

select *
from netflix
where category = 'TV Show' and split_part(duration, ' ', 1) :: int > 5;


--9. Count the number of content items in each genre

select
	unnest(string_to_array(listed_in, ',')) as genre,
	count(*)
from netflix
group by 1;


--10.Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release!


select
	extract(year from(to_date(date_added, 'Month DD, YYYY'))),
	count(*),
	round(count(*) :: numeric/(select count(*) from netflix where country ILIKE '%India%') :: numeric * 100,2) as Average_Content
from netflix
where country ILIKE '%India%'
group by 1;



--11. List all movies that are documentaries

select *
from netflix
where category = 'Movie' and listed_in ILIKE '%Documentaries%';


--12. Find all content without a director

select *
from netflix
where director is null;


--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select *
from netflix
where casts ILIKE '%Salman Khan%' and release_year >= extract(year from current_date) - 10;


--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.


select
	unnest(string_to_array(casts, ',')) as Actors,
	count(*)
from netflix
where country ILIKE '%India%'
group by 1
order by 2 desc
limit 10;


--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.

with tab1
as
(
select *,
	case when description ILIKE '%kill%' or 
	description ILIKE 'violence' then 'Bad Content' else 'Good Content' 
	END Content_Category
from netflix 
)
select 
	Content_Category,
	count(*)
from tab1
group by 1;






                                                                                                                                                                                                                                                                                                                                                                                                
																																																																																																