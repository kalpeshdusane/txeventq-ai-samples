from health_care.util import config
from health_care.util.txeventq_helper import TxEventQ

class TxEventQWroker:
  # constants
  PAYLOAD_TYPE = "JSON"
  
  def __init__(self, source_queue, destination_queue, key_name, key_value, source_consumer_name, timeout = 600):
    self.source_queue = source_queue
    self.destination_queue = destination_queue
    self.key_name = key_name
    self.key_value = key_value
    self.source_consumer_name = source_consumer_name
    self.timeout = timeout

  async def setup(self):
    self.txeventq = TxEventQ()
    await self.txeventq.connect(db_user=config.DB_USER, db_password=config.DB_PASSWORD, dsn=config.DB_DSN)

  async def process_request(self):
    
    msg = await self.txeventq.dequeue(self.source_queue, self.PAYLOAD_TYPE, self.source_consumer_name, self.timeout)

    if msg is None:
      return 0  # fail
    
    print("Event Dequeued for ", msg.payload["request_id"], " from ", self.source_queue)

    # enrich the message
    msg.payload[self.key_name] = self.key_value
    
    # enqueue into next queue
    await self.txeventq.enqueue(self.destination_queue, self.PAYLOAD_TYPE, msg.payload)
    await self.txeventq.commit_transaction()
    print("Event Enqueued for ", msg.payload["request_id"], " to ", self.destination_queue)

    return 1  # success

  async def run(self):
    await self.setup()

    try:
      while(1):
        print("process next request .. ")
        return_status = await self.process_request()
        if return_status == 0:
          break
        print("-------------------")
    except Exception as e:
      print("Error processing message: ", str(e))
    finally:
      await self.txeventq.disconnect()

async def txeventq_worker_run(source_queue, destination_queue, key_name, key_value, source_consumer_name, timeout = 600):
  worker = TxEventQWroker(source_queue, destination_queue, key_name, key_value, source_consumer_name, timeout)
  await worker.run()

# if __name__ == "__main__":
#   processor = TxEventQWroker()
#   processor.run()
