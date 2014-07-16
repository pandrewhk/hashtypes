CREATE TABLE before (a md5hash);
INSERT INTO before values('9e107d9d372bb6826bd81d3542a419d6');
CREATE TABLE after (a md5hash);
COPY after
FROM PROGRAM 'psql -U postgres -c "COPY before TO STDOUT WITH (FORMAT binary)"            contrib_regression '
WITH (FORMAT binary);
SELECT * FROM after;
DROP TABLE before;
DROP TABLE after;

