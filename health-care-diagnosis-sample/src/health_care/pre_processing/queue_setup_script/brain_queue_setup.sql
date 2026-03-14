begin
  dbms_aqadm.CREATE_TRANSACTIONAL_EVENT_QUEUE(queue_name=>'brain_queue', multiple_consumers=>TRUE, queue_payload_type => 'JSON');
end;
/

execute dbms_aqadm.start_queue(queue_name=>'brain_queue');

begin
  dbms_aqadm.add_subscriber(
      queue_name => 'brain_queue',
      subscriber =>  sys.aq$_agent('sub_tumor', NULL, 0), 
      rule => 'PREDICTION(BRAIN_CLASSIFIER USING TO_VECTOR(JSON_QUERY(tab.USER_DATA, ''$.embedding'')) img_vec) <> ''notumor''');
end;
/

begin
  dbms_aqadm.add_subscriber(
      queue_name => 'brain_queue',
      subscriber =>  sys.aq$_agent('sub_no_tumor', NULL, 0),
      rule => 'PREDICTION(BRAIN_CLASSIFIER USING TO_VECTOR(JSON_QUERY(tab.USER_DATA, ''$.embedding'')) img_vec) = ''notumor''');
end;
/
