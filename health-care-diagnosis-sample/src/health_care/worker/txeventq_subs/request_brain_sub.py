from health_care.worker.txeventq_subs.txeventq_worker import txeventq_worker_run
import asyncio

if __name__ == "__main__":
  source_queue = "REQUEST_QUEUE"
  destination_queue = "BRAIN_QUEUE"
  key_name = "type"
  key_value = "MRI Brain"
  source_consumer_name = "sub_brain"
  print("-- Starting brain subscriber worker --")
  asyncio.run(txeventq_worker_run(source_queue, destination_queue, key_name, key_value, source_consumer_name))
  print("-- Ending brain subscriber worker --")