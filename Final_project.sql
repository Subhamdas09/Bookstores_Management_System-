-- Create Database
CREATE DATABASE online_bookstores;

-- Switch to the database
\c online_bookstores;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books(
	Book_ID INT PRIMARY KEY,
	Title VARCHAR (100),
	Author VARCHAR (100),
	Genre VARCHAR (50),
	Published_Year INT,
	Price NUMERIC (10,2),
	Stock INT
);

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers(
	Customer_ID INT PRIMARY KEY,
	Name VARCHAR (50),
	Email VARCHAR (100),
	Phone VARCHAR (12),
	City VARCHAR (100),
	Country VARCHAR (100)
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
	Order_ID INT PRIMARY KEY,
	Customer_ID INT REFERENCES Customers(Customer_ID),
	Book_ID INT REFERENCES Books(Book_ID),
	Order_Date DATE,
	Quantity INT,
	Total_Amount NUMERIC(10, 2)
);

SELECT*FROM Books;
SELECT*FROM Orders;
SELECT*FROM Customers;


-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM '‪C:\Users\Subham Das\OneDrive\Desktop\Online_BookStors Data\Books.csv' 
CSV HEADER;

-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM 'C:\Users\Subham Das\OneDrive\Desktop\Online_BookStors Data\Customers.csv' 
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
FROM 'C:\Users\Subham Das\OneDrive\Desktop\Online_BookStors Data\Orders.csv' 
CSV HEADER;


--- Basics Questions:

--- 1) Retrieve all books in the "Fiction" genre:

SELECT * FROM Books
WHERE Genre LIKE 'Fiction';

--- 2)Find books published after the year 1095:

SELECT * FROM BOOKS
WHERE Published_year>1950;

--- 3)List all coustomers from the Canada:

SELECT * FROM Customers
WHERE country LIKE 'Canada';

--- 4)Show orders placed in november 2023:

SELECT * FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

--- 5) Retrive the total stock of book available:

SELECT SUM(Stock) AS Total_stocks 
FROM Books;

--- 6) Find the details of the most expensive book:

SELECT * FROM Books 
ORDER BY price DESC 
LIMIT 1;

--- 7) Show all coustomers who ordered more than 1 quantity of a book:

SELECT * FROM Orders
WHERE quantity>1 ;

--- 8) Retrive all orders where the total amount exceeds $20:

SELECT * FROM Orders
WHERE total_amount>20;

--- 9)List all genres available in the table:

SELECT DISTINCT(genre) FROM Books;

--- 10) Find the book with the lowest stock:

SELECT * FROM Books 
ORDER BY stock
LIMIT 1;

--- 11) Calculate the total revenue generated from all orders:

SELECT SUM(total_amount) AS Revenue 
FROM Orders;



--- Advance Questions:



--- 1) Retrivee the total number of books sold for each genre:

SELECT b.genre, SUM(o.quantity) AS Total_book_sold
FROM Orders o
JOIN Books b 
ON O.book_id = b.book_id
GROUP BY b.genre;

--- 2) Find the average price of books in "Fantasy" genre:

SELECT AVG(price) AS avg_price
FROM Books
WHERE genre = 'Fantasy';

--- 3) List customers who have placed at least 2 orders:

SELECT c.Customer_id, c.name, COUNT(o.order_id)
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id)>=2;

--- 4) Find the most frequently ordered book:

SELECT b.title, o.book_id, COUNT(o.order_id) AS Order_count
FROM Orders o
JOIN Books b ON b.book_id = o.book_id
GROUP BY o.Book_id, b.title
ORDER BY COUNT(o.order_id) DESC LIMIT 1;

---5) Show the top 3 most expensive books of 'Fantasy' genre:

SELECT * FROM Books
WHERE genre = 'Fantasy'
ORDER BY price DESC LIMIT 3;

---6) Retrive the total quantity of books sold each author:

SELECT b.author, SUM(o.quantity) AS Total_book_sold
FROM Orders o
JOIN Books b ON b.book_id = o.book_id
GROUP BY b.author;

---7) List the cities where customer who spent over $30 are located:

SELECT DISTINCT c.city, o.total_amount 
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.total_amount>30;

---8) Find the customer who spent the most on orders:

SELECT  c.customer_id, c.name, SUM(o.total_amount) AS Most_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Most_spent DESC LIMIT 1;

---9) Calculate the stock remaning after fulfilling all orders:

SELECT b.book_id, b.title, b.stock,COALESCE(SUM(o.quantity),0) AS Order_quantity,
	b.stock - COALESCE(SUM(o.quantity),0) AS Remaining_quantity
FROM books b
LEFT JOIN orders o ON b.book_id = o.book_id
GROUP BY b.book_id ORDER BY b.book_id;





