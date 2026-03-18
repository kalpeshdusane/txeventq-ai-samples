
-- For SVM Model trained inside oracle DB
BEGIN
  dbms_aqadm.add_subscriber(
      queue_name => 'transaction_queue',
      subscriber =>  sys.aq$_agent('FRAUD_SVM', NULL, NULL),
      rule => 'PREDICTION(SVM_MODEL USING tab.USER_DATA.EVENT_HOUR, tab.USER_DATA.OPERATION, tab.USER_DATA.DB_USER, tab.USER_DATA.MACHINE_NAME) = 0');
END;
/

-- For detecting fraud using isolation forest imported from ONNX model
BEGIN
  dbms_aqadm.add_subscriber(
      queue_name => 'transaction_queue',
      subscriber =>  sys.aq$_agent('FRAUD_ISOLATION_FOREST', NULL, NULL),
      rule => 'PREDICTION(ISOLATION_FOREST_MODEL USING tab.USER_DATA.EVENT_HOUR, tab.USER_DATA.OPERATION, tab.USER_DATA.DB_USER, tab.USER_DATA.MACHINE_NAME) = -1');
END;
/

-- Normal Subscriber
BEGIN
  dbms_aqadm.add_subscriber(
      queue_name => 'transaction_queue',
      subscriber =>  sys.aq$_agent('NORMAL_SUB', NULL, NULL),
      rule => 'PREDICTION(ISOLATION_FOREST_MODEL USING tab.USER_DATA.EVENT_HOUR, tab.USER_DATA.OPERATION, tab.USER_DATA.DB_USER, tab.USER_DATA.MACHINE_NAME) = 1');
END;
/