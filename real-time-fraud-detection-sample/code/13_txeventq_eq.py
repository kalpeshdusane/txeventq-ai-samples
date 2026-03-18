import oracledb
import configparser
import pandas as pd

def enqueue_from_csv(csv_path):
    test_data = pd.read_csv(csv_path)

    data_tuples = [tuple(x) for x in test_data.to_numpy()]

    config = configparser.ConfigParser()
    config.read('config.ini')
    DB_USER = config['database']['user']
    DB_PASSWORD = config['database']['password']
    DB_DSN = config['database']['dsn']
    DB_QUEUE_NAME = config['database']['queue_name']

    connection = oracledb.connect(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN)

    payloadType = connection.gettype("TRANSACTION_PAYLOAD")
    txeventqueue = connection.queue(DB_QUEUE_NAME, payloadType)

    attrs = ["TRANSACTION_ID", "EVENT_HOUR", "OPERATION", "DB_USER", "MACHINE_NAME", "SESSION_NUM"]

    # transaction_payload = payloadType.newobject()

    for data in data_tuples:
        transaction_payload = payloadType.newobject()

        for attr, val in zip(attrs, data):
            setattr(transaction_payload, attr, val)
        
        txeventqueue.enqone(connection.msgproperties(payload=transaction_payload))
        connection.commit()
        print(f"enqueued - ({transaction_payload.TRANSACTION_ID}, {transaction_payload.EVENT_HOUR}, ..)")

if __name__ == "__main__":
    csv_path = "../data/test_data_blog.csv"
    enqueue_from_csv(csv_path)
