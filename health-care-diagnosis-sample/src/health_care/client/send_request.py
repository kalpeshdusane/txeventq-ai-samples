from health_care.util import config, embed
from health_care.util.txeventq_helper import TxEventQ
import numpy as np
import os
import asyncio

class MessageProcessor:
  # constants
  PAYLOAD_TYPE = "JSON"

  def __init__(self, queue_name):
    self.QUEUE_NAME = queue_name

  async def setup(self):
    self.txeventq = TxEventQ()
    await self.txeventq.connect(db_user=config.DB_USER, db_password=config.DB_PASSWORD, dsn=config.DB_DSN)

  async def process(self, req_id:int, patient_id:str, img_path:str):

    img_embedding = embed.Embedding.get_embedding(img_path)
    json_data = { "request_id": req_id, "patient_id": patient_id, "embedding": np.squeeze(img_embedding.astype(np.float32)).tolist()}
    await self.txeventq.enqueue(self.QUEUE_NAME, self.PAYLOAD_TYPE, json_data)
    await self.txeventq.commit_transaction()
    
    print("Request Send for ", req_id, " | img: ", img_path)

  async def process_dir(self, test_dir_path:str, req_id:int, patient_id:str, max_count:int = 10):

    print("-- Processing: ", test_dir_path)
    count = 0
    for img_name in os.listdir(test_dir_path):
      img_path = os.path.join(test_dir_path, img_name)
      await self.process(req_id, patient_id, img_path)
      req_id += 1
      count += 1
      if count >= max_count:
        break
    print("-- Done processing dir")

  async def run(self):

    await self.setup()

    current_dir = os.path.dirname(os.path.abspath(__file__))

    # test_dir = "../../../data/test/brain/notumor"
    # test_dir_path = os.path.abspath(os.path.join(current_dir, test_dir))
    # await self.process_dir(test_dir_path=test_dir_path, req_id=0, patient_id="P001", max_count=2)

    # test_dir = "../../../data/test/brain/glioma"
    # test_dir_path = os.path.abspath(os.path.join(current_dir, test_dir))
    # await self.process_dir(test_dir_path=test_dir, req_id=100, patient_id="P001", max_count=2)

    # test_dir = "../../../data/test/brain/pituitary"
    # test_dir_path = os.path.abspath(os.path.join(current_dir, test_dir))
    # await self.process_dir(test_dir_path=test_dir, req_id=200, patient_id="P001", max_count=2)

    # test_dir = "../../../data/test/chest/NORMAL"
    # test_dir_path = os.path.abspath(os.path.join(current_dir, test_dir))
    # await self.process_dir(test_dir_path=test_dir, req_id=300, patient_id="P001", max_count=2)

    test_dir = "../../../data/test/chest/PNEUMONIA"
    test_dir_path = os.path.abspath(os.path.join(current_dir, test_dir))
    await self.process_dir(test_dir_path=test_dir, req_id=400, patient_id="P001", max_count=2)

if __name__ == "__main__":
  processor = MessageProcessor("REQUEST_QUEUE")
  asyncio.run(processor.run())
