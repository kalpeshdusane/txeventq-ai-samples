-- Dropping OML(Oracle Machine Learning) Models
exec DBMS_DATA_MINING.DROP_MODEL(model_name => 'ISOLATION_FOREST_MODEL', force => TRUE);
exec DBMS_DATA_MINING.DROP_MODEL(model_name => 'SVM_MODEL', force => TRUE);

-- Dropping training and testing tables
drop table train_data;
drop table test_data;

-- Dropping TxEventQ
exec DBMS_AQADM.STOP_QUEUE(queue_name => 'transaction_queue');
exec DBMS_AQADM.DROP_TRANSACTIONAL_EVENT_QUEUE(queue_name => 'transaction_queue', force => TRUE);
