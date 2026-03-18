import oracledb
import pandas as pd
import configparser

def insert_data(csv_path, table_name):
    train_data = pd.read_csv(csv_path)

    config = configparser.ConfigParser()
    config.read('config.ini')
    DB_USER = config['database']['user']
    DB_PASSWORD = config['database']['password']
    DB_DSN = config['database']['dsn']

    connection  = oracledb.connect(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN)
    cursor = connection.cursor()

    insert_sql = f"""
    INSERT INTO {table_name} (
        TRANSACTION_ID, EVENT_HOUR, OPERATION, DB_USER, MACHINE_NAME, SESSION_NUM, IS_ANOMALY
    ) VALUES (:1, :2, :3, :4, :5, :6, :7)
    """

    data_tuples = [tuple(x) for x in train_data.to_numpy()]

    cursor.executemany(insert_sql, data_tuples)

    connection.commit()
    cursor.close()
    connection.close()

    print("Inserted test data successfully.")

if __name__ == "__main__":
    input_csv_path = "../data/test_data_blog.csv"
    insert_data(input_csv_path, "test_data")


