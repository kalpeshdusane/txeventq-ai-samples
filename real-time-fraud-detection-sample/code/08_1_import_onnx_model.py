import oracledb
import configparser

def import_onnx_model_to_oracle(onnx_model_path):
    config = configparser.ConfigParser()
    config.read('config.ini')
    DB_USER = config['database']['user']
    DB_PASSWORD = config['database']['password']
    DB_DSN = config['database']['dsn']

    with open(onnx_model_path, "rb") as f:
      onnx_data = f.read()

    connection  = oracledb.connect(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN)
    cursor = connection.cursor()

    plsql_block = """
      BEGIN        
        DBMS_DATA_MINING.IMPORT_ONNX_MODEL(
            model_name => :model_name,
            model_data => :onnx_data_blob, 
            metadata   => JSON('{"function" : "regression", 
                                  "regressionOutput" : "label"}'));
      END;
      """
    
    bind_vars = {"model_name": 'ISOLATION_FOREST_MODEL', "onnx_data_blob": onnx_data}
    cursor.execute(plsql_block, bind_vars)

    connection.commit()
    cursor.close()
    connection.close()

    print(onnx_model_path, " model imported successfully.")

if __name__ == "__main__":
    onnx_model_path = "../metadata/isolation_forest.onnx"
    import_onnx_model_to_oracle(onnx_model_path)

