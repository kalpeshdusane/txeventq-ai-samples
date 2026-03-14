begin
  dbms_aqadm.CREATE_TRANSACTIONAL_EVENT_QUEUE(queue_name=>'request_queue', multiple_consumers=>TRUE, queue_payload_type => 'JSON');
end;
/

execute dbms_aqadm.start_queue(queue_name=>'request_queue');

begin
  dbms_aqadm.add_subscriber(
      queue_name => 'request_queue',
      subscriber =>  sys.aq$_agent('sub_all', NULL, 0));
end;
/

begin
  dbms_aqadm.add_subscriber(
      queue_name => 'request_queue',
      subscriber =>  sys.aq$_agent('sub_chest', NULL, 0),
      rule => 'VECTOR_DISTANCE(TO_VECTOR(JSON_QUERY(tab.USER_DATA, ''$.embedding'')), get_centroid(''chest_centroid'')) < 0.4');
end;
/

Begin
  dbms_aqadm.add_subscriber(
      queue_name => 'request_queue',
      subscriber =>  sys.aq$_agent('sub_brain', NULL, 0),
      rule => 'VECTOR_DISTANCE(TO_VECTOR(JSON_QUERY(tab.USER_DATA, ''$.embedding'')), get_centroid(''brain_centroid'')) < 0.45');
end;
/
