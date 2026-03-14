CREATE USER h_user identified by h_password ;
GRANT connect,resource to h_user;
GRANT alter session to h_user;
-- TxEventQ privileges
GRANT aq_administrator_role to h_user;
GRANT EXECUTE on dbms_aq to h_user;
GRANT EXECUTE on dbms_aqadm to h_user;
GRANT UNLIMITED TABLESPACE TO h_user;
-- Vector and OML privileges
GRANT EXECUTE on DBMS_VECTOR TO h_user;
GRANT CREATE MINING MODEL TO h_user;
GRANT EXECUTE on DBMS_UTILITY TO h_user;
GRANT create ANY DIRECTORY to h_user;
