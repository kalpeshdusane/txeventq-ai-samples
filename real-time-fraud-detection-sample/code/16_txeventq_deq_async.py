import oracledb
import configparser
import asyncio

def get_payload_list(payload):
    
    payload_list = []
    payload_list.append(payload.TRANSACTION_ID)
    payload_list.append(payload.EVENT_HOUR)
    payload_list.append(payload.OPERATION)
    payload_list.append(payload.DB_USER)
    payload_list.append(payload.MACHINE_NAME)
    payload_list.append(payload.SESSION_NUM)

    return payload_list

async def dequeue(consumer_name):
    
    config = configparser.ConfigParser()
    config.read('config.ini')
    DB_USER = config['database']['user']
    DB_PASSWORD = config['database']['password']
    DB_DSN = config['database']['dsn']
    DB_QUEUE_NAME = config['database']['queue_name']

    connection  = await oracledb.connect_async(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN)
    payloadType = await connection.gettype("TRANSACTION_PAYLOAD")
    txeventqueue = connection.queue(DB_QUEUE_NAME, payloadType)
    txeventqueue.deqoptions.consumername = consumer_name
    txeventqueue.deqoptions.wait = 100 # wait in seconds
    msg = await txeventqueue.deqone()

    if msg is None:
        print("No more messages left to dequeue")
        return 0
    
    dequeue_payload = msg.payload
    print("Dequeued - ", get_payload_list(dequeue_payload))
    await connection.commit()

    return 1

async def dequeue_wrapper(consumer_name):
    print(f"\n------ Dequeuing for {consumer_name} subscriber ------")

    # for demo purpose it is infinite loop, user can keep some counter 
    # or change the txeventqueue.deqoptions.wait to large value 
    # or keep default value of oracledb.DEQ_WAIT_FOREVER
    while True:
        await dequeue(consumer_name)
        print("Fetching another msg")

if __name__ == "__main__":
    # asyncio.run(dequeue_wrapper("FRAUD_SUB"))
    # asyncio.run(dequeue_wrapper("FRAUD_SVM"))
    asyncio.run(dequeue_wrapper("FRAUD_ISOLATION_FOREST"))
    # asyncio.run(dequeue_wrapper("NORMAL_SUB"))


