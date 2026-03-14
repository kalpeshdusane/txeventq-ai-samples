set echo on
set serveroutput on

-- Give the path where pp_minilm_l6.onnx is stored
CREATE OR REPLACE DIRECTORY ONNX_DIR AS '/home/kdusane/Desktop/Work/AI/oml4py';                                                                                              

exec DBMS_VECTOR.DROP_ONNX_MODEL(model_name => 'TXT_EMBEDDER', force => true);

BEGIN
  DBMS_VECTOR.LOAD_ONNX_MODEL(
    directory  => 'ONNX_DIR',
    file_name  => 'pp_minilm_l6.onnx',
    model_name => 'TXT_EMBEDDER');
END;
/