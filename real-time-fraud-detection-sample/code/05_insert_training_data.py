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
        ID, EVENT_HOUR, OPERATION, DB_USER, MACHINE_NAME
    ) VALUES (:1, :2, :3, :4, :5)
    """

    cols = ["TRANSACTION_ID", "EVENT_HOUR", "OPERATION", "DB_USER", "MACHINE_NAME"]
    data_tuples = list(train_data[cols].itertuples(index=False, name=None))

    cursor.executemany(insert_sql, data_tuples)

    connection.commit()
    cursor.close()
    connection.close()

    print("Inserted training data successfully.")

if __name__ == "__main__":
    input_csv_path = "../data/train_data.csv"
    insert_data(input_csv_path, "train_data")


