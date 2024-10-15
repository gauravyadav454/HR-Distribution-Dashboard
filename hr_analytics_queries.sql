create database projects;

use projects;

select birthdate from hr;

-- data cleaning rename id column

alter table hr 
change column ï»¿id emp_id varchar(20) null;
select emp_id from hr;
-- check datatype using describe commnad

describe hr;

-- changing format of birthdate

update hr 
set birthdate = case
when birthdate like '%/%' then date_format(str_to_date(birthdate, '%m/%d/%Y'),'%Y-%m-%d')
when birthdate like '%-%' then date_format(str_to_date(birthdate, '%m-%d-%Y'),'%Y-%m-%d')
else null
end;

select birthdate from hr;

-- change datatype of birthdate

alter table hr
modify column birthdate date;

desc hr;

-- likewise birthdate hire_date have to format 
select hire_date from hr;


update hr 
set hire_date = case
when hire_date like '%/%' then date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
when hire_date like '%-%' then date_format(str_to_date(hire_date, '%m-%d-%Y'),'%Y-%m-%d')
else null
end;

-- changing the datatype of hiredate to date 

alter table hr 
modify column hire_date date;

-- termdate format and datatype change

update hr
set termdate = date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'))
where termdate is not null and termdate != '';

SET SQL_MODE = '';


select termdate from hr;

alter table hr
modify column termdate date;

-- adding column age using birthdate and year function

select * from hr;

alter table hr
add column age int;

update hr
set age = timestampdiff(year, birthdate, curdate());

select birthdate ,age from hr;


-- removing outliars 

select min(age) as youngest,
max(age)as oldest from hr;

select count(*) from hr where age<18;



-- Questions:

-- 1. what is the gender breakdown of employees in the companies?

select gender,count(*) as count 
from hr
where age >= 18 and termdate = '00-00-0000'
group by gender;

select termdate from hr;

-- 2.what is the race/ethinicity breakdown of employess in the company?

select race, count(*) as count
from hr
where age >= 18 and termdate = '00-00-0000'
group by race
order by count(*) desc;
-- 3. what is the age distribution of employees in the company?

select 
min(age) as youngest,
max(age) as oldest
from hr
where age>=18 and termdate = '00-00-0000';

select 
case
when age >= 18 and age<= 24 then '18-24'
when age >= 25 and age<= 34 then '25-34'
when age >= 35 and age<= 44 then '35-44'
when age >= 45 and age<= 54 then '45-54'
when age >= 55 and age<= 64 then '55-64'
else '65+'
end as Age_group,
count(*) as count
from hr
where age>= 18 and termdate = '00-00-0000'
group by Age_group
order by Age_group;

select 
case
when age >= 18 and age<= 24 then '18-24'
when age >= 25 and age<= 34 then '25-34'
when age >= 35 and age<= 44 then '35-44'
when age >= 45 and age<= 54 then '45-54'
when age >= 55 and age<= 64 then '55-64'
else '65+'
end as Age_group,gender,
count(*) as count
from hr
where age>= 18 and termdate = '00-00-0000'
group by Age_group,gender
order by Age_group , gender;

-- 4. How many employees work at headquarters versus remote locations?

select location ,count(*) as count from hr
where age >= 18 and termdate = '00-00-0000'
group by location;

-- 5. What is the average length of employement for employees who have been terminated?
select
round(avg(datediff(termdate, hire_date))/365,0) as avg_length_employement
from hr
where termdate  <= curdate() and termdate <> '00-00-0000' and age >= 18;

-- 6. How does the gender distribution vary across departments and job titles?

select department ,gender, count(*) as count from hr
where age>= 18 and termdate = '00-00-0000'
group by department , gender 
order by department;

-- 7. what is the distribution of job titles across the company?

select jobtitle , count(*) as count from hr
where age>= 18 and termdate = '00-00-0000'
group by jobtitle
order by jobtitle desc;

-- 8. which department has the highest trunover rate?

select department ,
total_count,
terminated_count,
terminated_count / total_count as termination_rate
from ( 
select department
,count(*) as total_count,
sum(case when termdate <> '00-00-0000' and termdate <= curdate() then 1 else 0 end) as terminated_count
from hr
where age>= 18
group by department
) as subquery
order by termination_rate desc;

-- 9. What is the distribution of employees across locations by city and state?

select location_state , count(*) as count
from hr
where age >= 18 and termdate = '00-00-0000'
group by location_state
order by count desc;


select
year,
hires,
terminations,
hires - terminations as net_change,
round((hires - terminations) / hires * 100 ,2) as net_change_percent
from(
select
Year(hire_date) as year,
count(*) as hires
, sum(case when termdate <> '00-00-0000' and termdate <= curdate() then 1 else 0 end) as terminations
from hr
where age >= 18 
group by year(hire_date)
)as subquery
order by year asc;

-- 11. what is the tenure distributeion for each department?

select department ,round(avg(datediff(termdate, hire_date)/365),0) as avg_tenure
from hr
where termdate <= curdate() and termdate <> '00-00-0000' and age >= 18
group by department;


Select Department from hr;

select year(termdate) , count(emp_id) as count from hr 
where termdate <= curdate() and termdate <> '00-00-0000' and age >= 18
group by year(termdate)
order by count desc;

select distinct count(emp_id) from hr;

select location_state , count(*) from hr
group by location_state 
order by count(*) desc;

select department ,count(*) as count from hr
group by department 
order by count desc;

select location_city ,count(*) as count from hr
group by location_city 
order by count desc;


