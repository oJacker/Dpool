/*set  serveroutput on
declare

begin
exception
end;
*/

set serveroutput on
declare
    v_sal number(10);
begin
  select salary into v_sal from EMPLOYEES where EMPLOYEE_ID=100;
  dbms_output.put_line(v_sal);
end;
/


declare
v_sal number(10);
v_email varchar2(20);
v_hire_date date;
begin
select salary,email,hire_date into v_sal,v_email,v_hire_date from employees where employee_id=100;
dbms_output.put_line(v_sal||','||v_email||','||to_char(v_hire_date,'YYYY-MM-DD'));
end;
/


declare 
    v_salary employees.salary%type;
    v_email employees.email%type;
    v_hire_date employees.hire_date%type;
begin
    select salary,email,hire_date into v_salary,v_email,v_hire_date from EMPLOYEES where employee_id=100;
    dbms_output.put_line(v_salary||','||v_email||','||v_hire_date);
end;
/


declare
    type emp_record is record(
             v_sal employees.salary%type,
        v_email employees.email%type,
        v_hire_date employees.hire_date%type
    );
    
    v_emp_record emp_record;
begin
    select salary,email,hire_date into v_emp_record from employees where employee_id =100;
    dbms_output.put_line(v_emp_record.v_sal||','||v_emp_record.v_email||','||v_emp_record.v_hire_date);
end;
/


declare
v_emp_record employees%rowtype;
begin
select * into v_emp_record from employees where employee_id =123;
dbms_output.put_line('employee_id:'||v_emp_record.employee_id||','||'salary:'||v_emp_record.salary);
end;
/

declare 
v_emp_id number(10);
begin
v_emp_id:=123;
update employees
set salary = salary +100
where employee_id = v_emp_id;
dbms_output.put_line('执行成功！~~~');
end;
/

declare
v_sal employees.salary%type;
begin
select salary into v_sal from employees where employee_id=150;
if v_sal >=10000 then dbms_output.put_line('salary>=10000');
elsif v_sal >5000 then dbms_output.put_line('10000 > salary>=5000');
else dbms_output.put_line('salary < 5000');
end if;
dbms_output.put_line('salary:'||v_sal);
end;
/



declare
v_sal employees.salary%type;
v_temp varchar2(20);
begin
    select salary into v_sal from employees where employee_id=130;
    v_temp :=case trunc(v_sal/5000) when 0 then 'salary<5000'
                                    when 1 then '5000<=salary<10000'
                                    else 'salary>=100000'
                                    end;
    dbms_output.put_line('salary:'||v_sal||','||v_temp);
end;
/

declare
    v_job_id employees.job_id%type;
    v_temp varchar2(20);
begin
    select job_id into v_job_id from employees where EMPLOYEE_ID =122;
    v_temp :=
        case v_job_id when 'IT_PROG' then 'A'
                    when 'AC_MGT' then  'B'
                    when 'AC_ACCOUNT' then 'C'
                    else 'D'
                    end;
        dbms_output.put_line('job_id:'||v_job_id||'   '||v_temp);
end;
/


declare
    v_i number(5) :=1;
begin
    loop
        dbms_output.put_line(v_i);
        exit when v_i>=100;
        v_i := v_i + 1;
    end loop;
end;
/

declare
    v_i number(5) :=1;
begin
    while v_i <=100 loop
        dbms_output.put_line(v_i);
        v_i :=v_i +1;
    end loop;
end;
/

begin
    for c in 1..100 loop
        dbms_output.put_line(c);
    end loop;
end;
/

declare 
    v_flag number(1) :=1;
begin
    for v_i in 2..100 loop
        for v_j in 2..sqrt(v_i) loop
            if mod(v_i,v_j) = 0 then v_flag :=0;
            end if;
        end loop;
        if v_flag =1 then dbms_output.put_line(v_i);
        end if;
        v_flag :=1;
    end loop;
end;
/

declare 
    v_flag number(1) :=1;
begin
    for v_i in 2..100 loop
        dbms_output.put_line('v_i='||v_i);
        for v_j in 2..sqrt(v_i) loop
            dbms_output.put_line('v_j='||v_j);
            if mod(v_i,v_j)=0 then v_flag :=0;
                goto label;
            end if;
        end loop;
        <<label>>
        if v_flag =1 then dbms_output.put_line(v_i);
        end if ;
        v_flag :=1;
    end loop;
end;
/


