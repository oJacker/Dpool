--����
--https://docs.oracle.com/cd/E11882_01/server.112/e41084/functions.htm#SQLRF006

--���ֺ���
--abs
select abs(15),abs(-15) from dual;

--ceil ����ȡ�� �ҵ�һ����С�Ĵ��ڵ��ڵ�ǰֵ������
select ceil(1.1),ceil(-1.1),ceil(2)from dual;

--floor ����ȡ�� �ҵ�һ������С�ڵ��ڵ�ǰֵ������

select floor(1.1),floor(-1.1),floor(2) from dual;

--mod ȡ����
select mod(1,3),mod(2,3),mod(3,3),mod(4,3),mod(5,3) from dual;

--power�˷�����
select power(2,3)from dual;


-- Round(number) ����
select round(123.456),round(123.456,2),round(123.456,-2) from dual;

-- trunc(number)��ȡ����

select trunc(123.456),trunc(123.456,2),trunc(123.456,-2) from dual;

-- sign ����>0���� 1������=0����0������<0����-1

select sign(1232131),sign(0),sign(-99999999999) from dual;

--sqrt ȥƽ����
select sqrt(4),sqrt(9) from dual;

--   ��ֵ����

--  �ַ������Ӻ���
select concat(concat('a','b'),'c'),'a'||'b'||'c' from dual;

--��Сд����
--initcap ����ĸ��д
--lower ȫ��Сд
--upper ȫ����д
select initcap('abC'),lower('abC'),upper('abC') from dual;

-- ע�⣺oracle�����ֵ���Ĭ�ϵĶ��Ǵ�д
select * from user_tables where upper(table_name)=upper('emp');
--lpad,rpad �ַ�������
--��һ������Ҫ���в�����ַ���
--�ڶ���������ָ�ַ������ĳ���
--����������ָ�����λ����ʲô�ַ��������
select lpad('1',10,'0'),rpad('1',10,'0') from dual;

--trim,ltrim,rtrim ȥ��ĳ���ַ��� Ĭ����ȥ���ո�
select trim('  AAAAAAAAAAABBBBBBBBCCCCCCC  '),ltrim('  AAAAAAAAAAABBBBBBBBCCCCCCC  ','A'),
rtrim('  AAAAAAAAAAABBBBBBBBCCCCCCC  ')
from dual;

select ltrim('  AAAAAAAAAAABBBBBBBBCCCCCCC  ','C'),
rtrim('  AAAAAAAAAAABBBBBBBBCCCCCCC  ','B') from dual;

--SUBSTR
--Ҫ���ĸ��ַ������н�ȡ
--�ӵڼ����ַ�����ʼ��ȡ
--Ҫ��ȡ�����ַ���
select SUBSTR('ABCDEFG',3,4) from dual;

--instr
--��һ������ Ҫ���ĸ��ַ����в���
--�ڶ������� Ҫ�����ĸ��ַ���
--���������� �ӵڼ����ַ���ʼ����
--���ĸ����� ������ڼ��γ���
select INSTRB('abcabcabcabcabcabcabcabcd','a',1,1),
INSTRB('abcabcabcabcabcabcabcabcd','a',2,1),
INSTRB('abcabcabcabcabcabcabcabcd','a',2,2)
from dual;




--���ں���
--current_date,sysdate,systimestamp 
--��С����ԭ��
select current_date,sysdate,SYSTIMESTAMP from dual;

--ʱ����ѧ���� ע�⣺��ʱ�����͵���ѧ���㵥λ����
select sysdate,sysdate+1,sysdate+10/24,sysdate+10/24/60,sysdate + 10/24/60/60,sysdate from dual;

--last_day ���صı������һ��
select last_day(sysdate) from dual;

--next_day �����뵱ǰ�����������һ���ܼ�
--next_day �����뵱ǰ�����������һ���ܼ���ע������ÿ�ܵĵ�һ�������գ������
select next_day(sysdate,5),sysdate from dual;

--MONTHS_BETWEEN
select MONTHS_BETWEEN(sysdate,sysdate+1000) from dual;
select MONTHS_BETWEEN(sysdate+1000,sysdate) from dual;

--add_months
select add_months(sysdate,4) from dual;
       















