CREATE TABLE patient_info (
  id           VARCHAR2(10) PRIMARY KEY,
  name         VARCHAR2(100) NOT NULL,
  age          NUMBER(3),
  gender       CHAR(1) CHECK (gender IN ('M','F')),
  blood_group  VARCHAR2(3)
);

CREATE TABLE past_visits (
  id                NUMBER,                                                                                                                                                  
  patient_id        VARCHAR2(10),
  diagnostics_info  CLOB
);

-- patient_info
INSERT INTO patient_info VALUES ('P001', 'John Smith', 45, 'M', 'B+');
INSERT INTO patient_info VALUES ('P002', 'Emily Johnson', 32, 'F', 'O+');
INSERT INTO patient_info VALUES ('P003', 'Vivek Reddy', 60, 'M', 'A-');
INSERT INTO patient_info VALUES ('P004', 'Sarah Miller', 28, 'F', 'AB+');
INSERT INTO patient_info VALUES ('P005', 'David Brown', 52, 'M', 'O-');
INSERT INTO patient_info VALUES ('P006', 'Jessica Davis', 39, 'F', 'B-');
INSERT INTO patient_info VALUES ('P007', 'Daniel Wilson', 50, 'M', 'A+');
INSERT INTO patient_info VALUES ('P008', 'Ashley Martinez', 26, 'F', 'O+');
INSERT INTO patient_info VALUES ('P009', 'Christopher Taylor', 41, 'M', 'B+');
INSERT INTO patient_info VALUES ('P010', 'Amanda Anderson', 34, 'F', 'AB-');

-- past_visits
INSERT INTO past_visits (id, patient_id, diagnostics_info) VALUES (1,'P001', 'Chest X-ray (2022): Mild pneumonia detected');
INSERT INTO past_visits (id, patient_id, diagnostics_info) VALUES (2,'P001', 'MRI Brain (2023): No abnormalities found');
INSERT INTO past_visits (id, patient_id, diagnostics_info) VALUES (3,'P003', 'Chest X-ray (2021): hernia detected');
INSERT INTO past_visits (id, patient_id, diagnostics_info) VALUES (4,'P001', 'Blood test (2024): Normal');
INSERT INTO past_visits (id, patient_id, diagnostics_info) VALUES (5,'P003', 'Chest X-ray (2022): Pulmonary fibrosis');
INSERT INTO past_visits (id, patient_id, diagnostics_info) VALUES (6,'P006', 'MRI Brain (2023): Pituitary tumor detected');
INSERT INTO past_visits (id, patient_id, diagnostics_info) VALUES (7,'P007', 'Chest X-ray (2020): Lung nodule, benign');
INSERT INTO past_visits (id, patient_id, diagnostics_info) VALUES (8,'P008', 'X-ray Arm (2022): Fracture, healed');
INSERT INTO past_visits (id, patient_id, diagnostics_info) VALUES (9,'P009', 'MRI Brain (2021): Stroke history');
INSERT INTO past_visits (id, patient_id, diagnostics_info) VALUES (10,'P010', 'Chest X-ray (2023): Normal lungs');

commit;
