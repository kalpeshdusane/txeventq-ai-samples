-- Drop any previous users
DROP USER txeventq_user CASCADE;

CREATE USER txeventq_user IDENTIFIED BY txeventq_password; -- that is not the real password! 
GRANT connect, resource to txeventq_user;
GRANT UNLIMITED TABLESPACE TO txeventq_user;
GRANT alter session to txeventq_user;
GRANT create type to txeventq_user;
GRANT aq_administrator_role to txeventq_user;

-- Creating ML model in DB
GRANT CREATE MINING MODEL TO txeventq_user;
-- [optional] for using DBMS_VECTOR.LOAD_ONNX_MODEL to import ONNX model    
GRANT create ANY DIRECTORY to txeventq_user;
-- [optional] for using DBMS_VECTOR.LOAD_ONNX_MODEL to import ONNX model
GRANT execute on DBMS_VECTOR TO txeventq_user;