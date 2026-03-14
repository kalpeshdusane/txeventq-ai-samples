set echo on
set serveroutput on

WITH c AS (
    SELECT centroid
    FROM centroid_store
    WHERE name = 'chest_centroid'
)
SELECT
    MIN(VECTOR_DISTANCE(t.img_vec, c.centroid)) AS min_distance,
    MAX(VECTOR_DISTANCE(t.img_vec, c.centroid)) AS max_distance,
    AVG(VECTOR_DISTANCE(t.img_vec, c.centroid)) AS avg_distance
FROM chest_train t, c;

-- MIN_DISTANCE MAX_DISTANCE AVG_DISTANCE
-- ------------ ------------ ------------
--   6.534E-002    5.25E-001   1.628E-001

-- threshold choosen is 0.4
WITH c AS (
    SELECT centroid
    FROM centroid_store
    WHERE name = 'chest_centroid'
)
select count(*)
from chest_train t, c
where VECTOR_DISTANCE(t.img_vec, c.centroid) > 0.4;

--   COUNT(*)
-- ----------
-- 	 4

WITH c AS (
    SELECT centroid
    FROM centroid_store
    WHERE name = 'brain_centroid'
)
SELECT
    MIN(VECTOR_DISTANCE(t.img_vec, c.centroid)) AS min_distance,
    MAX(VECTOR_DISTANCE(t.img_vec, c.centroid)) AS max_distance,
    AVG(VECTOR_DISTANCE(t.img_vec, c.centroid)) AS avg_distance
FROM brain_train t, c;

-- MIN_DISTANCE MAX_DISTANCE AVG_DISTANCE
-- ------------ ------------ ------------
--   8.838E-002   4.937E-001   2.115E-001

-- threshold choosen is 0.45
WITH c AS (
    SELECT centroid
    FROM centroid_store
    WHERE name = 'brain_centroid'
)
select count(*)
from brain_train t, c
where VECTOR_DISTANCE(t.img_vec, c.centroid) > 0.45;

--   COUNT(*)
-- ----------
-- 	 9

