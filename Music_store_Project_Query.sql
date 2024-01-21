---Easy 

-- 1. Who is the senior most employee based on job title ?

select * from employee ;
select emp_name
from employee
order by emp_age desc
limit 1;

-- 2. Which countries have the most invoices ?

select * from invoice ;
select billing_country, count(*) as no_of_invoices 
from invoice 
group by billing_country 
order by no_of_invoices desc;

-- 3. What are top 3 values of total invoice ?

select total from invoice
order by total desc
limit 3;

-- 4.Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
-- Write a query that returns one city that has the highest sum of invoice totals. 
-- Return both the city name & sum of all invoice totals 

select billing_city, sum(total) as invoice_total
from invoice 
group by billing_city
order by invoice_total desc
limit 1;

--OR

select c.city , sum(il.unit_price * il.quantity) as spending
from customer c
join invoice i on c.customer_id = i.customer_id
join invoice_line il on i.invoice_id = il.invoice_id
group by c.city
order by spending desc
limit 1;

-- 5.  Who is the best customer? The customer who has spent the most money will be declared the best customer. 
-- Write a query that returns the person who has spent the most money.

select c.customer_id ,c.first_name , c.last_name , sum(i.total) as customer_spending 
from customer c 
join invoice i on c.customer_id = i.customer_id
group by c.customer_id
order by customer_spending desc
limit 1;


--Moderate

-- 1.Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
-- Return your list ordered alphabetically by email starting with A.

select c.email , c.first_name , c.last_name 
from customer c 
join invoice i on c.customer_id = i.customer_id
join invoice_line il on i.invoice_id = il.invoice_id
join track t on il.track_id = t.track_id
join genre g on t.genre_id = g.genre_id
where g.name like 'Rock'
group by c.email , c.first_name , c.last_name  
order by c.email;

-- 2.Let's invite the artists who have written the most rock music in our dataset. 
-- Write a query that returns the Artist name and total track count of the top 10 rock bands.

select a.artist_id , a.name , count(a.artist_id) as no_of_song 
from artist a 
join album ab on a.artist_id = ab.artist_id
join track t on ab.album_id = t.album_id
join genre g on t.genre_id = g.genre_id
where g.name like 'Rock'
group by a.artist_id
order by no_of_song desc
limit 10;

-- 3.Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.

select name ,milliseconds
from track
where milliseconds > (select Avg(milliseconds) as avg_track_length from track)
order by milliseconds desc;

--Advance 

-- 1. Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent

with best_selling_artist as (
select ar.artist_id,ar.name as artist_name , sum(il.unit_price*il.quantity) as total_sales
from customer c 
join invoice i on c.customer_id = i.customer_id
join invoice_line il on i.invoice_id = il.invoice_id
join track t on il.track_id = t.track_id
join album a on t.album_id = a.album_id
join artist ar on a.artist_id = ar.artist_id
group by 1
order by 3 desc
limit 1
)

select c.customer_id,c.first_name , c.last_name, bsa.artist_name, sum(il.unit_price*il.quantity) as amount_spend
from customer c 
join invoice i on c.customer_id = i.customer_id
join invoice_line il on i.invoice_id = il.invoice_id
join track t on il.track_id = t.track_id
join album a on t.album_id = a.album_id
join artist ar on a.artist_id = ar.artist_id
join best_selling_artist bsa on bsa.artist_id = a.artist_id
group by 1,2,3,4
order by 5 desc;

-- 2. We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
-- with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
-- the maximum number of purchases is shared return all Genres.

with cte as (
select c.country, g.name, g.genre_id, count(il.quantity) as no_of_purchases,
row_number() over(partition by c.country order by count(il.quantity) desc) as rn
from customer c 
join invoice i on c.customer_id = i.customer_id
join invoice_line il on i.invoice_id = il.invoice_id
join track t on il.track_id = t.track_id
join genre g on t.genre_id = g.genre_id
group by 1,2,3
order by 1 asc , 4 desc) 

select * 
from cte
where rn <= 1;

-- 3. Write a query that determines the customer that has spent the most on music for each country. 
-- Write a query that returns the country along with the top customer and how much they spent. 
-- For countries where the top amount spent is shared, provide all customers who spent this amount.

WITH Customter_with_country AS (
		SELECT c.customer_id,c.first_name,c.last_name,i.billing_country,SUM(i.total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(i.total) DESC) AS RowNo 
		FROM invoice i
		JOIN customer c ON c.customer_id = i.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1

































