from health_care.worker.agent import llm_processing
from health_care.util import config
from health_care.util.txeventq_helper import TxEventQ
import asyncio

class DiagnosisAgent:
  # constants
  PAYLOAD_TYPE = "JSON"

  def __init__(self, source_queue, destination_queue, source_consumer_name, timeout = 600):
    self.source_queue = source_queue
    self.destination_queue = destination_queue
    self.source_consumer_name = source_consumer_name
    self.timeout = timeout

  async def setup(self):
    self.txeventq = TxEventQ()
    await self.txeventq.connect(db_user=config.DB_USER, db_password=config.DB_PASSWORD, dsn=config.DB_DSN)
    self.async_cursor = self.txeventq.connection.cursor()

  async def process_request(self):

    msg = await self.txeventq.dequeue(self.source_queue, self.PAYLOAD_TYPE, self.source_consumer_name, self.timeout)
    if msg is None:
      return 0  # fail timeout
    
    req_id = msg.payload["request_id"]
    patient_id = msg.payload["patient_id"]

    print("Event Dequeued for ", req_id, " from ", self.source_queue)

    prompt = await self._generate_prompt(msg)
    llm_response_str = llm_processing.get_llm_response("oca", prompt)
    print("Got LLM Response: ", llm_response_str)

    # Put into response queue
    json_data = {"request_id": req_id, "patient_id":patient_id, "llm_response": str(llm_response_str)}
    await self.txeventq.enqueue(self.destination_queue, self.PAYLOAD_TYPE, json_data)
    await self.txeventq.commit_transaction()
    print("Event Enqueued for ", req_id, " to ", self.destination_queue)

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

  async def _generate_prompt(self, msg):
    patient_id = msg.payload["patient_id"]
    diag_info = msg.payload["diag_info"]
    report_type = msg.payload["type"]

    # Get data from Table
    # look up patient_id
    await self.async_cursor.execute("SELECT name, age, gender, blood_group FROM patient_info WHERE id = :id", [patient_id])
    patient_name, patient_age, patient_gender, patient_blood_group = await self.async_cursor.fetchone()
    # get past diag
    await self.async_cursor.execute("SELECT diagnostics_info FROM past_visits WHERE patient_id = :patient_id", [patient_id])
    rows = await self.async_cursor.fetchall()
    if rows:
      past_all_diag_list = [await lob.read() for (lob,) in rows]
    else:
      past_all_diag_list = ["No past diagnostic records found."]

    print("All past visits:")
    print(", ".join(past_all_diag_list))

    past_diag_list = past_all_diag_list
    # Vector DB Usage
    # get past diag 
    await self.async_cursor.execute("SELECT diagnostics_info FROM past_visits WHERE patient_id = :patient_id and " \
    "VECTOR_DISTANCE(VECTOR_EMBEDDING(TXT_EMBEDDER USING diagnostics_info AS data), VECTOR_EMBEDDING(TXT_EMBEDDER USING :diagnostic_text AS data), COSINE) < 0.53", [patient_id, report_type])
    rows = await self.async_cursor.fetchall()
    if rows:
      past_diag_list = [await lob.read() for (lob,) in rows]
    else:
      past_diag_list = ["No past diagnostic records found."]

    print("Only Relevent Past visits:")
    print(", ".join(past_diag_list))

    # build context
    prompt = f"""
    You are a medical assistant AI. 
    Here is the patient information:

    - Name: {patient_name}
    - Age: {patient_age}
    - Gender: {patient_gender}
    - Blood Group: {patient_blood_group}
    - Report Type: {report_type}
    Current diagnosis: {diag_info}

    Past visits:
    {chr(10).join(f"- {diag}" for diag in past_diag_list)}

    Task: Provide a brief summary of the patient's condition and possible recommendations.
    Give a response in one or two sentences only.
    """
    print("prompt processing: ", prompt)

    return prompt

if __name__ == "__main__":
  source_queue = "DIAGNOSIS_QUEUE"
  destination_queue = "RESPONSE_QUEUE"
  source_consumer_name = "sub_all"
  processor = DiagnosisAgent(source_queue, destination_queue, source_consumer_name)
  asyncio.run(processor.run())
