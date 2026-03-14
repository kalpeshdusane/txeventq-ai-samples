set echo on
set serveroutput on

CREATE TABLE svm_settings (
   setting_name  VARCHAR2(30),
   setting_value VARCHAR2(4000)
);

-- Insert algorithm and parameters
INSERT INTO svm_settings VALUES ('ALGO_NAME', 'ALGO_SUPPORT_VECTOR_MACHINES');
INSERT INTO svm_settings VALUES ('PREP_AUTO', 'ON');

INSERT INTO svm_settings VALUES ('SVMS_KERNEL_FUNCTION', 'SVMS_LINEAR');
-- low data set
INSERT INTO svm_settings VALUES ('SVMS_SOLVER', 'SVMS_SOLVER_IPM');

commit;

exec DBMS_DATA_MINING.DROP_MODEL('CHEST_CLASSIFIER');

BEGIN
  DBMS_DATA_MINING.CREATE_MODEL(
    model_name          => 'CHEST_CLASSIFIER',
    mining_function     => dbms_data_mining.classification,
    data_table_name     => 'chest_train',
    case_id_column_name => 'id',
    target_column_name  => 'label',
    settings_table_name => 'svm_settings'
  );  
END;
/

exec DBMS_DATA_MINING.DROP_MODEL('BRAIN_CLASSIFIER');

BEGIN
  DBMS_DATA_MINING.CREATE_MODEL(
    model_name          => 'BRAIN_CLASSIFIER',
    mining_function     => dbms_data_mining.classification,
    data_table_name     => 'brain_train',
    case_id_column_name => 'id',
    target_column_name  => 'label',
    settings_table_name => 'svm_settings'
  );
END;
/
