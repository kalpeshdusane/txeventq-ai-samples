from health_care.util import config
from health_care.util.txeventq_helper import TxEventQ
import asyncio

class MessageProcessor:
  # constants
  PAYLOAD_TYPE = "JSON"

  def __init__(self, queue_name, consumer_name, timeout=600):
    self.QUEUE_NAME = queue_name
    self.CONSUMER_NAME = consumer_name
    self.timeout = timeout

  async def setup(self):
    self.txeventq = TxEventQ()
    await self.txeventq.connect(db_user=config.DB_USER, db_password=config.DB_PASSWORD, dsn=config.DB_DSN)

  async def fetch_response(self):

    msg = await self.txeventq.dequeue(self.QUEUE_NAME, self.PAYLOAD_TYPE, self.CONSUMER_NAME, self.timeout)
    if msg is None:
      return 0  # fail timeout
    
    payload = msg.payload
    await self.txeventq.commit_transaction()
    print("Response received for request-", payload["request_id"], " is ", payload["llm_response"])

    return 1  # success

  async def run(self):
    await self.setup()

    try:
      while(1):
        print("process next request .. ")
        return_status = await self.fetch_response()
        if return_status == 0:
          break
        print("-------------------")
    except Exception as e:
      print("Error processing message: ", str(e))
    finally:
      await self.txeventq.disconnect()

if __name__ == "__main__":
  processor = MessageProcessor("RESPONSE_QUEUE", "sub_all")
  asyncio.run(processor.run())
