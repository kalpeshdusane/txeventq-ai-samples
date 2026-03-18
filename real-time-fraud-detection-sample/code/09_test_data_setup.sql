drop table test_data;

-- Only putting columns which are useful for training
create table test_data(
  TRANSACTION_ID NUMBER,
  EVENT_HOUR     NUMBER,
  OPERATION      VARCHAR(10),
  DB_USER        VARCHAR(50),
  MACHINE_NAME   VARCHAR(50),
  SESSION_NUM    NUMBER,
  IS_ANOMALY     NUMBER
);