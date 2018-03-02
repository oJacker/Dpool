--函数
--https://docs.oracle.com/cd/E11882_01/server.112/e41084/functions.htm#SQLRF006

--数字函数
--abs
select abs(15),abs(-15) from dual;

--ceil 向上取整 找到一个最小的大于等于当前值的整数
select ceil(1.1),ceil(-1.1),ceil(2)from dual;

--floor 向下取整 找到一个最大的小于等于当前值的整数

select floor(1.1),floor(-1.1),floor(2) from dual;

--mod 取余数
select mod(1,3),mod(2,3),mod(3,3),mod(4,3),mod(5,3) from dual;

--power乘方函数
select power(2,3)from dual;


-- Round(number) 舍入
select round(123.456),round(123.456,2),round(123.456,-2) from dual;

-- trunc(number)截取函数

select trunc(123.456),trunc(123.456,2),trunc(123.456,-2) from dual;

-- sign 参数>0返回 1，参数=0返回0，参数<0返回-1

select sign(1232131),sign(0),sign(-99999999999) from dual;

--sqrt 去平方根
select sqrt(4),sqrt(9) from dual;

--   数值函数

--  字符串连接函数
select concat(concat('a','b'),'c'),'a'||'b'||'c' from dual;

--大小写函数
--initcap 首字母大写
--lower 全部小写
--upper 全部大写
select initcap('abC'),lower('abC'),upper('abC') from dual;

-- 注意：oracle数据字典中默认的都是大写
select * from user_tables where upper(table_name)=upper('emp');
--lpad,rpad 字符串补足
--第一个参数要进行补足的字符串
--第二个参数是指字符串最后的长度
--第三个参数指不足的位数由什么字符串来填充
select lpad('1',10,'0'),rpad('1',10,'0') from dual;

--trim,ltrim,rtrim 去除某个字符串 默认是去除空格
select trim('  AAAAAAAAAAABBBBBBBBCCCCCCC  '),ltrim('  AAAAAAAAAAABBBBBBBBCCCCCCC  ','A'),
rtrim('  AAAAAAAAAAABBBBBBBBCCCCCCC  ')
from dual;

select ltrim('  AAAAAAAAAAABBBBBBBBCCCCCCC  ','C'),
rtrim('  AAAAAAAAAAABBBBBBBBCCCCCCC  ','B') from dual;

--SUBSTR
--要对哪个字符串进行截取
--从第几个字符串开始截取
--要截取几个字符符
select SUBSTR('ABCDEFG',3,4) from dual;

--instr
--第一个参数 要在哪个字符串中查找
--第二个参数 要查找哪个字符串
--第三个参数 从第几个字符开始查找
--第四个参数 查找其第几次出现
select INSTRB('abcabcabcabcabcabcabcabcd','a',1,1),
INSTRB('abcabcabcabcabcabcabcabcd','a',2,1),
INSTRB('abcabcabcabcabcabcabcabcd','a',2,2)
from dual;




--日期函数
--current_date,sysdate,systimestamp 
--最小适用原则
select current_date,sysdate,SYSTIMESTAMP from dual;

--时间数学计算 注意：对时间类型的数学运算单位是天
select sysdate,sysdate+1,sysdate+10/24,sysdate+10/24/60,sysdate + 10/24/60/60,sysdate from dual;

--last_day 返回的本月最后一天
select last_day(sysdate) from dual;

--next_day 返回离当前日期最近的下一个周几
--next_day 返回离当前日期最近的下一个周几，注意美国每周的第一天是周日，礼拜日
select next_day(sysdate,5),sysdate from dual;

--MONTHS_BETWEEN
select MONTHS_BETWEEN(sysdate,sysdate+1000) from dual;
select MONTHS_BETWEEN(sysdate+1000,sysdate) from dual;

--add_months
select add_months(sysdate,4) from dual;
       















