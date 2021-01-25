-- Write a query to display for each store its store ID, city, and country.
select a.store_id as Store, c.city, d.country
from sakila.store as a 
join sakila.address as b
using (address_id)  
join sakila.city as c
using(city_id)
join sakila.country as d
using (country_id)
group by Store;

-- Write a query to display how much business, in dollars, each store brought in.
select a.store_id as Store, sum(b.amount) as Amount
from sakila.staff as a
join sakila.payment as b
using(staff_id)
group by Store;

-- What is the average running time of films by category?
drop table if exists AvgDuration_Category;

create temporary table AvgDuration_Category
select c.name as Category, round(avg(a.length)) as AvgDuration
from sakila.film as a
join sakila.film_category as b
using (film_id)
join sakila.category as c
using (category_id)
group by Category;



-- Which film categories are longest?
select Category, AvgDuration
from sakila.AvgDuration_Category
order by AvgDuration desc
limit 5;

-- Display the most frequently rented movies in descending order.
drop table if exists FilmFrequency;

create temporary table FilmFrequency
select film_id,inventory_id, c.title, count(film_id) as NumberRentals
from sakila.rental as a
join sakila.inventory as b
using (inventory_id)
join sakila.film as c
using (film_id)
group by film_id, inventory_id
order by NumberRentals desc;

select * from FilmFrequency;

-- List the top five genres in gross revenue in descending order.
drop table if exists GenreGrossRevenue;

create temporary table GenreGrossRevenue
select category_id, name as category, sum(f.amount) as GrossRevenue
from sakila.category as a
right join film_category as b
using(category_id)
join sakila.film as c
using(film_id)
left join FilmFrequency as d
using(film_id)
left join sakila.rental as e
using(inventory_id)
left join sakila.payment as f
using(rental_id)
group by category_id
order by GrossRevenue desc;

select * from GenreGrossRevenue limit 5;


-- Is "Academy Dinosaur" available for rent from Store 1?
select b.inventory_id, a.film_id,  a.title, b.store_id,(count(rental_date) - count(return_date)) as NotAvailable
from film a
join inventory b
using(film_id)
join rental c
using(inventory_id)
group by b.inventory_id, a.film_id, store_id
having a.title = 'Academy Dinosaur' and store_id = 1;
