# from util import embed, config
import numpy as np
import os
import oracledb
import array
import json
from health_care.util import embed, config

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
TRAIN_DATA_DIR = os.path.abspath(os.path.join(CURRENT_DIR, "../../../data/train"))
CENTROID_DIR = os.path.abspath(os.path.join(CURRENT_DIR, "../../../data/metadata"))
EACH_CLASS_MAXIMUM_SAMPLES = 1000

def process_trainig_data(subfolder:str, table_name:str, centroid_id:int):

  # base_folder = os.path.join(TRAIN_DATA_DIR, subfolder)
  base_folder = TRAIN_DATA_DIR + "/" + subfolder
  sub_classes = os.listdir(base_folder)
  img_id = 0
  data_embeddings = []

  db_conn = oracledb.connect(user=config.DB_USER, password=config.DB_PASSWORD, dsn=config.DB_DSN)
  cursor = db_conn.cursor()
  insert_stmt = f"INSERT INTO {table_name} (id, img_vec, label) VALUES (:1, :2, :3)"

  for label in sub_classes:
    print("Processing: ", subfolder, " - ", label)
    img_folder = os.path.join(base_folder, label)
    count = 0
    for img_name in os.listdir(img_folder):
      count += 1
      img_path = os.path.join(img_folder, img_name)
      try:
        embedding = embed.Embedding.get_embedding(img_path)
        data_embeddings.append(embedding)
        vector_data = array.array("f", embedding)
        # json_data = json.dumps({"embedding": list(array.array("f", embedding))})
        # cursor.execute("INSERT INTO brain_val_j (id, img_vec, label) VALUES (:1, :2, :3)", (img_id, json_data, label))
        cursor.execute(insert_stmt, (img_id, vector_data, label))
        
        img_id += 1
        if count % 100 == 0:
          print(" --- processed ", count)
          db_conn.commit()
        if count >= EACH_CLASS_MAXIMUM_SAMPLES:
          break
      except Exception as e:
        print(f"Skipping {img_path}: {e}")

  # Centroid Computation
  centroid = np.mean(np.array(data_embeddings), axis=0)
  centroid_path = os.path.join(CENTROID_DIR, subfolder+"_centroid.npy")
  np.save(centroid_path, centroid)
  # store into Oracle DB
  centroid_vector_array = array.array("f", centroid.flatten())
  cursor.execute("INSERT INTO centroid_store (id, name, centroid) VALUES (:1, :2, :3)", (centroid_id, subfolder+"_centroid", centroid_vector_array))

  cursor.close()
  db_conn.commit()
  db_conn.close()

  print(f"Processing {subfolder} Done --------")

if __name__ == "__main__":
  
  # sub_folder = "brain"
  # table_name = "brain_train"
  # process_trainig_data(sub_folder, table_name, 1)
  sub_folder = "chest"
  table_name = "chest_train"
  process_trainig_data(sub_folder, table_name, 2)

