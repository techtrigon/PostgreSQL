-- Active: 1701951619922@@127.0.0.1@5432@main4

-- CREATE DATABASE IF NOT EXISTS temp;

-- USE temp

DROP TABLE IF EXISTS car, person;

-- table creation

CREATE TABLE
    IF NOT EXISTS person(
        id INT PRIMARY KEY,
        NAME VARCHAR,
        city VARCHAR,
        age FLOAT
    );

CREATE TABLE
    IF NOT EXISTS car(
        id INT,
        NAME VARCHAR NOT NULL,
        price FLOAT DEFAULT 25000,
        ENGINE INT DEFAULT 6,
        LENGTH INT DEFAULT 1000,
        city VARCHAR,
        PRIMARY KEY (id),
        UNIQUE (id, NAME),
        CHECK(
            price > 12000
            AND ENGINE >= 3
        ) -- when certain columns are needed together to make primary key/unique/notnull and some customm constraints
    );

-- bulk inserting into person

INSERT INTO
    person (id, NAME, city)
VALUES (1, 'Dev', 'Delhi'), (2, 'Sam', 'Punjab'), (3, 'Riddhi', 'UP'), (4, 'Rishabh', 'Delhi'), (5, 'Shiva', 'Delhi'), (6, 'Parv', 'UP');

-- bulk inserting into car

INSERT INTO car
VALUES (
        1,
        'Verna',
        20300,
        4,
        1200,
        'Delhi'
    ), (2, 'i20', 16003, 3, 900, 'UP'), (
        3,
        'Scorpio',
        40000,
        5,
        1300,
        'Punjab'
    ), (
        4,
        'Ferrari',
        15003,
        7,
        1200,
        'Delhi'
    );

-- (6, 'i20', 5003);

-- bulk inserting into car by some columns

INSERT INTO
    car (id, NAME, city)
VALUES (5, 'Bugatti', 'Punjab'), (6, 'Ford', 'MP');

-- selecting all

SELECT * FROM person;

SELECT * FROM car ORDER BY price;

SELECT
    city,
    SUM(price) total_price
FROM car
GROUP BY city
ORDER BY total_price;

SELECT DISTINCT ON (city) * FROM car;

SELECT *
FROM car
WHERE NOT city = 'Punjab'
GROUP BY id
HAVING ENGINE >= 3
ORDER BY price DESC
LIMIT 5
OFFSET 0;

UPDATE car SET LENGTH = 1600 WHERE NAME = 'Scorpio';

UPDATE car SET LENGTH = 1300 WHERE NAME = 'Ford';

SELECT * FROM car;

-- !--------------------------------------------------------> teacher and dept

CREATE TABLE dept( id INT PRIMARY KEY, NAME VARCHAR(50) );

DROP TABLE IF EXISTS teacher;

CREATE TABLE
    teacher(
        id INT PRIMARY KEY,
        NAME VARCHAR(50),
        dept_id INT,
        FOREIGN KEY (dept_id) REFERENCES dept(id) ON UPDATE CASCADE
    );

INSERT INTO dept
VALUES (1, 'Maths'), (2, 'Physics'), (3, 'Chemistry'), (4, 'Biology');

INSERT INTO teacher
VALUES (1, 'Dev', 1), (2, 'Sam', 3), (3, 'Riddhi', 1), (4, 'Betu', 1), (5, 'Rishabh', 4), (6, 'Lokendra', 3);

UPDATE dept SET id = 5 WHERE id = 1;

SELECT * FROM dept;

ALTER TABLE teacher ADD COLUMN age INT DEFAULT 24;

ALTER TABLE teacher ALTER COLUMN age TYPE FLOAT;

SELECT * FROM teacher;

SELECT (NAME || ' ' || age) name_age FROM teacher;

SELECT * FROM teacher WHERE NAME NOT LIKE '%a%';

SELECT
    teacher.id,
    teacher.name teacher_name,
    dept.name dept_name
FROM teacher
    INNER JOIN dept ON teacher.id = dept.id;

SELECT NAME FROM teacher UNION SELECT NAME FROM dept;

SELECT * FROM person;

SELECT *
FROM car
WHERE EXISTS(
        SELECT id
        FROM person
        WHERE city = car.city
    );

SELECT * FROM car;

SELECT *
FROM car
WHERE city IN (
        SELECT city
        FROM person
    );

ALTER TABLE car ALTER COLUMN ENGINE TYPE SMALLINT;

ALTER TABLE car ADD CHECK (ENGINE < 10);

DROP TABLE Employee;

CREATE TABLE IF NOT EXISTS Employee (id INT, salary INT);

INSERT INTO
    Employee (id, salary)
VALUES ('1', '100'), ('2', '200'), ('3', '300');

SELECT COALESCE( (
            SELECT
                DISTINCT salary
            FROM Employee
            ORDER BY
                salary DESC
            LIMIT 1
            OFFSET
                1
        )
    ) SecondHighestSalary;

SELECT CAST(salary AS TEXT) FROM Employee

CREATE TABLE
    employees (
        employee_id SERIAL PRIMARY KEY,
        employee_name VARCHAR(100),
        salary NUMERIC(10, 2)
    );

INSERT INTO
    employees (employee_name, salary)
VALUES ('Alice', 60000.00), ('Bob', 35000.00), ('Charlie', 25000.00), ('David', 80000.00);

SELECT * FROM employees;

SELECT
    employee_name,
    salary,
    CASE
        WHEN salary > 50000.00 THEN 'High Salary'
        WHEN salary > 30000.00 THEN 'Medium Salary'
        ELSE 'Low Salary'
    END AS salary_category
FROM employees;

--------------------------------------------------------------->  USERS & USERPROFILE

CREATE TABLE
    users (
        user_id SERIAL PRIMARY KEY,
        username VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL
    );

CREATE TABLE
    user_profiles (
        profile_id SERIAL PRIMARY KEY,
        user_id INT NOT NULL REFERENCES users(user_id),
        username VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL
    );

CREATE OR REPLACE FUNCTION CREATE_USER_PROFILE() RETURNS 
TRIGGER AS $CUP$ 
	$CUP$ $CUP$ $CUP$ $CUP$ BEGIN
	INSERT INTO
	    user_profiles (user_id, username, email)
	VALUES (
	        NEW.user_id,
	        NEW.username,
	        NEW.email
	    );


RETURN NEW;

END;

$CUP$ LANGUAGE plpgsql;

-- drop Table users,user_profiles

CREATE TRIGGER CUP 
	CUP CUP CUP CUP AFTER
	INSERT ON users FOR EACH ROW
	EXECUTE
	    FUNCTION create_user_profile();


INSERT INTO
    users (username, email)
VALUES (
        'john_doe',
        'john@example.com'
    ), (
        'john_doe1',
        'john@example.com'
    );

SELECT * FROM user_profiles;

INSERT INTO users (username, email) VALUES('Dev', '1');

-- After this insertion, the trigger will automatically create a corresponding row in the user_profiles table.
