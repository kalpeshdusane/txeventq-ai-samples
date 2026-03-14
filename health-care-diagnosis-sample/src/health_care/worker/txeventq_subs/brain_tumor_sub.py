from health_care.worker.txeventq_subs.txeventq_worker import txeventq_worker_run
import asyncio

if __name__ == "__main__":
  source_queue = "BRAIN_QUEUE"
  destination_queue = "DIAGNOSIS_QUEUE"
  key_name = "diag_info"
  key_value = "MRI Brain: Found Brain Tumor, Can be of type glioma or pituitary"
  source_consumer_name = "sub_tumor"
  print("-- Starting brain tumor subscriber worker --")
  asyncio.run(txeventq_worker_run(source_queue, destination_queue, key_name, key_value, source_consumer_name))
  print("-- Ending brain tumor subscriber worker --")