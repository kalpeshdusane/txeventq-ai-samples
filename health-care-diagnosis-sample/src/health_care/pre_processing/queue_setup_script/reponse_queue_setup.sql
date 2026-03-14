begin
  dbms_aqadm.CREATE_TRANSACTIONAL_EVENT_QUEUE(queue_name=>'response_queue', multiple_consumers=>TRUE, queue_payload_type => 'JSON');
end;
/

execute dbms_aqadm.start_queue(queue_name=>'response_queue');

begin
  dbms_aqadm.add_subscriber(
      queue_name => 'response_queue',
      subscriber =>  sys.aq$_agent('sub_all', NULL, 0));
end;
/
