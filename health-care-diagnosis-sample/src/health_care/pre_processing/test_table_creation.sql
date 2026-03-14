set echo on
set serveroutput on

CREATE TABLE chest_test (
    id        NUMBER  PRIMARY KEY,
    img_name  VARCHAR2(50),
    img_vec   VECTOR(*, FLOAT32),
    label     VARCHAR2(50)
);

CREATE TABLE brain_test (
    id        NUMBER  PRIMARY KEY,
    img_name  VARCHAR2(50),                                                           
    img_vec   VECTOR(*, FLOAT32),
    label     VARCHAR2(50)
);
