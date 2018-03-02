--转换函数

DECLARE
V_NUM NUMBER ;
V_DATE DATE ;

V_CHAR1 VARCHAR2(200);
V_CHAR2 VARCHAR2(200);

BEGIN
    V_NUM :='111' ; --发生在赋值阶段的类型转换 字符串到数值
    
    DBMS_OUTPUT.put_line(V_NUM) ;
    V_DATE :='12-MAY-12' ;  --发生在赋值阶段的类型转换 字符串到日期
    DBMS_OUTPUT.put_line(V_NUM);
    V_CHAR1 :=1;  --发生在赋值阶段的类型转换 数值到字符串
    DBMS_OUTPUT.put_line(V_CHAR1);
    V_CHAR2 :=SYSDATE;   --发生在赋值阶段的类型转换 日期到字符串
    DBMS_OUTPUT.put_line(V_CHAR2);
    
END ;
/

select 2*'3' from dual; --字符串转换为数字参数与算数运算
select add_months('12-3月-12',3) from dual ;  --字符串转换为日期并参与日期运算

-- 显示类型转换时间转字符串
select sysdate,to_char(sysdate,'YYYY-MM-DD hh24:Mi-ss') from dual;

--字符串转成日期
select '2018-03-02 10:19:32', to_date('2018-03-02 10:19-32','YYYY-MM-DD hh24:Mi:ss') from dual;

--数值转成字符串够长
select 123456789,to_char(123456789,'999,999,999,999'),to_char(123456789,'099,999,999,999'),
LENGTH(to_char(123456789,'099,999,999,999')),
LENGTH(trim(to_char(123456789,'099,999,999,999')))
from dual;
--字符串转数值
select to_number('123,456,789','999,999,999,999') from dual;



