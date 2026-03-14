# from util import embed, config
import numpy as np
import os
import oracledb
import array
import json
from health_care.util import embed, config

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
TRAIN_DATA_DIR = os.path.abspath(os.path.join(CURRENT_DIR, "../../../data/test"))
EACH_CLASS_MAXIMUM_SAMPLES = 1000

def process_trainig_data(subfolder:str, table_name:str):

  # base_folder = os.path.join(TRAIN_DATA_DIR, subfolder)
  base_folder = TRAIN_DATA_DIR + "/" + subfolder
  sub_classes = os.listdir(base_folder)
  img_id = 0

  db_conn = oracledb.connect(user=config.DB_USER, password=config.DB_PASSWORD, dsn=config.DB_DSN)
  cursor = db_conn.cursor()
  insert_stmt = f"INSERT INTO {table_name} (id, img_name, img_vec, label) VALUES (:1, :2, :3, :4)"

  for label in sub_classes:
    print("Processing: ", subfolder, " - ", label)
    img_folder = os.path.join(base_folder, label)
    count = 0
    for img_name in os.listdir(img_folder):
      count += 1
      img_path = os.path.join(img_folder, img_name)
      try:
        embedding = embed.Embedding.get_embedding(img_path)
        vector_data = array.array("f", embedding)
        # json_data = json.dumps({"embedding": list(array.array("f", embedding))})
        # cursor.execute("INSERT INTO brain_val_j (id, img_vec, label) VALUES (:1, :2, :3)", (img_id, json_data, label))
        cursor.execute(insert_stmt, (img_id, img_name, vector_data, label))
        
        img_id += 1
        if count % 100 == 0:
          print(" --- processed ", count)
          db_conn.commit()
        if count >= EACH_CLASS_MAXIMUM_SAMPLES:
          break
      except Exception as e:
        print(f"Skipping {img_path}: {e}")

  cursor.close()
  db_conn.commit()
  db_conn.close()

  print(f"Processing {subfolder} Done --------")

if __name__ == "__main__":
  
  sub_folder = "brain"
  table_name = "brain_test"
  process_trainig_data(sub_folder, table_name)
  sub_folder = "chest"
  table_name = "chest_test"
  process_trainig_data(sub_folder, table_name)
