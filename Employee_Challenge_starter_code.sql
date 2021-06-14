-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)

);

CREATE TABLE dept_manager (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    PRIMARY KEY (emp_no, dept_no)
);



CREATE TABLE salaries (
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no)
);



CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(40) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
	
);



CREATE TABLE dept_emp (
	emp_no INT NOT NULL,	
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),	
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),	
	PRIMARY KEY (emp_no, dept_no));





SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';


SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

 

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';


SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';



-- Total employees:

Select count(emp_no) from employees;




-- Retirement eligibility
SELECT em.emp_no, em.first_name, em.last_name, title, from_date, to_date
INTO retirement_titles
FROM employees as em
JOIN titles as tt
ON em.emp_no = tt.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY em.emp_no;


SELECT * FROM retirement_titles;



-- Use Dictinct with Orderby to remove duplicate rows and create a new table for unique titles
SELECT DISTINCT ON (emp_no) emp_no,first_name, last_name, title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no ASC, to_date DESC;

SELECT * FROM unique_titles;

-- Create a new table for only titles and counts of each title

SELECT count(title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC;

SELECT * FROM retiring_titles;
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


SELECT emp_no, first_name, last_name, birth_date
FROM employees;

SELECT from_date, to_date
FROM dept_emp;

SELECT title
FROM titles;


--Join three tables and create a new mentors table that showing all retiring employees that could also be mentors

SELECT DISTINCT ON(e.emp_no) e.emp_no, e.first_name, e.last_name, e.birth_date, 
de.from_date, de.to_date, tt.title
INTO mentors
FROM employees AS e
INNER JOIN dept_emp AS de
ON e.emp_no = de.emp_no
INNER JOIN titles AS tt
ON e.emp_no = tt.emp_no
WHERE (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (de.to_date = '9999-01-01')
ORDER BY e.emp_no;


SELECT * FROM mentors;



-- Total salaries per year

SELECT CAST(SUM(salary) AS money) AS "Total Salaries"
FROM salaries;


