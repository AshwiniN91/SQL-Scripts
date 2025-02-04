-- used to describe the structure of the table
desc harriscourt.student_details_dummy;

-- alter: change the structure of the table
alter table harriscourt.student_details_dummy 
change column enrollment_date  enrollment_date timestamp not null;

alter table harriscourt.student_details 
modify batch_date timestamp;

-- update used to change records in a table
select * from harriscourt.student_details_dummy;
update harriscourt.student_details_dummy
set enrollment_date = str_to_date(enrollment_date, '%m/%d/%Y %h:%i %p');

update harriscourt.student_details_dummy
set batch_date = str_to_date(batch_date, '%m/%d/%Y');

SET SQL_SAFE_UPDATES = 0; 

alter table harriscourt.student_details_dummy
add column selected_course int not null default 1;

update harriscourt.student_details_dummy
set selected_course=3 where student_fname = 'shikar';

-- Insert to insert records in a table
INSERT INTO harriscourt.student_details_dummy 
(student_id, enrollment_date, student_fname, student_mname, student_lname, student_email, years_of_exp, student_company, batch_date, source_of_joining, location) 
VALUES 
(NULL, '2022-01-25 00:45:51', 'rohit', NULL, 'sharma', 'rohit@gmail.com', 6, 'walmart', '2021-02-05', 'bangalore', 'location_value_here');

-- Distinct: Unique records, order by: order data based on relevant column
select distinct source_of_joining 
from harriscourt.student_details_dummy 
order by enrollment_date desc;


Select course_id, course_name, course_fee,
CASE
	When course_duration_months > 4 THEN "MASTERS"
                 ELSE "diploma"
END as course_type
FROM harriscourt.course_details;

-- Case statement: creating column based on multiple filters in a column of a table
select student_id, student_fname, student_lname, student_company,
case 
	when student_company in ("Flipkart","Walmart","microsoft") then "Product Based"
    when student_company is null then "Invalid company"
    else "Service Based"
    end as company_type
from harriscourt.student_details_dummy;

-- Group up: Aggregate data based on column, having: filter records on the aggregated data
select source_of_joining, count(*) as no_candidates
from harriscourt.student_details_dummy
group by source_of_joining
having count(*) > 1;

-- Where condition cannot be applied on aggregated data
select source_of_joining, count(*) as total_registered
from harriscourt.student_details_dummy
where source_of_joining = 'linkedin'
group by source_of_joining;

-- Where: filter on non-aggregated data, having: filter on aggregated data
select location
from harriscourt.student_details_dummy
where years_of_exp > 5
group by location
having count(*) > 1;

/* Group by */
select location, count(location) as loc_count, avg(salary) as average_salary
from harriscourt.employee
group by location;

/* Along with location need name details along with average salary*/
select e.first_name, e.last_name, temp.location, temp.tot_count, temp.average_salary   
from harriscourt.employee as e join (select location, count(location) as tot_count, avg(salary) as average_salary
from harriscourt.employee 
group by location) temp
on e.location = temp.location;

-- over(partition by) : used to group non-aggregated data like first_name, last_name
select first_name, last_name, location,
count(location) over(partition by location) as total,
avg(salary) over(partition by location) as average_sal
from harriscourt.employee;

/* row number in sql*/
select * from (select first_name, last_name, salary,
row_number() over(order by salary desc) as row_no
from harriscourt.employee) as temp
where row_no = 5;

select first_name, last_name, salary, location,
row_number() over(partition by location order by salary desc) as row_no
from harriscourt.employee;

/* Highest salary getters for each location*/
select * from (select first_name, last_name, salary,
row_number() over(partition by location order by salary desc) as row_no
from harriscourt.employee) as temp
where row_no = 1;

select * from harriscourt.employee;

select first_name, last_name, salary, location,
rank() over(partition by location order by salary desc) as rank_no
from harriscourt.employee;

/* Row number */
select first_name, last_name, salary,
row_number() over(order by salary desc) as row_no
from harriscourt.employee;

/* Rank*/
select first_name, last_name, salary,
rank() over(order by salary desc) as rank_no
from harriscourt.employee;

/* Dense Rank*/
select first_name, last_name, salary,
dense_rank() over(order by salary desc) as dense_rank_no
from harriscourt.employee;