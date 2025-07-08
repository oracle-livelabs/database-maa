set echo on
EXEC DBMS_VECTOR.LOAD_ONNX_MODEL(
  'VEC_DUMP',
  'tinybert.onnx',
  'TINYBERT',
  JSON('{
    "function": "embedding",
    "embeddingOutput": "embedding",
    "input": {
      "input": ["DATA"]
    }
  }')
);

COMMIT;
set echo off
