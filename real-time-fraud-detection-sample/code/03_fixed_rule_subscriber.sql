BEGIN
  dbms_aqadm.add_subscriber(
      queue_name => 'transaction_queue',
      subscriber =>  sys.aq$_agent('FRAUD_FIXED_SUB', NULL, NULL),
      rule => '(TAB.USER_DATA.OPERATION = ''DDL'' AND TAB.USER_DATA.DB_USER <> ''ADMIN'') OR (TAB.USER_DATA.DB_USER = ''ADMIN'' AND (TAB.USER_DATA.EVENT_HOUR < 9 OR TAB.USER_DATA.EVENT_HOUR > 17))');
END;
/