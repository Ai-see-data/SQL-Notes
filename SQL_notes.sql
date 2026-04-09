#Relationships
#1:1 - each record in table 1 relates to exactly one record in table 2
--   example: Each store_id in store table relates to each record in address table address_id
#1:N - one record in table 1 relates to multiple records in table 2, reverse for N:1
-- example: Each customer_id in customer has multiple rentals in the rental table but each rental
-- belongs to only one customer and for N:1- multiple rentals can belong to one customer
#M:N - Multiple records in table 1 relates to multiple records in table 2
-- example: one film can have many actors and one actor can appear in many films
-- film_actor acts as the bridge table. 
    
#Joins
#1. Inner join
--  Brings in only the common/ matching values from both tables 1 and 2, excludes non matching rows.
		select c.first_name, r.rental_id
		from customer c
		inner join rental r on c.customer_id = r.customer_id

#2.  left join
--  Returns all the rows from left table and matching ones from thr right, for non matched rows, right side table shows null
		select f.film_id, f.title, i.inventory_id
		from film f
		left join inventory i on f.film_id = i.film_id
		where f.film_id  IN (14,33,36,2,3)

#3. Right join
-- Returns all the rows from right table and matching ones from thr left, for non matched rows, left side table shows null
		select f.film_id, f.title, i.inventory_id
		from film f
		right join inventory i on f.film_id = i.film_id
		where f.title IS NULL

#4. Full outer join ( simulated using union of left and right joins)
-- returns all rows from both the tables, returns null when there is no match on either side.
		select c.first_name, r.rental_id
		from customer c
		left join rental r on c.customer_id = r.customer_id
		union
		select c.first_name, r.rental_id
		from customer c
		right join rental r on c.customer_id = r.customer_id

#5. Cross join
-- Returns the cartesian product — every row from Table 1 paired with every row from Table 2
-- does not require ON condition
		select s.first_name as staff_name, st.store_id
		from staff s
		cross join store st;
        
#6. self join
-- table joined with itself
		select a.first_name as actor1, b.first_name as actor2, a.last_name
		from actor a
		join actor b on a.last_name = b.last_name
		where a.actor_id < b.actor_id;

#7.	DateTime
select distinct month(return_date) from rental
select distinct year(return_date) from rental
select distinct monthname(return_date) from rental

-- This query retrieves the total revenue generated per year .
	select year(payment_date) as pay_year, sum(amount) as total
	from payment
	group by year(payment_date)#, customer_id
	order by pay_year
    
-- top 10 max payment done in the last 3 months
	select customer_id, amount, payment_date
	from payment
	where payment_date >= (select MAX(payment_date) from payment)- Interval 3 month
	order by amount DESC
	limit 10
    
#8	Subqueries
#A subquery is a query written inside another query.It is executed first and its result is passed to the outer query. 
#Commonly used in WHERE, SELECT, and HAVING clauses.

-- Total no. of customers who have made payments above the average amount
select count(*)
from film
where rental_rate > (select avg(rental_rate) from film)


#9 CTE
-- A CTE is a named temporary result set defined using the WITH keyword
-- that makes complex queries more readable and reusable within the same query.
-- customers who have made payments above the average amount

with avg_rate as ( 
	select avg(rental_rate) as avg_rental_rate
    from film
    )
select film_id, title, rental_rate, avg_rental_rate
from film, avg_rate 
where rental_rate > avg_rental_rate


with avg_dur as ( 
	select avg(rental_duration) as avg_rental_dur
    from film
    )
select film_id, title, rental_duration, avg_rental_dur
from film, avg_dur
where rental_duration > avg_rental_dur

#10 Dervied Tables
-- it is a subquery used in the from clause that acts as a temporary inline table
-- needs an alias, and exists only for the duration of the query

-- Find customers whose total payments exceed 100
select c.first_name, c.last_name, ct.total_paid
from customer c
join (
    select customer_id, SUM(amount) as total_paid
    from payment
    group by customer_id
) as ct on c.customer_id = ct.customer_id
where ct.total_paid > 100
order by ct.total_paid desc

#11 View
-- Saved permanently in the database. is based on the result of a SELECT query
-- You can come back and use it anytime like a regular table.
-- create a view for customer payment totals
create view customer_payment_totals as
select customer_id, sum(amount) as total_paid
from payment
group by customer_id;
-- use the view like a regular table
select c.first_name, c.last_name, v.total_paid
from customer c
join customer_payment_totals v on c.customer_id = v.customer_id
where v.total_paid > 100
order by v.total_paid desc

#12 Temp table
-- A temporary table is a table that is created and stored temporarily
-- exists only for the duration of the current session, and is dropped when the session ends.

-- create a temporary table for high value customers
create temporary table high_value_customers as
select customer_id, sum(amount) as total_paid
from payment
group by customer_id
having sum(amount) > 100;
-- use it like a regular table
select c.first_name, c.last_name, h.total_paid
from customer c
join high_value_customers h on c.customer_id = h.customer_id
order by h.total_paid desc;

#13 clustered index / non clustered index
--  determines the physical order of data in a table
-- a table can have just 1 clustered index, primary key acts as clustered index
-- clustered index already exists on film_id (primary key) 
-- creating non clustered index on title speeds on title searches
-- without index (mysql scans every row)
select film_id, title
from film
where title = 'ACADEMY DINOSAUR'

-- create a non-clustered index on title
create index idx_film_title on film(title)

-- same query now uses the index instead of scanning every row
select film_id, title
from film
where title = 'ACADEMY DINOSAUR'

-- before index
explain select * from film where title = 'ACADEMY DINOSAUR';

-- create index
create index idx_film_title on film(title);

-- after index
explain select * from film where title = 'ACADEMY DINOSAUR';
