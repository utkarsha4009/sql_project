select * from orders;
select * from customers;
select * from books;

alter table books
modify book_id int primary key;

alter table customers 
modify customer_id int primary key;

alter table orders
modify order_id int primary key;

alter table orders
add constraint fk_customer
foreign key (customer_id)
references customers(customer_id);

alter table orders
add constraint fk_book
foreign key (book_id)
references books(book_id);

#retrive all books in 'Fiction'genre#

select * from books where genre ='Fiction';

#find the book published after the yesr 1950#

select * from books where published_year>1950;

#list all customers from canada#

select * from customers where country='Canada';

#show orders placed in November 2023#

select * from orders
where order_date between
to_date('2023-11-01','yyyy-mm-dd')and
to_date('2023-11-30','yyyy-mm-dd');

#orders placed in december 2023#

select * from orders
where order_date between to_date('2023-12-01','yyyy-mm-dd')
and to_date('2023-12-31','yyyy-mm-dd');


#retrive the total stalk of books available#

select sum(stock)from books;

#find the details of the most expencive book#

select * from books where price in (select max(price) from books);

#show all customers who orderd more than 1 quantity of book#

select * from customers
where customer_id in (select customer_id from orders where quantity>1);

#retrive all orders where the total amount exceeds $20#

select * from orders where total_amount>20;

#list all genres available in the book table#

select distinct genre from books;

#find the book with the lowest stock#

select * from books where stock in(select min(stock)from books);
##or##
select * from books where 
stock in (select min(stock)from books where stock !=0);

# calculate the total revenue genereted from all the  orders#

select sum(total_amount)from orders;

#### Advanced####
select * from books;
select * from orders;
select * from customers;

#retrive the total number of books sold for the each genre#

select b.genre,sum(o.quantity)as total_quantity
from books b
join orders o
on b.book_id = o.book_id
group by b.genre
order by total_quantity desc; 

#find the average price of book in the Fantasy genre#

select genre,avg(price)from books
where genre='Fantasy'
group by genre;

#list customers who have placed atleast 2 orders#


select customer_id , count(order_id)as orders_placed
from orders
group by customer_id
having count(order_id) >=2
order by orders_placed desc;

#using join#

select c.customer_id,c.name,count(o.order_id)as total_orders
from customers c
join orders o
on c.customer_id = o.customer_id
group by c.customer_id,c.name
having count(o.order_id)>=2;


#find the most frequently orderd book#

select * from books 
where book_id in (select book_id from (select book_id,count(order_id)from orders
group by book_id
having count(order_id)=4
order by count(order_id)desc));

#show the top three most expencive books of Fantasy genre#

select * from
(select books.*,dense_rank()over(order by price desc)as rank from books
where genre='Fantasy')
where rank <=3;

#retrive the total quantity of books sold by each other#


select b.author,sum(o.quantity) from books b
join orders o
on b.book_id = o.book_id
group by b.author
order by sum(o.quantity)desc;

#list the cities where the customers who spent over $30 are licated#

select distinct city from customers 
where customer_id in (select customer_id from (select customer_id,sum(total_amount)from orders
group by customer_id
having sum(total_amount)>=30));

#find the customer who spent most on orders#

select * from customers
where customer_id in(select customer_id from (select customer_id ,sum(total_amount),dense_rank()over (order by sum(total_amount)desc)
as rn
from orders
group by customer_id
order by sum(total_amount)desc)where rn=1);

#calculate the stock remaining after fulfilling all the orders#

select * from books;
select * from orders;

select 
b.book_id,
b.title,
b.stock as initial_stock,
coalesce(b.stock-sum(o.quantity),b.stock)as remaining_stock
from books b
left join orders o 
on b.book_id = o.book_id
group by b.book_id,b.title,b.stock;


