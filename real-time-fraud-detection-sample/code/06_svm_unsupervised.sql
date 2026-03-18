drop table svm_settings;

CREATE TABLE svm_settings (
   setting_name  VARCHAR2(30),
   setting_value VARCHAR2(4000)
);

-- Insert algorithm and parameters
INSERT INTO svm_settings VALUES ('ALGO_NAME', 'ALGO_SUPPORT_VECTOR_MACHINES');
INSERT INTO svm_settings VALUES ('PREP_AUTO', 'ON');
INSERT INTO svm_settings VALUES ('SVMS_KERNEL_FUNCTION', 'SVMS_GAUSSIAN');

exec DBMS_DATA_MINING.DROP_MODEL('SVM_MODEL');

BEGIN
  DBMS_DATA_MINING.CREATE_MODEL(
    model_name          => 'SVM_MODEL',
    mining_function     => dbms_data_mining.classification,
    data_table_name     => 'train_data',   -- your training table
    case_id_column_name => 'ID',           -- PK/unique column
    target_column_name  => NULL,
    settings_table_name => 'svm_settings'
  );
END;
/

-- To see how many outliers are detected in train_data
SELECT count(*)
FROM train_data ad
where PREDICTION(SVM_MODEL USING ad.EVENT_HOUR, ad.OPERATION, ad.DB_USER, ad.MACHINE_NAME) = 0;

-- To see how many records are normal in train_data
SELECT count(*)
FROM train_data ad
where PREDICTION(SVM_MODEL USING ad.EVENT_HOUR, ad.OPERATION, ad.DB_USER, ad.MACHINE_NAME) = 1;
