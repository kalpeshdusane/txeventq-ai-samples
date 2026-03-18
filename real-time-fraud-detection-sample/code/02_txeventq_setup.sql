create or replace type transaction_payload AS OBJECT
(
  TRANSACTION_ID  NUMBER,
  EVENT_HOUR      NUMBER,
  OPERATION       VARCHAR(10),
  DB_USER         VARCHAR(50),
  MACHINE_NAME    VARCHAR(50),
  SESSION_NUM     NUMBER
);
/

BEGIN
    dbms_aqadm.create_transactional_event_queue (
               queue_name         => 'transaction_queue',
               multiple_consumers => TRUE,
               queue_payload_type => 'TRANSACTION_PAYLOAD');
END;
/

EXECUTE dbms_aqadm.start_queue(queue_name => 'transaction_queue');
