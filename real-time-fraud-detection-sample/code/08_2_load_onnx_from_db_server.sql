CREATE OR REPLACE DIRECTORY ONNX_DIR AS '/<your_ONNX_file_path>';

BEGIN
  DBMS_VECTOR.LOAD_ONNX_MODEL(
    directory   => 'ONNX_DIR',
    file_name   => 'isolation_forest.onnx',
    model_name  => 'ISOLATION_FOREST_MODEL',
    metadata    => JSON('{"function": "regression",
                          "regressionOutput": "label"}'));
END;
/
