set echo on
set serveroutput on

set linesize 200
column LABEL FORMAT A20
column PREDICTED_LABEL FORMAT A20

SELECT id, label, img_name,
PREDICTION(CHEST_CLASSIFIER USING img_vec) AS predicted_label,
PREDICTION_PROBABILITY(CHEST_CLASSIFIER USING img_vec) As prob
FROM chest_test
order by id;

-- Expected Output:
-- 	ID LABEL		IMG_NAME					   PREDICTED_LABEL	      PROB
-- ---------- -------------------- -------------------------------------------------- -------------------- ----------
-- 	 0 NORMAL		IM-0001-0001.jpeg				   NORMAL		9.976E-001
-- 	 1 NORMAL		IM-0003-0001.jpeg				   NORMAL		9.562E-001
-- 	 2 NORMAL		IM-0005-0001.jpeg				   NORMAL		 9.59E-001
-- 	 3 NORMAL		IM-0006-0001.jpeg				   PNEUMONIA		  9.7E-001
-- 	 4 NORMAL		IM-0007-0001.jpeg				   NORMAL		9.925E-001
-- 	 5 NORMAL		IM-0009-0001.jpeg				   NORMAL		9.983E-001
-- 	 6 NORMAL		IM-0010-0001.jpeg				   NORMAL		5.525E-001
-- 	 7 NORMAL		IM-0011-0001-0001.jpeg				   NORMAL		7.542E-001
-- 	 8 NORMAL		IM-0011-0001-0002.jpeg				   PNEUMONIA		9.362E-001
-- 	 9 NORMAL		IM-0011-0001.jpeg				   PNEUMONIA		9.279E-001
-- 	10 NORMAL		IM-0013-0001.jpeg				   NORMAL		9.982E-001

-- 	ID LABEL		IMG_NAME					   PREDICTED_LABEL	      PROB
-- ---------- -------------------- -------------------------------------------------- -------------------- ----------
-- 	11 NORMAL		NORMAL2-IM-1330-0001.jpeg			   NORMAL		9.235E-001
-- 	12 NORMAL		NORMAL2-IM-1332-0001.jpeg			   NORMAL		9.996E-001
-- 	13 NORMAL		NORMAL2-IM-1333-0001.jpeg			   NORMAL		8.922E-001
-- 	14 NORMAL		NORMAL2-IM-1334-0001.jpeg			   NORMAL		9.996E-001
-- 	15 NORMAL		NORMAL2-IM-1335-0001.jpeg			   NORMAL		9.783E-001
-- 	16 NORMAL		NORMAL2-IM-1336-0001.jpeg			   NORMAL		9.954E-001
-- 	17 NORMAL		NORMAL2-IM-1337-0001.jpeg			   NORMAL		8.847E-001
-- 	18 NORMAL		NORMAL2-IM-1338-0001.jpeg			   NORMAL		9.973E-001
-- 	19 PNEUMONIA		person1581_bacteria_4135.jpeg			   PNEUMONIA		9.998E-001
-- 	20 PNEUMONIA		person1581_virus_2741.jpeg			   PNEUMONIA		9.999E-001
-- 	21 PNEUMONIA		person1582_bacteria_4136.jpeg			   PNEUMONIA		9.906E-001
--
-- 	ID LABEL		IMG_NAME					   PREDICTED_LABEL	      PROB
-- ---------- -------------------- -------------------------------------------------- -------------------- ----------
-- 	22 PNEUMONIA		person1582_bacteria_4137.jpeg			   PNEUMONIA		9.757E-001
-- 	23 PNEUMONIA		person1582_bacteria_4140.jpeg			   PNEUMONIA		  1.0E+000
-- 	24 PNEUMONIA		person1582_bacteria_4142.jpeg			   PNEUMONIA		  1.0E+000
-- 	25 PNEUMONIA		person1582_bacteria_4143.jpeg			   PNEUMONIA		9.939E-001
-- 	26 PNEUMONIA		person1583_bacteria_4144.jpeg			   PNEUMONIA		9.968E-001
-- 	27 PNEUMONIA		person1584_bacteria_4146.jpeg			   PNEUMONIA		9.991E-001
-- 	28 PNEUMONIA		person1_virus_11.jpeg				   PNEUMONIA		  1.0E+000
-- 	29 PNEUMONIA		person1_virus_12.jpeg				   PNEUMONIA		9.962E-001
-- 	30 PNEUMONIA		person1_virus_13.jpeg				   PNEUMONIA		9.951E-001
-- 	31 PNEUMONIA		person1_virus_6.jpeg				   PNEUMONIA		9.996E-001
-- 	32 PNEUMONIA		person1_virus_7.jpeg				   PNEUMONIA		9.987E-001

