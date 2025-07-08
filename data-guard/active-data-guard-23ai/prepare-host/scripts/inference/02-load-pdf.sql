set echo on
INSERT INTO my_books (file_name, file_size, file_type, file_content)
VALUES (
  'adg-vs-storage-mirroring.pdf',
  DBMS_LOB.getlength(TO_BLOB(BFILENAME('VEC_DUMP', 'adg-vs-storage-mirroring.pdf'))),
  'PDF',
  TO_BLOB(BFILENAME('VEC_DUMP', 'adg-vs-storage-mirroring.pdf'))
);

COMMIT;
set echo off
