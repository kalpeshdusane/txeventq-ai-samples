drop table train_data;

-- Only putting columns which are useful for training
create table train_data(
  ID             NUMBER,
  EVENT_HOUR     NUMBER,
  OPERATION      VARCHAR(10),
  DB_USER        VARCHAR(50),
  MACHINE_NAME   VARCHAR(50)
);