begin
    for i in 1..100 loop
        if i=50 then goto label;
        end if;
        dbms_output.put_line(i);
    end loop;
    <<label>>
    dbms_output.put_line('打印结束');
end;
/



begin 
    for i in 1..100 loop
        if i=50 then dbms_output.put_line('打印结束');
        exit;
        end if;
        dbms_output.put_line(i);
    end loop;
end;
/


--游标
declare
 v_sal employees.salary%type;
 cursor emp_sal_cursor is select salary from employees where department_id=80;
 
begin
 --打开游标
 open emp_sal_cursor;
 --提取游标
 fetch emp_sal_cursor into v_sal;
 while emp_sal_cursor%found loop
     dbms_output.put_line('salary:'||v_sal);
     fetch emp_sal_cursor into v_sal;
 end loop;
 
 close emp_sal_cursor; 
 --关闭游标
end;
/

declare
    v_empid employees.employee_id%type;
    v_lastName employees.last_name%type;
    v_sal employees.salary%type;
    cursor emp_sal_cursor is select employee_id,last_name ,salary from employees where department_id=80;

begin
open emp_sal_cursor;
fetch emp_sal_cursor into v_empid,v_lastName,v_sal;
while emp_sal_cursor%found loop
    dbms_output.put_line('employee_id:'||v_empid||',last_name'||v_lastName||',salary:'||v_sal);
    fetch emp_sal_cursor into v_empid,v_lastName,v_sal;
end loop;
close emp_sal_cursor;
end;
/


declare type emp_record is record(
v_empid employees.employee_id%type,
    v_lastName employees.last_name%type,
    v_sal employees.salary%type
    
);
v_emp_record emp_record;
cursor emp_sal_cursor is select employee_id,last_name ,salary from employees where department_id=80;
begin
    open emp_sal_cursor;
    fetch emp_sal_cursor into v_emp_record;
    while emp_sal_cursor%found loop
    dbms_output.put_line('employee_id:'||v_emp_record.v_empid||',salary'||v_emp_record.v_sal||',lastName'||v_emp_record.v_lastName);
    fetch emp_sal_cursor into v_emp_record;
    end loop;
    close emp_sal_cursor;
end;
/

declare
cursor emp_sal_cursor  is select employee_id,last_name,salary from employees where department_id =80;
begin
for c in emp_sal_cursor loop
    dbms_output.put_line('employee_id:'||c.employee_id||',last_name'||c.last_name||'salary:'||c.salary);
end loop;
end;
/


/*

利用游标，调整公司中员工的工资：
工资范围            调整基数
0 - 5000              5%
5000 - 10000       3%
10000 - 15000     2%
15000 -               1%
*/

declare

v_empid employees.employee_id%type;
v_sal employees.salary%type;
v_temp number(4,2);
cursor emp_cursor is select employee_id,salary from employees;
begin
open emp_cursor;
    fetch emp_cursor into v_empid,v_sal;
    while emp_cursor%found loop
        if v_sal <5000 then v_temp :=0.05;
        elsif v_sal <10000 then v_temp :=0.03;
        elsif v_sal <15000 then v_temp :=0.02;
        else v_temp :=0.01;
        end if;
        
        dbms_output.put_line(v_empid||','||v_sal);
        update employees
        set salary = salary *(1+v_temp)
        where employee_id =v_empid;
        fetch emp_cursor into v_empid,v_sal;
    end loop;
close emp_cursor;
end;
/


declare
 cursor emp_cursor is select EMPLOYEE_ID,SALARY from EMPLOYEES;
 v_temp number(4,2);
begin
   for c in emp_cursor loop
       if c.salary < 5000 then v_temp :=0.05;
       elsif c.salary < 10000 then v_temp :=0.03;
       elsif c.salary < 15000 then v_temp :=0.02;
       else  v_temp :=0.01;
       end if;

       update EMPLOYEES
       set SALARY = SALARY *(1+v_temp)
       where employee_id = c.employee_id;
   end loop;
end;
/

--隐式游标：更新员工salary（涨工资10），如果该员工没有找到，则打印“查无此人”信息：
begin
    update employees
    set salary = salary +10
    where employee_id =1001;
    if sql%notfound then dbms_output.put_line('查无此人');
    end if;
end;
/




--异常  预定义异常

declare
 v_sal employees.salary%type;
begin
select salary into v_sal from employees
where employee_id >100 ;
dbms_output.put_line(v_sal);
exception 
    when too_many_rows then dbms_output.put_line('输出的行数过多');
    when others then dbms_output.put_line('出现其它的异常了');
end;
/








