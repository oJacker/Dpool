--ת������

DECLARE
V_NUM NUMBER ;
V_DATE DATE ;

V_CHAR1 VARCHAR2(200);
V_CHAR2 VARCHAR2(200);

BEGIN
    V_NUM :='111' ; --�����ڸ�ֵ�׶ε�����ת�� �ַ�������ֵ
    
    DBMS_OUTPUT.put_line(V_NUM) ;
    V_DATE :='12-MAY-12' ;  --�����ڸ�ֵ�׶ε�����ת�� �ַ���������
    DBMS_OUTPUT.put_line(V_NUM);
    V_CHAR1 :=1;  --�����ڸ�ֵ�׶ε�����ת�� ��ֵ���ַ���
    DBMS_OUTPUT.put_line(V_CHAR1);
    V_CHAR2 :=SYSDATE;   --�����ڸ�ֵ�׶ε�����ת�� ���ڵ��ַ���
    DBMS_OUTPUT.put_line(V_CHAR2);
    
END ;
/

select 2*'3' from dual; --�ַ���ת��Ϊ���ֲ�������������
select add_months('12-3��-12',3) from dual ;  --�ַ���ת��Ϊ���ڲ�������������

-- ��ʾ����ת��ʱ��ת�ַ���
select sysdate,to_char(sysdate,'YYYY-MM-DD hh24:Mi-ss') from dual;

--�ַ���ת������
select '2018-03-02 10:19:32', to_date('2018-03-02 10:19-32','YYYY-MM-DD hh24:Mi:ss') from dual;

--��ֵת���ַ�������
select 123456789,to_char(123456789,'999,999,999,999'),to_char(123456789,'099,999,999,999'),
LENGTH(to_char(123456789,'099,999,999,999')),
LENGTH(trim(to_char(123456789,'099,999,999,999')))
from dual;
--�ַ���ת��ֵ
select to_number('123,456,789','999,999,999,999') from dual;



