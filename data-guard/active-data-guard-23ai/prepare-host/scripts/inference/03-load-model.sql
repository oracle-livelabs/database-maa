set echo on
BEGIN
DBMS_VECTOR.LOAD_ONNX_MODEL( 'VEC_DUMP', 'tinybert.onnx', 'TINYBERT',
  JSON('{
    "function": "embedding",
    "embeddingOutput": "embedding",
    "input": {
      "input": ["DATA"]
    }
  }')
);
END;
/
COMMIT;
set echo off