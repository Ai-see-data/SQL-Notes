#Get all customers whose first name starts with 'J' and who are active.
select customer_id, first_name, last_name from customer
where first_name like 'J%' and active = 1

#Find all films where the title contains the word 'ACTION' or the description contains 'WAR'.
select film_id, title, description from film
where title like '%action%' or description like '%war%'

# List all customers whose last name is not 'SMITH' and whose first name ends with 'a'.
select customer_id, first_name, last_name from customer
where first_name like '%a' and last_name!='%smith%'

# Get all films where the rental rate is greater than 3.0 and the replacement cost is not null.
select title from film
where rental_rate > 3.0 and replacement_cost is not null

#Count how many customers exist in each store who have active status = 1.
select store_id, count(customer_id) as count_of_cust from customer
where  active=1
group by store_id

#Show distinct film ratings available in the film table.
select distinct rating from film

#Find the number of films for each rental duration where the average length is more than 100 minutes.
select rental_duration, count(film_id), avg(length) from film
group by rental_duration
having avg(length) > 100

#List payment dates and total amount paid per date, but only include days where more than 100 payments were made.
select payment_date, sum(payment_date) from payment
group by payment_date
having count(payment_id) > 100

#ind customers whose email address is null or ends with '.org'.
select customer_id, email from customer
where email is null or email like '%.org'

#List all films with rating 'PG' or 'G', and order them by rental rate in descending order.
select  title, rental_rate from film
where rating IN ('PG','G')
order by rental_rate desc

#Count how many films exist for each length where the film title starts with 'T' and the count is more than 5.
select length, count(film_id) from film
where title like 'T%' 
group by length
having count(film_id) > 5

#List all actors who have appeared in more than 10 films.
select b.first_name, b.last_name from film_actor a
join actor b on a.actor_id=b.actor_id
group by a.actor_id
having count(a.film_id) > 10

#Find the top 5 films with the highest rental rates and longest lengths combined, ordering by rental rate first and length second.
select title,rental_rate, length  from film
order by rental_rate desc, length desc
limit 5

# Show all customers along with the total number of rentals they have made, ordered from most to least rentals.
select c.first_name,c.last_name, r.customer_id, count(r.rental_id) 
from customer c join rental r
on c.customer_id=r.customer_id
group by r.customer_id,c.first_name,c.last_name
order by count(r.rental_id) desc

#List the film titles that have never been rented.
select f.title
from film f
left join inventory i on f.film_id = i.film_id
left join rental r on i.inventory_id = r.inventory_id
where r.rental_id is null;

#JOINS
#1. List all customers along with the films they have rented.
select c.customer_id, c.first_name, c.last_name, f.title
from rental r 
join inventory i on r.inventory_id=i.inventory_id
join film_text f on f.film_id=i.film_id
join customer c on c.customer_id=r.customer_id
order by c.customer_id

#2. List all customers and show their rental count, including those who haven't rented any films.
select c.customer_id, c.first_name, c.last_name, count(r.rental_id) as rental_count
from customer c
left join rental r on c.customer_id = r.customer_id
group by c.customer_id, c.first_name, c.last_name
order by rental_count desc;

#3. Show all films along with their category. Include films that don't have a category assigned.
select f.film_id, f.title, c.name as category
from film f
left join film_category fc on f.film_id = fc.film_id
left join category c on fc.category_id = c.category_id

#4. Show all customers and staff emails from both customer and staff tables using a full outer join (simulate using LEFT + RIGHT + UNION).
select c.first_name, c.last_name, c.email, 'customer' as type
from customer c
left join staff s on c.email = s.email
union
select s.first_name, s.last_name, s.email, 'staff' as type
from staff s
left join customer c on s.email = c.email;

#5. Find all actors who acted in the film "ACADEMY DINOSAUR".
select a.actor_id, a.first_name, a.last_name
from actor a
join film_actor fa on a.actor_id = fa.actor_id
join film f on fa.film_id = f.film_id
where f.title = 'ACADEMY DINOSAUR'

#6. List all stores and the total number of staff members working in each store, even if a store has no staff.
select s.store_id, count(st.staff_id) as total_staff
from store s
left join staff st on s.store_id = st.store_id
group by s.store_id

#7. List the customers who have rented films more than 5 times. Include their name and total rental count.
select c.customer_id, c.first_name, c.last_name, count(r.rental_id) as total_rentals
from customer c
join rental r on c.customer_id = r.customer_id
group by c.customer_id, c.first_name, c.last_name
having count(r.rental_id) > 5
order by total_rentals desc