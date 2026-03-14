set echo on
set serveroutput on

CREATE TABLE chest_train (
    id        NUMBER  PRIMARY KEY,
    img_vec   VECTOR(*, FLOAT32),
    label     VARCHAR2(50)
);

CREATE TABLE brain_train (
    id        NUMBER  PRIMARY KEY,
    img_vec   VECTOR(*, FLOAT32),
    label     VARCHAR2(50)
);

CREATE TABLE centroid_store (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(255),
    centroid VECTOR(*, FLOAT32));

CREATE OR REPLACE FUNCTION get_centroid(centroid_name VARCHAR2)
RETURN VECTOR
IS
  ret_centroid VECTOR(*, FLOAT32);
BEGIN
  SELECT centroid
  INTO ret_centroid
  FROM centroid_store
  WHERE name = centroid_name and rownum = 1;

  RETURN ret_centroid;
END;
/
