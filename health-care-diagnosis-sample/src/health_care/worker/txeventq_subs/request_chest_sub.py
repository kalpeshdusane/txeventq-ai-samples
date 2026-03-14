from health_care.worker.txeventq_subs.txeventq_worker import txeventq_worker_run
import asyncio

if __name__ == "__main__":
  source_queue = "REQUEST_QUEUE"
  destination_queue = "CHEST_QUEUE"
  key_name = "type"
  key_value = "Chest X-ray"
  source_consumer_name = "sub_chest"
  print("-- Starting chest subscriber worker --")
  asyncio.run(txeventq_worker_run(source_queue, destination_queue, key_name, key_value, source_consumer_name))
  print("-- Ending chest subscriber worker --")