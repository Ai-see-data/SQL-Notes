
-- 1. TOPIC: What is SQL?
-- SQL (Structured Query Language) is used to communicate with databases.
-- It allows you to create, read, update, and delete data.
-- 2. DBMS: Database Management System - stores data but no relationships enforced
-- RDBMS: Relational DBMS - data is stored in related tables with keys
-- 3. A TABLE is a collection of related data (like a spreadsheet)
-- ROWS are individual records
-- COLUMNS are the attributes/fields
-- Example: The actor table has columns: actor_id, first_name, last_name, last_update
-- Each row is one actor
-- View the structure of the actor table
DESCRIBE actor;
-- View the structure of the film table
DESCRIBE film;
-- See rows and columns
SELECT actor_id, first_name, last_name FROM actor LIMIT 5;
-- 4. TOPIC: Schemas and Databases
-- A DATABASE is a container for all your data
-- A SCHEMA defines the structure (tables, columns, types, relationships)
-- Show all databases on this server
SHOW DATABASES;
-- Use/select the sakila database
USE sakila;
-- Show all tables in the current schema
SHOW TABLES;
-- See the full schema/structure of a table
SHOW CREATE TABLE film;

-- 5. TOPIC: SQL Syntax Rules
-- Rules:
-- 1. SQL is NOT case sensitive (SELECT = select)
-- 2. Statements end with a semicolon ;
-- 3. String values use single quotes 'value'
-- 4. Keywords are written in UPPERCASE
-- Example: These two are the same
SELECT first_name FROM actor LIMIT 5;
select first_name from actor limit 5;

-- 6. TOPIC: SQL Keywords and Identifiers
-- KEYWORDS in SQL: SELECT, FROM, WHERE, JOIN, etc.
-- IDENTIFIERS are names you give to tables, columns, databases
-- Keywords example:
SELECT title, release_year   -- SELECT, FROM are keywords
FROM film                    -- film is an identifier (table name)
WHERE release_year = 2006;   -- WHERE is a keyword

-- 7. TOPIC: SQL Data Types
-- Common data types:
-- INT         : whole numbers (actor_id, film_id)
-- VARCHAR(n)  : variable length text (first_name, title)
-- TEXT        : long text (description)
-- DECIMAL     : numbers with decimals (rental_rate, replacement_cost)
-- DATE        : date only
-- DATETIME    : date and time (last_update)
-- ENUM        : one value from a fixed list (rating)
-- YEAR        : year value (release_year)

-- 8. TOPIC: Creating a Database
-- Syntax: CREATE DATABASE database_name;
-- Example: Create a practice database
CREATE DATABASE sakila_practice;
-- Verify it was created
SHOW DATABASES;
-- to delete
DROP DATABASE sakila_practice;

-- 9. TOPIC: Using / Selecting a Database
-- Before querying, you must select which database to use
-- Syntax: USE database_name;
USE sakila;
-- Confirm which database is currently active
SELECT DATABASE();

-- 10. TOPIC: Creating a Table
-- Syntax:
-- CREATE TABLE table_name (
--   column1 datatype constraints,
--   column2 datatype constraints
-- );
-- 11. TOPIC: Inserting Starter Data
-- Syntax:
-- INSERT INTO table_name (col1, col2) VALUES (val1, val2);
USE sakila;
-- First recreate the sample table
CREATE TABLE sample_student (
    student_id   INT AUTO_INCREMENT PRIMARY KEY,
    first_name   VARCHAR(50) NOT NULL,
    last_name    VARCHAR(50) NOT NULL,
    email        VARCHAR(100),
    enrolled_on  DATE
);
-- Insert a single row
INSERT INTO sample_student (first_name, last_name, email, enrolled_on)
VALUES ('John', 'Doe', 'john@email.com', '2024-01-15');

-- Insert multiple rows at once
INSERT INTO sample_student (first_name, last_name, email, enrolled_on)
VALUES
    ('Jane', 'Smith', 'jane@email.com', '2024-02-10'),
    ('Bob', 'Brown', 'bob@email.com', '2024-03-05'),
    ('Alice', 'White', 'alice@email.com', '2024-04-01');

-- Verify the inserted data
SELECT * FROM sample_student;

-- delete
DROP TABLE sample_student;

-- 13. TOPIC: Operators in SQL
-- COMPARISON OPERATORS:
SELECT title, rental_rate FROM film WHERE rental_rate > 2.99;
SELECT title, rental_rate FROM film WHERE rental_rate != 0.99;

-- LOGICAL OPERATORS: AND, OR, NOT
SELECT title, rating, rental_rate
FROM film
WHERE rating = 'PG' AND rental_rate < 2.99;

SELECT title, rating
FROM film
WHERE rating = 'G' OR rating = 'PG';

SELECT title, rating
FROM film
WHERE NOT rating = 'R';

-- ARITHMETIC OPERATORS: 
SELECT title, rental_rate, replacement_cost,
       (replacement_cost - rental_rate) AS price_difference
FROM film
LIMIT 10;

-- BETWEEN operator
SELECT title, rental_rate
FROM film
WHERE rental_rate BETWEEN 1.99 AND 3.99;

-- IN operator
SELECT title, rating
FROM film
WHERE rating IN ('G', 'PG', 'PG-13');

-- LIKE operator (pattern matching)
SELECT first_name, last_name
FROM actor
WHERE first_name LIKE 'A%';  -- starts with A

-- 14. TOPIC: NULL Values
-- NULL means no value / unknown — it is NOT zero or empty string
-- Use IS NULL or IS NOT NULL to check for NULLs

-- Find customers with no email
SELECT first_name, last_name, email
FROM customer
WHERE email IS NULL;

-- Find customers who DO have an email
SELECT first_name, last_name, email
FROM customer
WHERE email IS NOT NULL
LIMIT 10;

-- Use IFNULL to replace NULL with a default value
SELECT first_name, last_name,
       IFNULL(email, 'No Email Provided') AS email
FROM customer
LIMIT 10;

-- 15. TOPIC: Aliases
-- Aliases give a temporary name to a column or table
-- Use AS keyword 

-- Column alias
SELECT first_name AS 'First Name',
       last_name  AS 'Last Name'
FROM actor
LIMIT 10;

-- 16. TOPIC: SELECT Statement

-- SELECT retrieves data from one or more tables
-- Syntax: SELECT col1, col2 FROM table_name;
-- Select all columns
SELECT * FROM actor;
-- Select specific columns
SELECT first_name, last_name FROM actor;
-- Select with a calculation
SELECT title,
       rental_rate,
       rental_duration,
       (rental_rate * rental_duration) AS total_rental_value
FROM film
LIMIT 10;

-- 17. TOPIC: SELECT DISTINCT
-- DISTINCT removes duplicate values from results
-- Without DISTINCT (may show duplicates)
SELECT rating FROM film;
-- With DISTINCT (unique values only)
SELECT DISTINCT rating FROM film;
-- Distinct combination of columns
SELECT DISTINCT rating, rental_rate
FROM film
ORDER BY rating, rental_rate;

-- 18. TOPIC: WHERE Clause
-- WHERE filters rows based on a condition
-- Syntax: SELECT ... FROM table WHERE condition;
-- Basic WHERE
SELECT title, rating FROM film WHERE rating = 'PG';
