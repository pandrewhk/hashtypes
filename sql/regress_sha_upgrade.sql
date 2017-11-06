--
-- first, define the datatype.  Turn off echoing so that expected file
-- does not depend on contents of sha.sql.
--

\set ECHO none
\set VERBOSITY terse
SET client_min_messages = error;
drop extension if exists hashtypes cascade;;
drop schema public cascade;
create schema public;
CREATE EXTENSION hashtypes version '0.1.2';
ALTER EXTENSION hashtypes update;
--set client_min_messages = 'notice';
\set VERBOSITY default
\set ECHO all

CREATE TABLE sha (one sha1, two sha224);
CREATE INDEX sha1s_b ON sha (one);
CREATE INDEX sha1s_h ON sha USING hash (two);

COPY sha FROM stdin;
da39a3ee5e6b4b0d3255bfef95601890afd80709	d14a028c2a3a2bc9476102bb288234c415a2b01f828ea62ac5b3e42f
d67a3c66c2ed6c8855d898bb04442ce0371c1f3b	a1fcbaf07c898aa590c6f3169eef115da1a1f6521921919bee973da9
b262b078c9ec2797ad8980208ff773384d6bed9c	35aec750369ad69194f076f675afae3872e8d1a5f3b6c68ec3f9278f
\.

SET enable_seqscan TO off;
SELECT two FROM sha WHERE one = 'da39a3ee5e6b4b0d3255bfef95601890afd80709';
SELECT text(one) FROM sha WHERE two <> 'a1fcbaf07c898aa590c6f3169eef115da1a1f6521921919bee973da9';
SELECT text(one) FROM sha WHERE one >= '0000000000000000000000000000000000000000';

CREATE TABLE md5test (val md5hash);
CREATE INDEX md5_id1 ON md5test (val);
CREATE INDEX md5_id2 ON md5test USING hash(val);

INSERT INTO md5test VALUES (md5('test')), (md5('another test'));

SELECT val FROM md5test WHERE val <> md5('another test')::md5hash;
SELECT val FROM md5test WHERE val = md5('another test')::md5hash; 
SELECT text(val) FROM md5test WHERE val < 'ffffffffffffffffffffffffffffffff';
CREATE TABLE md5test_after (val md5hash);
COPY md5test TO '/tmp/tst' WITH (FORMAT binary);
COPY md5test_after FROM '/tmp/tst' WITH (FORMAT binary);
SELECT * FROM md5test;
SELECT * FROM md5test_after;
