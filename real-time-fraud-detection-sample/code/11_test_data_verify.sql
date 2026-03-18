SET LINESIZE 200
COLUMN DB_USER FORMAT A20
COLUMN MACHINE_NAME FORMAT A40

-- PRED_ANOMALY = -1 means anomaly and 1 means normal
SELECT ad.*
 , PREDICTION(ISOLATION_FOREST_MODEL USING ad.EVENT_HOUR, ad.OPERATION, ad.DB_USER, ad.MACHINE_NAME) PRED_ANOMALY
FROM test_data ad;
-- Expected Output:
-- TRANSACTION_ID EVENT_HOUR OPERATION  DB_USER	 MACHINE_NAME   SESSION_NUM IS_ANOMALY PRED_ANOMALY
-- -------------- ---------- ---------- -------------------- ---------------------------------------- ----------- ---------- ------------
-- 	     1		9  INSERT    ADMIN		  adb-ap-mumbai-1-cluster1.external		   101		0     1.0E+000
-- 	     2		9  INSERT    ADMIN		  RDP-SESSION-17				                 102		1    -1.0E+000
-- 	     3	  21 DELETE    ADMIN		  adb-ap-mumbai-1-cluster1.external		   200		1    -1.0E+000
-- 	     4	  18 INSERT    USER_2		  USER-2-MacBook-Pro				             203		0     1.0E+000
-- 	     5	  18 UPDATE    USER_2		  OTHER-android-4f2a9d1c12ab3e2d		     302		1    -1.0E+000
-- 	     6	  10 DELETE    USER_1		  USER-1-PC-DD455K1				               305		0     1.0E+000
-- 	     7	  22 INSERT    USER_1		  USER-1-PC-DD455K1				               307		1    -1.0E+000
-- 	     8	  12 DDL	     USER_1		  OTHER-android-4f2a9d1c12ab3e2d		     309		1    -1.0E+000

-- Test SVM model if trained inside Oracle DB
-- SELECT ad.*
--  , PREDICTION(SVM_MODEL USING ad.EVENT_HOUR, ad.OPERATION, ad.DB_USER, ad.MACHINE_NAME) PRED_ANOMALY
-- FROM test_data ad;