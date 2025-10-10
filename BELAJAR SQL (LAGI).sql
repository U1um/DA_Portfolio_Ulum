#where clause, memberikan output dengan kondisi yang spesifik
#bisa memakai =, =!, >, <, >=, <= untuk tanda lebih dari/kurang dari biasa digunakan untuk interger/date.
#where clause bisa menggunakan logical operator (AND, OR, NOT) jadi bisa menggunakan 2 atau lebih parameter.
#contoh penggunaan logical operator

select * 
from parks_and_recreation.employee_demographics
where first_name ='Tom' and age = 36;

select * 
from parks_and_recreation.employee_demographics
where (first_name ='Tom' and age = 36) or age > 40;

#Like statement digunakan untuk mencari data dengan pattern yang spesifik 
#ada dua karakter spesial yang bisa digunakan "% dan _" % berarti apapun dan _ untuk value yang spesifik
select * 
from parks_and_recreation.employee_demographics
where first_name like 'a%'; # query hanya fokus mencari yang berawalan huruf a apapun akhiranya

select * 
from parks_and_recreation.employee_demographics
where first_name like 'a___'; #dengan 4 "_" dibelakang a maka query secara spesifik mencari yang awalan a dan di ikuti 4 suku kata

#group by, digunakan untuk melakukan grouping untuk menghitung menggunakan aggregate function seperti (MAX, MIN, AVG, COUNT)
select gender,avg(age),max(age),min(age),count(first_name)
from parks_and_recreation.employee_demographics
group by gender;

#order by, akan melakukan sorting entah itu ascending(naik/kecil ke besar) / descending(turun/besar ke kecil)
#bisa menggunakan 2 parameter dan berbeda ascending/descending
#tips untuk order by usahakan yang depan yang memiliki unique value sedikit / yang paling tidak beragam
select *
from parks_and_recreation.employee_demographics
order by gender asc, age desc;

#Having clause, sama dengan where bedanya having digunakan untuk memfilter aggregating function, jadi terletak dibawah group by
#sedangkan where letaknya diatas group by jadi tidak bisa memfilter karena secara urutan query di eksekusi dari yang paling awal
select gender, avg(age)
from parks_and_recreation.employee_demographics
group by gender
having avg(age)>40;

select occupation, avg(salary)
from parks_and_recreation.employee_salary
where occupation like '%manager%'
group by occupation
having avg(salary)>65000;

#limit menampilkan jumlah baris yang akan di keluarkan bisa digunakan untuk mencari top 3
select *
from parks_and_recreation.employee_salary
order by salary desc
limit 3; 

#limit juga bisa menampilkan baris spesifik(contoh jika memunculkan baris ketiga limit 2,1 "tampilkan 1 baris setelah baris ke dua")
select *
from parks_and_recreation.employee_salary
order by salary desc
limit 2,1; 

#JOIN (Inner, Outer, Self) menggabungkan 2 kolom
#Inner join return row yang sama di kedua tabel
#Outer join ada left(mengambil semua di kiri dan mengambil yang match di kanan) dan (right join sebaliknya left join)
#Self join menggabungkan tabel yang sama

Select ed.employee_id, ed.first_name, ed.age, es.occupation, es.salary
from parks_and_recreation.employee_demographics as ed
inner join parks_and_recreation.employee_salary as es
on ed.employee_id=es.employee_id;

Select *
from parks_and_recreation.employee_demographics as ed
right join parks_and_recreation.employee_salary as es
on ed.employee_id=es.employee_id;

Select es1.employee_id as santa_id,
es1.first_name as santa_name,
es2.employee_id as emp_id,
es2.first_name as emp_name
from parks_and_recreation.employee_salary as es1
join parks_and_recreation.employee_salary as es2
on es1.employee_id+1=es2.employee_id;

#join multiple table
Select *
from parks_and_recreation.employee_demographics as ed
join parks_and_recreation.employee_salary as es
on ed.employee_id=es.employee_id
join parks_and_recreation.parks_departments as pd
on es.dept_id=pd.department_id;

#union menggabungkan baris dari 2 table, menggunakan 2 select statement
#by default union distinct jadi hanya menampilkan unique values

select first_name,last_name,'old man' as label
from parks_and_recreation.employee_demographics
where age > 40 and gender='Male'
union
select first_name,last_name,'old lady' as label
from parks_and_recreation.employee_demographics
where age > 40 and gender ='Female'
union
select first_name,last_name,'highly paid' as label
from parks_and_recreation.employee_salary
where salary > 70000
order by first_name, last_name;

#string function (locate, substitute, concat, right, left, upper, lower, ect)

#case statement
select first_name,age,
case when age <=30 then 'young'
when age between 31 and 50 then 'old'
when age >=51 then 'kate mati'
end as age_bracket
from employee_demographics;

select first_name, last_name, salary,department_name,
case
when salary <= 50000 then (salary*0.05)
when salary > 50000 then (salary*0.07)
when department_name ='Finance' then (salary*0.10)
end as bonuses
from employee_salary as es
join parks_departments as pd
on es.dept_id=pd.department_id
;

#subquery
select *
from employee_demographics
where employee_id in 
(select employee_id
from employee_salary where dept_id=1);

select first_name, last_name, salary,
(select avg(salary) from employee_salary) as avg_salary
from employee_salary;

select avg(max_age) from
(select gender, avg(age) as avg_age, max(age) as max_age,min(age) as min_age,count(age) as count_age
from employee_demographics
group by gender) as agg_table;

#temp tables membuat tabel sementara untuk mempermudah memproses data
#tabel akan tetap bisa di akses di query baru asalkan aplikasinya tidak dikeluarkan
create temporary table salary_over_50k
select *
from employee_salary
where salary >= 50000;

select * from salary_over_50k;

#stored procedure berfungsi untuk menyimpan query dan bisa diakses kapanpun
create procedure large_salary()
select *
from emplolarge_salaryyee_salary
where salary>=50000;

call large_salary2();

delimiter $$
create procedure large_salary2()
begin
select *
from employee_salary
where salary>=50000;
select *
from employee_salary
where salary>=10000;
end $$
delimiter ;

call new_procedure();

#trigger and event

delimiter $$
create trigger employee_insert3
after insert on employee_salary
for each row
begin
insert into employee_demographics (employee_id, first_name, last_name)
values(new.employee_id, new.first_name, new.last_name);
end $$
delimiter ;
select * from employee_demographics where employee_id=13;

insert into employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
values (800,'bahrul','ulummudin','Head of analyst','1000000',NULL);



