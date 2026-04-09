#1. display all customer details who have made more than 5 payments.
select  distinct c.customer_id, c.first_name, c.last_name
from customer c
join payment p on c.customer_id=p.customer_id
where c.customer_id in ( select p.customer_id from payment p
group by p.customer_id
having count(p.payment_id)>5) ;

#2. Find the names of actors who have acted in more than 10 films.
select actor_id, first_name, last_name
from actor
where actor_id in (select actor_id 
from film_actor
group by actor_id
having count(film_id)>30);

#3. Find the names of customers who never made a payment.
select first_name, last_name
from customer c
where not exists( select * from payment p 
where p.customer_id = c.customer_id);					

#4.List all films whose rental rate is higher than the average rental rate of all films(CTE).
with avg_rate as ( 
	select avg(rental_rate) as avg_rental_rate
    from film
    )
select film_id, title
from film, avg_rate 
where rental_rate > avg_rental_rate;

#5. List the titles of films that were never rented. (Temp)
create temporary table rented_films as
select distinct film_id
from inventory i join rental r on i.inventory_id = r.inventory_id;

select film_id,title
from film
where film_id not in ( select film_id from rented_films);

#6. Display the customers who rented films in the same month as customer with ID 5.
with same_cust as (
	select distinct customer_id
	from rental
	where month(return_date) in (select month(return_date) 
								from rental
								where customer_id=5);
				 )
select first_name, last_name, customer_id
from customer 
where customer_id in ( select customer_id from same_cust) and customer_id!=5;

#7. Find all staff members who handled a payment greater than the average payment amount.
with avg_staff as (
	select distinct staff_id
	from payment
	where amount > (select avg(amount) from payment)
    );
select s.staff_id, s.first_name, s.last_name
from staff s
join avg_staff avs on s.staff_id= avs.staff_id;

#8. Show the title and rental duration of films whose rental duration > than average.
select film_id, title, rental_duration
from film
where rental_duration > ( select avg(rental_duration) as avg_rental_dur
    from film)
order by rental_duration;

#9. Find all customers who have the same address as customer with ID 1.
create view cust_same_address as 
select customer_id
from customer
where address_id = ( select address_id from customer where customer_id=1)
and customer_id!=1;

select c.customer_id, c.first_name, c.last_name
from customer c
join cust_same_address as cs
on c.customer_id=cs.customer_id;

#10. List all payments that are greater than the average of all payments.
select amount
from payment
where amount > (select avg(amount) from payment)
order by amount