-- 	ID LABEL		IMG_NAME					   PREDICTED_LABEL	      PROB
-- ---------- -------------------- -------------------------------------------------- -------------------- ----------
-- 	33 PNEUMONIA		person1_virus_8.jpeg				   PNEUMONIA		9.978E-001
-- 	34 PNEUMONIA		person1_virus_9.jpeg				   PNEUMONIA		9.995E-001
-- 	35 PNEUMONIA		person3_virus_15.jpeg				   PNEUMONIA		9.996E-001
-- 	36 PNEUMONIA		person3_virus_16.jpeg				   PNEUMONIA		9.999E-001
-- 	37 PNEUMONIA		person3_virus_17.jpeg				   PNEUMONIA		7.322E-001


SELECT id, label, img_name,
PREDICTION(BRAIN_CLASSIFIER USING img_vec) AS predicted_label,
PREDICTION_PROBABILITY(BRAIN_CLASSIFIER USING img_vec) AS prob
FROM brain_test
order by id;

-- Expected Output:
-- 	ID LABEL		IMG_NAME					   PREDICTED_LABEL	      PROB
-- ---------- -------------------- -------------------------------------------------- -------------------- ----------
-- 	 0 glioma		Te-gl_0010.jpg					   glioma		8.253E-001
-- 	 1 glioma		Te-gl_0011.jpg					   glioma		7.419E-001
-- 	 2 glioma		Te-gl_0012.jpg					   glioma		8.888E-001
-- 	 3 glioma		Te-gl_0013.jpg					   glioma		6.228E-001
-- 	 4 glioma		Te-gl_0014.jpg					   glioma		9.172E-001
-- 	 5 glioma		Te-gl_0015.jpg					   glioma		8.034E-001
-- 	 6 glioma		Te-gl_0016.jpg					   glioma		9.368E-001
-- 	 7 glioma		Te-gl_0017.jpg					   glioma		8.983E-001
-- 	 8 glioma		Te-gl_0018.jpg					   glioma		9.123E-001
-- 	 9 glioma		Te-gl_0019.jpg					   glioma		6.087E-001
-- 	10 glioma		Tr-gl_1311.jpg					   glioma		9.663E-001

-- 	ID LABEL		IMG_NAME					   PREDICTED_LABEL	      PROB
-- ---------- -------------------- -------------------------------------------------- -------------------- ----------
-- 	11 glioma		Tr-gl_1312.jpg					   glioma		9.459E-001
-- 	12 glioma		Tr-gl_1313.jpg					   glioma		9.633E-001
-- 	13 glioma		Tr-gl_1314.jpg					   glioma		9.317E-001
-- 	14 glioma		Tr-gl_1315.jpg					   glioma		8.508E-001
-- 	15 glioma		Tr-gl_1316.jpg					   glioma		8.926E-001
-- 	16 glioma		Tr-gl_1317.jpg					   glioma		8.647E-001
-- 	17 glioma		Tr-gl_1318.jpg					   glioma		8.977E-001
-- 	18 glioma		Tr-gl_1319.jpg					   glioma		7.234E-001
-- 	19 glioma		Tr-gl_1320.jpg					   glioma		7.004E-001
-- 	20 notumor		Te-no_0010.jpg					   notumor		8.228E-001
-- 	21 notumor		Te-no_0011.jpg					   notumor		8.129E-001

