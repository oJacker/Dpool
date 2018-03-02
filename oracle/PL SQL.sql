--https://docs.oracle.com/cd/E11882_01/appdev.112/e25519/toc.htm
/*
BLOCK
[DECLARE]

BEGIN

[EXCEPTION]
END

FUNCTION PROCEDURE TRIGGER


*/

-- 脚本
SET SERVEROUTPUT ON
declare
v_char varchar2(200) ;
BEGIN
    v_char :='Hello world';
    DBMS_OUTPUT.put_line(v_char);
END ;
/

/*
index idx
function func
procedure proc
view vw
*/

declare
v_max_sal emp.sal%type;
begin
    select max(sal) into v_max_sal from emp;
    dbms_output.put_line(v_max_sal);
end;
/


<<parent>>
declare
v1 number :=1;
begin
    dbms_output.put_line(v1);
    <<child1>>
    declare
        v1 number :=2;
    begin
         dbms_output.put_line(v1);
         dbms_output.put_line(parent.v1);
    end;
    <<child2>>
    declare
        v1 number :=3;
    begin
        dbms_output.put_line(v1);
        dbms_output.put_line('000'||parent.v1);
    end;
end;
/
--展现当前用户下所有表的行数
declare
v_cnt number;
begin
    for r in (select * from user_tables)
    loop
        execute immediate 'select count(*) from ' || r.table_name into v_cnt ;
        dbms_output.put_line(r.table_name ||' has ' || v_cnt || ' rows');
    end loop ;
end;
/







