from health_care.worker.txeventq_subs.txeventq_worker import txeventq_worker_run
import asyncio

if __name__ == "__main__":
  source_queue = "CHEST_QUEUE"
  destination_queue = "DIAGNOSIS_QUEUE"
  key_name = "diag_info"
  key_value = "Chest X-ray: pneumonia detected"
  source_consumer_name = "sub_pneumonia"
  print("-- Starting chest pneumonia subscriber worker --")
  asyncio.run(txeventq_worker_run(source_queue, destination_queue, key_name, key_value, source_consumer_name))
  print("-- Ending chest pneumonia subscriber worker --")