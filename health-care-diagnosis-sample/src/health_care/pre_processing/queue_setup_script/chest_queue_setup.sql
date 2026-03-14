begin
  dbms_aqadm.CREATE_TRANSACTIONAL_EVENT_QUEUE(queue_name=>'chest_queue', multiple_consumers=>TRUE, queue_payload_type => 'JSON');
end;
/

execute dbms_aqadm.start_queue(queue_name=>'chest_queue');

begin
  dbms_aqadm.add_subscriber(
      queue_name => 'chest_queue',
      subscriber =>  sys.aq$_agent('sub_pneumonia', NULL, 0),
      rule => 'PREDICTION(CHEST_CLASSIFIER USING TO_VECTOR(JSON_QUERY(tab.USER_DATA, ''$.embedding'')) img_vec) = ''PNEUMONIA''');
end;
/

Begin
  dbms_aqadm.add_subscriber(
      queue_name => 'chest_queue',
      subscriber =>  sys.aq$_agent('sub_normal', NULL, 0),
      rule => 'PREDICTION(CHEST_CLASSIFIER USING TO_VECTOR(JSON_QUERY(tab.USER_DATA, ''$.embedding'')) img_vec) = ''NORMAL''');
end;
/