-- 	ID LABEL		IMG_NAME					   PREDICTED_LABEL	      PROB
-- ---------- -------------------- -------------------------------------------------- -------------------- ----------
-- 	22 notumor		Te-no_0012.jpg					   notumor		8.171E-001
-- 	23 notumor		Te-no_0013.jpg					   notumor		9.681E-001
-- 	24 notumor		Te-no_0014.jpg					   notumor		 9.74E-001
-- 	25 notumor		Te-no_0015.jpg					   notumor		7.635E-001
-- 	26 notumor		Te-no_0016.jpg					   notumor		8.785E-001
-- 	27 notumor		Te-no_0017.jpg					   notumor		6.445E-001
-- 	28 notumor		Te-no_0018.jpg					   notumor		6.907E-001
-- 	29 notumor		Te-no_0019.jpg					   notumor		7.752E-001
-- 	30 notumor		Tr-no_1581.jpg					   notumor		9.317E-001
-- 	31 notumor		Tr-no_1582.jpg					   notumor		8.963E-001
-- 	32 notumor		Tr-no_1583.jpg					   notumor		7.865E-001

-- 	ID LABEL		IMG_NAME					   PREDICTED_LABEL	      PROB
-- ---------- -------------------- -------------------------------------------------- -------------------- ----------
-- 	33 notumor		Tr-no_1584.jpg					   notumor		9.539E-001
-- 	34 notumor		Tr-no_1585.jpg					   notumor		8.907E-001
-- 	35 notumor		Tr-no_1586.jpg					   notumor		9.682E-001
-- 	36 notumor		Tr-no_1587.jpg					   notumor		7.617E-001
-- 	37 notumor		Tr-no_1588.jpg					   notumor		8.077E-001
-- 	38 notumor		Tr-no_1589.jpg					   notumor		9.555E-001
-- 	39 notumor		Tr-no_1590.jpg					   notumor		6.651E-001
-- 	40 pituitary		Te-pi_0010.jpg					   pituitary		6.129E-001
-- 	41 pituitary		Te-pi_0011.jpg					   pituitary		 8.01E-001
-- 	42 pituitary		Te-pi_0012.jpg					   pituitary		7.012E-001
-- 	43 pituitary		Te-pi_0013.jpg					   glioma		5.741E-001

-- 	ID LABEL		IMG_NAME					   PREDICTED_LABEL	      PROB
-- ---------- -------------------- -------------------------------------------------- -------------------- ----------
-- 	44 pituitary		Te-pi_0014.jpg					   pituitary		9.131E-001
-- 	45 pituitary		Te-pi_0015.jpg					   pituitary		 8.27E-001
-- 	46 pituitary		Te-pi_0016.jpg					   pituitary		7.898E-001
-- 	47 pituitary		Te-pi_0017.jpg					   pituitary		8.439E-001
-- 	48 pituitary		Te-pi_0018.jpg					   pituitary		6.937E-001
-- 	49 pituitary		Te-pi_0019.jpg					   pituitary		6.802E-001
-- 	50 pituitary		Tr-pi_1441.jpg					   pituitary		9.094E-001
-- 	51 pituitary		Tr-pi_1442.jpg					   pituitary		8.964E-001
-- 	52 pituitary		Tr-pi_1443.jpg					   pituitary		9.054E-001
-- 	53 pituitary		Tr-pi_1444.jpg					   pituitary		8.988E-001
-- 	54 pituitary		Tr-pi_1445.jpg					   pituitary		9.274E-001

-- 	ID LABEL		IMG_NAME					   PREDICTED_LABEL	      PROB
-- ---------- -------------------- -------------------------------------------------- -------------------- ----------
-- 	55 pituitary		Tr-pi_1446.jpg					   pituitary		8.504E-001
-- 	56 pituitary		Tr-pi_1447.jpg					   pituitary		9.386E-001
-- 	57 pituitary		Tr-pi_1448.jpg					   pituitary		9.616E-001
-- 	58 pituitary		Tr-pi_1449.jpg					   pituitary		8.988E-001
-- 	59 pituitary		Tr-pi_1450.jpg					   pituitary		7.903E-001

-- 60 rows selected.
