set echo on
DECLARE
  CURSOR c_embeddings IS
    SELECT dt.id AS doc_id, et.embed_id, et.text_chunk, et.embed_vector
    FROM my_books dt
    CROSS JOIN TABLE(
      dbms_vector_chain.utl_to_embeddings(
        dbms_vector_chain.utl_to_chunks(
          dbms_vector_chain.utl_to_text(dt.file_content),
          json('{"by":"words","max":"300","split":"sentence","normalize":"all"}')
        ),
        json('{"provider":"database", "model":"TINYBERT"}')
      )
    ) t
    CROSS JOIN JSON_TABLE(
      t.column_value,
      '$[*]' COLUMNS (
        embed_id     NUMBER          PATH '$.embed_id',
        text_chunk   VARCHAR2(4000)  PATH '$.embed_data',
        embed_vector CLOB            PATH '$.embed_vector'
      )
    ) et;

  v_row c_embeddings%ROWTYPE;

BEGIN
  OPEN c_embeddings;
  LOOP
    FETCH c_embeddings INTO v_row;
    EXIT WHEN c_embeddings%NOTFOUND;

    -- Insert one row at a time
    INSERT INTO vector_store (doc_id, embed_id, embed_data, embed_vector)
    VALUES (v_row.doc_id, v_row.embed_id, v_row.text_chunk, v_row.embed_vector);
  END LOOP;
  CLOSE c_embeddings;
END;
/
commit;
set echo off
