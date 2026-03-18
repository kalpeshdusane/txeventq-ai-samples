import oracledb
import configparser

def get_payload_list(payload):
    
    payload_list = []
    payload_list.append(payload.TRANSACTION_ID)
    payload_list.append(payload.EVENT_HOUR)
    payload_list.append(payload.OPERATION)
    payload_list.append(payload.DB_USER)
    payload_list.append(payload.MACHINE_NAME)
    payload_list.append(payload.SESSION_NUM)

    return payload_list

def dequeue(consumer_name):
    
    config = configparser.ConfigParser()
    config.read('config.ini')
    DB_USER = config['database']['user']
    DB_PASSWORD = config['database']['password']
    DB_DSN = config['database']['dsn']
    DB_QUEUE_NAME = config['database']['queue_name']

    connection  = oracledb.connect(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN)
    payloadType = connection.gettype("TRANSACTION_PAYLOAD")
    txeventqueue = connection.queue(DB_QUEUE_NAME, payloadType)
    txeventqueue.deqoptions.consumername = consumer_name
    txeventqueue.deqoptions.wait = oracledb.DEQ_NO_WAIT
    msg = txeventqueue.deqone()

    if msg is None:
        print("No more messages left to dequeue")
        return 0
    
    dequeue_payload = msg.payload
    print("Dequeued - ", get_payload_list(dequeue_payload))
    connection.commit()

    return 1

def dequeue_till_no_msg_left(consumer_name):
    print(f"\n------ Dequeuing for {consumer_name} subscriber ------")

    while dequeue(consumer_name) != 0:
        print("Fetching another msg")

    print("="*60)

if __name__ == "__main__":
    dequeue_till_no_msg_left("FRAUD_SUB")
    dequeue_till_no_msg_left("FRAUD_SVM")
    dequeue_till_no_msg_left("FRAUD_ISOLATION_FOREST")
    dequeue_till_no_msg_left("NORMAL_SUB")


