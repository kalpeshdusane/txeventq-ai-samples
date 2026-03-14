import oracledb
import logging

logger = logging.getLogger(__name__)

class TxEventQ:
  def __init__(self):
    self.connection = None

  async def connect(self, db_user:str, db_password:str, dsn:str):
    self.connection = await oracledb.connect_async(user=db_user, password=db_password, dsn=dsn)

  async def disconnect(self):
    try:
      if self.connection:
        await self.connection.close()
        logger.info("Disconnected from database")
    except Exception as e:
      logger.error(f'Error disconnecting {e}')
      raise

  async def commit_transaction(self):
    if self.connection is None:
      raise RuntimeError(
        "Database connection is not established. Call 'connect()' first."
      )
    try:
      await self.connection.commit()  # type: ignore
    except Exception as e:
      logger.error(f'Error in commit_transaction {e}')
      raise

  async def enqueue(self, queue_name, pyload_type, payload):
    queue = self.connection.queue(queue_name, pyload_type)
    await queue.enqone(self.connection.msgproperties(payload=payload)) # type: ignore
      
  async def dequeue(self, queue_name, pyload_type, consumer:str = None, wait = None):
    queue = self.connection.queue(queue_name, pyload_type)
    if wait:
      queue.deqoptions.wait = wait
    if consumer != None:
      queue.deqoptions.consumername = consumer
    msg = await queue.deqone()
    return msg
