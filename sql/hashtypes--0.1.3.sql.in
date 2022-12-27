-- Adjust this setting to control where the objects get created.
SET search_path = @extschema@;

-- SHA-1
CREATE TYPE sha1;
CREATE FUNCTION sha1_in (cstring) RETURNS sha1 IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_in1';
CREATE FUNCTION sha1_out (sha1) RETURNS cstring IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_out1';
CREATE TYPE sha1 ( INPUT = sha1_in, OUTPUT = sha1_out, INTERNALLENGTH = 20);
CREATE FUNCTION sha_cmp(sha1, sha1) RETURNS int4 IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_cmp1';
CREATE FUNCTION sha_eq(sha1, sha1) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_eq1';
CREATE FUNCTION sha_neq(sha1, sha1) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_neq1';
CREATE FUNCTION sha_ge(sha1, sha1) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_ge1';
CREATE FUNCTION sha_gt(sha1, sha1) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_gt1';
CREATE FUNCTION sha_le(sha1, sha1) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_le1';
CREATE FUNCTION sha_lt(sha1, sha1) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_lt1';
CREATE FUNCTION sha_hash(sha1) RETURNS int IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_hash1';

CREATE OPERATOR <> ( PROCEDURE = sha_neq,
	LEFTARG = sha1, RIGHTARG = sha1,
	NEGATOR = =, RESTRICT = neqsel);
CREATE OPERATOR > ( PROCEDURE = sha_gt,
	LEFTARG = sha1, RIGHTARG = sha1,
	COMMUTATOR = <, NEGATOR = <=);
CREATE OPERATOR < ( PROCEDURE = sha_lt,
	LEFTARG = sha1, RIGHTARG = sha1,
	COMMUTATOR = >, NEGATOR = >=);
CREATE OPERATOR >= ( PROCEDURE = sha_ge,
	LEFTARG = sha1, RIGHTARG = sha1,
	COMMUTATOR = <=, NEGATOR = <);
CREATE OPERATOR <= ( PROCEDURE = sha_le,
	LEFTARG = sha1, RIGHTARG = sha1,
	COMMUTATOR = >=, NEGATOR = >);
CREATE OPERATOR = ( PROCEDURE = sha_eq,
	LEFTARG = sha1, RIGHTARG = sha1,
	COMMUTATOR = =, NEGATOR = <>, RESTRICT = eqsel, HASHES, MERGES);

CREATE OPERATOR CLASS sha1_ops DEFAULT FOR TYPE sha1 USING btree AS
       OPERATOR 1 <, OPERATOR 2 <=, OPERATOR 3 =, OPERATOR 4 >=, OPERATOR 5 >,
       FUNCTION 1 sha_cmp(sha1, sha1);
CREATE OPERATOR CLASS sha1_ops DEFAULT FOR TYPE sha1 USING hash AS
       OPERATOR 1 =, FUNCTION 1 sha_hash(sha1);

CREATE FUNCTION text(sha1) RETURNS TEXT LANGUAGE C STRICT AS 'hashtypes', 'shatext1';
CREATE FUNCTION sha1(text) RETURNS sha1 LANGUAGE C STRICT AS 'hashtypes', 'textsha1';
CREATE CAST (sha1 AS text) WITH FUNCTION text(sha1) AS ASSIGNMENT;
CREATE CAST (text AS sha1) WITH FUNCTION sha1(text) AS ASSIGNMENT;

CREATE FUNCTION sha1(bytea) RETURNS sha1 LANGUAGE C STRICT AS 'hashtypes', 'byteasha1';
CREATE FUNCTION bytea(sha1) RETURNS bytea LANGUAGE C STRICT AS 'hashtypes', 'shabytea1';
CREATE CAST (bytea AS sha1) WITH FUNCTION sha1(bytea) AS ASSIGNMENT;
CREATE CAST (sha1 AS bytea) WITH FUNCTION bytea(sha1) AS ASSIGNMENT;
-- Adjust this setting to control where the objects get created.
SET search_path = @extschema@;

-- SHA-224
CREATE TYPE sha224;
CREATE FUNCTION sha224_in (cstring) RETURNS sha224 IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_in224';
CREATE FUNCTION sha224_out (sha224) RETURNS cstring IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_out224';
CREATE TYPE sha224 ( INPUT = sha224_in, OUTPUT = sha224_out, INTERNALLENGTH = 28);
CREATE FUNCTION sha_cmp(sha224, sha224) RETURNS int4 IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_cmp224';
CREATE FUNCTION sha_eq(sha224, sha224) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_eq224';
CREATE FUNCTION sha_neq(sha224, sha224) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_neq224';
CREATE FUNCTION sha_ge(sha224, sha224) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_ge224';
CREATE FUNCTION sha_gt(sha224, sha224) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_gt224';
CREATE FUNCTION sha_le(sha224, sha224) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_le224';
CREATE FUNCTION sha_lt(sha224, sha224) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_lt224';
CREATE FUNCTION sha_hash(sha224) RETURNS int IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_hash224';

CREATE OPERATOR <> ( PROCEDURE = sha_neq,
	LEFTARG = sha224, RIGHTARG = sha224,
	NEGATOR = =, RESTRICT = neqsel);
CREATE OPERATOR > ( PROCEDURE = sha_gt,
	LEFTARG = sha224, RIGHTARG = sha224,
	COMMUTATOR = <, NEGATOR = <=);
CREATE OPERATOR < ( PROCEDURE = sha_lt,
	LEFTARG = sha224, RIGHTARG = sha224,
	COMMUTATOR = >, NEGATOR = >=);
CREATE OPERATOR >= ( PROCEDURE = sha_ge,
	LEFTARG = sha224, RIGHTARG = sha224,
	COMMUTATOR = <=, NEGATOR = <);
CREATE OPERATOR <= ( PROCEDURE = sha_le,
	LEFTARG = sha224, RIGHTARG = sha224,
	COMMUTATOR = >=, NEGATOR = >);
CREATE OPERATOR = ( PROCEDURE = sha_eq,
	LEFTARG = sha224, RIGHTARG = sha224,
	COMMUTATOR = =, NEGATOR = <>, RESTRICT = eqsel, HASHES, MERGES);

CREATE OPERATOR CLASS sha224_ops DEFAULT FOR TYPE sha224 USING btree AS
       OPERATOR 1 <, OPERATOR 2 <=, OPERATOR 3 =, OPERATOR 4 >=, OPERATOR 5 >,
       FUNCTION 1 sha_cmp(sha224, sha224);
CREATE OPERATOR CLASS sha224_ops DEFAULT FOR TYPE sha224 USING hash AS
       OPERATOR 1 =, FUNCTION 1 sha_hash(sha224);

CREATE FUNCTION text(sha224) RETURNS TEXT LANGUAGE C STRICT AS 'hashtypes', 'shatext224';
CREATE FUNCTION sha224(text) RETURNS sha224 LANGUAGE C STRICT AS 'hashtypes', 'textsha224';
CREATE CAST (sha224 AS text) WITH FUNCTION text(sha224) AS ASSIGNMENT;
CREATE CAST (text AS sha224) WITH FUNCTION sha224(text) AS ASSIGNMENT;

CREATE FUNCTION sha224(bytea) RETURNS sha224 LANGUAGE C STRICT AS 'hashtypes', 'byteasha224';
CREATE FUNCTION bytea(sha224) RETURNS bytea LANGUAGE C STRICT AS 'hashtypes', 'shabytea224';
CREATE CAST (bytea AS sha224) WITH FUNCTION sha224(bytea) AS ASSIGNMENT;
CREATE CAST (sha224 AS bytea) WITH FUNCTION bytea(sha224) AS ASSIGNMENT;
-- Adjust this setting to control where the objects get created.
SET search_path = @extschema@;

-- SHA-256
CREATE TYPE sha256;
CREATE FUNCTION sha256_in (cstring) RETURNS sha256 IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_in256';
CREATE FUNCTION sha256_out (sha256) RETURNS cstring IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_out256';
CREATE TYPE sha256 ( INPUT = sha256_in, OUTPUT = sha256_out, INTERNALLENGTH = 32);
CREATE FUNCTION sha_cmp(sha256, sha256) RETURNS int4 IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_cmp256';
CREATE FUNCTION sha_eq(sha256, sha256) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_eq256';
CREATE FUNCTION sha_neq(sha256, sha256) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_neq256';
CREATE FUNCTION sha_ge(sha256, sha256) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_ge256';
CREATE FUNCTION sha_gt(sha256, sha256) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_gt256';
CREATE FUNCTION sha_le(sha256, sha256) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_le256';
CREATE FUNCTION sha_lt(sha256, sha256) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_lt256';
CREATE FUNCTION sha_hash(sha256) RETURNS int IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_hash256';

CREATE OPERATOR <> ( PROCEDURE = sha_neq,
	LEFTARG = sha256, RIGHTARG = sha256,
	NEGATOR = =, RESTRICT = neqsel);
CREATE OPERATOR > ( PROCEDURE = sha_gt,
	LEFTARG = sha256, RIGHTARG = sha256,
	COMMUTATOR = <, NEGATOR = <=);
CREATE OPERATOR < ( PROCEDURE = sha_lt,
	LEFTARG = sha256, RIGHTARG = sha256,
	COMMUTATOR = >, NEGATOR = >=);
CREATE OPERATOR >= ( PROCEDURE = sha_ge,
	LEFTARG = sha256, RIGHTARG = sha256,
	COMMUTATOR = <=, NEGATOR = <);
CREATE OPERATOR <= ( PROCEDURE = sha_le,
	LEFTARG = sha256, RIGHTARG = sha256,
	COMMUTATOR = >=, NEGATOR = >);
CREATE OPERATOR = ( PROCEDURE = sha_eq,
	LEFTARG = sha256, RIGHTARG = sha256,
	COMMUTATOR = =, NEGATOR = <>, RESTRICT = eqsel, HASHES, MERGES);

CREATE OPERATOR CLASS sha256_ops DEFAULT FOR TYPE sha256 USING btree AS
       OPERATOR 1 <, OPERATOR 2 <=, OPERATOR 3 =, OPERATOR 4 >=, OPERATOR 5 >,
       FUNCTION 1 sha_cmp(sha256, sha256);
CREATE OPERATOR CLASS sha256_ops DEFAULT FOR TYPE sha256 USING hash AS
       OPERATOR 1 =, FUNCTION 1 sha_hash(sha256);

CREATE FUNCTION text(sha256) RETURNS TEXT LANGUAGE C STRICT AS 'hashtypes', 'shatext256';
CREATE FUNCTION sha256(text) RETURNS sha256 LANGUAGE C STRICT AS 'hashtypes', 'textsha256';
CREATE CAST (sha256 AS text) WITH FUNCTION text(sha256) AS ASSIGNMENT;
CREATE CAST (text AS sha256) WITH FUNCTION sha256(text) AS ASSIGNMENT;

CREATE FUNCTION sha256(bytea) RETURNS sha256 LANGUAGE C STRICT AS 'hashtypes', 'byteasha256';
CREATE FUNCTION bytea(sha256) RETURNS bytea LANGUAGE C STRICT AS 'hashtypes', 'shabytea256';
CREATE CAST (bytea AS sha256) WITH FUNCTION sha256(bytea) AS ASSIGNMENT;
CREATE CAST (sha256 AS bytea) WITH FUNCTION bytea(sha256) AS ASSIGNMENT;
-- Adjust this setting to control where the objects get created.
SET search_path = @extschema@;

-- SHA-384
CREATE TYPE sha384;
CREATE FUNCTION sha384_in (cstring) RETURNS sha384 IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_in384';
CREATE FUNCTION sha384_out (sha384) RETURNS cstring IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_out384';
CREATE TYPE sha384 ( INPUT = sha384_in, OUTPUT = sha384_out, INTERNALLENGTH = 48);
CREATE FUNCTION sha_cmp(sha384, sha384) RETURNS int4 IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_cmp384';
CREATE FUNCTION sha_eq(sha384, sha384) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_eq384';
CREATE FUNCTION sha_neq(sha384, sha384) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_neq384';
CREATE FUNCTION sha_ge(sha384, sha384) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_ge384';
CREATE FUNCTION sha_gt(sha384, sha384) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_gt384';
CREATE FUNCTION sha_le(sha384, sha384) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_le384';
CREATE FUNCTION sha_lt(sha384, sha384) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_lt384';
CREATE FUNCTION sha_hash(sha384) RETURNS int IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_hash384';

CREATE OPERATOR <> ( PROCEDURE = sha_neq,
	LEFTARG = sha384, RIGHTARG = sha384,
	NEGATOR = =, RESTRICT = neqsel);
CREATE OPERATOR > ( PROCEDURE = sha_gt,
	LEFTARG = sha384, RIGHTARG = sha384,
	COMMUTATOR = <, NEGATOR = <=);
CREATE OPERATOR < ( PROCEDURE = sha_lt,
	LEFTARG = sha384, RIGHTARG = sha384,
	COMMUTATOR = >, NEGATOR = >=);
CREATE OPERATOR >= ( PROCEDURE = sha_ge,
	LEFTARG = sha384, RIGHTARG = sha384,
	COMMUTATOR = <=, NEGATOR = <);
CREATE OPERATOR <= ( PROCEDURE = sha_le,
	LEFTARG = sha384, RIGHTARG = sha384,
	COMMUTATOR = >=, NEGATOR = >);
CREATE OPERATOR = ( PROCEDURE = sha_eq,
	LEFTARG = sha384, RIGHTARG = sha384,
	COMMUTATOR = =, NEGATOR = <>, RESTRICT = eqsel, HASHES, MERGES);

CREATE OPERATOR CLASS sha384_ops DEFAULT FOR TYPE sha384 USING btree AS
       OPERATOR 1 <, OPERATOR 2 <=, OPERATOR 3 =, OPERATOR 4 >=, OPERATOR 5 >,
       FUNCTION 1 sha_cmp(sha384, sha384);
CREATE OPERATOR CLASS sha384_ops DEFAULT FOR TYPE sha384 USING hash AS
       OPERATOR 1 =, FUNCTION 1 sha_hash(sha384);

CREATE FUNCTION text(sha384) RETURNS TEXT LANGUAGE C STRICT AS 'hashtypes', 'shatext384';
CREATE FUNCTION sha384(text) RETURNS sha384 LANGUAGE C STRICT AS 'hashtypes', 'textsha384';
CREATE CAST (sha384 AS text) WITH FUNCTION text(sha384) AS ASSIGNMENT;
CREATE CAST (text AS sha384) WITH FUNCTION sha384(text) AS ASSIGNMENT;

CREATE FUNCTION sha384(bytea) RETURNS sha384 LANGUAGE C STRICT AS 'hashtypes', 'byteasha384';
CREATE FUNCTION bytea(sha384) RETURNS bytea LANGUAGE C STRICT AS 'hashtypes', 'shabytea384';
CREATE CAST (bytea AS sha384) WITH FUNCTION sha384(bytea) AS ASSIGNMENT;
CREATE CAST (sha384 AS bytea) WITH FUNCTION bytea(sha384) AS ASSIGNMENT;
-- Adjust this setting to control where the objects get created.
SET search_path = @extschema@;

-- SHA-512
CREATE TYPE sha512;
CREATE FUNCTION sha512_in (cstring) RETURNS sha512 IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_in512';
CREATE FUNCTION sha512_out (sha512) RETURNS cstring IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_out512';
CREATE TYPE sha512 ( INPUT = sha512_in, OUTPUT = sha512_out, INTERNALLENGTH = 64);
CREATE FUNCTION sha_cmp(sha512, sha512) RETURNS int4 IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_cmp512';
CREATE FUNCTION sha_eq(sha512, sha512) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_eq512';
CREATE FUNCTION sha_neq(sha512, sha512) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_neq512';
CREATE FUNCTION sha_ge(sha512, sha512) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_ge512';
CREATE FUNCTION sha_gt(sha512, sha512) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_gt512';
CREATE FUNCTION sha_le(sha512, sha512) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_le512';
CREATE FUNCTION sha_lt(sha512, sha512) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_lt512';
CREATE FUNCTION sha_hash(sha512) RETURNS int IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'sha_hash512';

CREATE OPERATOR <> ( PROCEDURE = sha_neq,
	LEFTARG = sha512, RIGHTARG = sha512,
	NEGATOR = =, RESTRICT = neqsel);
CREATE OPERATOR > ( PROCEDURE = sha_gt,
	LEFTARG = sha512, RIGHTARG = sha512,
	COMMUTATOR = <, NEGATOR = <=);
CREATE OPERATOR < ( PROCEDURE = sha_lt,
	LEFTARG = sha512, RIGHTARG = sha512,
	COMMUTATOR = >, NEGATOR = >=);
CREATE OPERATOR >= ( PROCEDURE = sha_ge,
	LEFTARG = sha512, RIGHTARG = sha512,
	COMMUTATOR = <=, NEGATOR = <);
CREATE OPERATOR <= ( PROCEDURE = sha_le,
	LEFTARG = sha512, RIGHTARG = sha512,
	COMMUTATOR = >=, NEGATOR = >);
CREATE OPERATOR = ( PROCEDURE = sha_eq,
	LEFTARG = sha512, RIGHTARG = sha512,
	COMMUTATOR = =, NEGATOR = <>, RESTRICT = eqsel, HASHES, MERGES);

CREATE OPERATOR CLASS sha512_ops DEFAULT FOR TYPE sha512 USING btree AS
       OPERATOR 1 <, OPERATOR 2 <=, OPERATOR 3 =, OPERATOR 4 >=, OPERATOR 5 >,
       FUNCTION 1 sha_cmp(sha512, sha512);
CREATE OPERATOR CLASS sha512_ops DEFAULT FOR TYPE sha512 USING hash AS
       OPERATOR 1 =, FUNCTION 1 sha_hash(sha512);

CREATE FUNCTION text(sha512) RETURNS TEXT LANGUAGE C STRICT AS 'hashtypes', 'shatext512';
CREATE FUNCTION sha512(text) RETURNS sha512 LANGUAGE C STRICT AS 'hashtypes', 'textsha512';
CREATE CAST (sha512 AS text) WITH FUNCTION text(sha512) AS ASSIGNMENT;
CREATE CAST (text AS sha512) WITH FUNCTION sha512(text) AS ASSIGNMENT;

CREATE FUNCTION sha512(bytea) RETURNS sha512 LANGUAGE C STRICT AS 'hashtypes', 'byteasha512';
CREATE FUNCTION bytea(sha512) RETURNS bytea LANGUAGE C STRICT AS 'hashtypes', 'shabytea512';
CREATE CAST (bytea AS sha512) WITH FUNCTION sha512(bytea) AS ASSIGNMENT;
CREATE CAST (sha512 AS bytea) WITH FUNCTION bytea(sha512) AS ASSIGNMENT;
-- Adjust this setting to control where the objects get created.
SET search_path = @extschema@;

-- md5
CREATE TYPE md5hash;
CREATE FUNCTION md5_in (cstring) RETURNS md5hash IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'md5_in';
CREATE FUNCTION md5_out (md5hash) RETURNS cstring IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'md5_out';
CREATE FUNCTION md5_recv (internal) RETURNS md5hash IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'md5_recv';
CREATE FUNCTION md5_send (md5hash) RETURNS bytea IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'md5_send';
CREATE TYPE md5hash ( INPUT = md5_in, OUTPUT = md5_out, SEND = md5_send, RECEIVE = md5_recv, INTERNALLENGTH = 16);
CREATE FUNCTION md5_cmp(md5hash, md5hash) RETURNS int4 IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'md5_cmp';
CREATE FUNCTION md5_eq(md5hash, md5hash) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'md5_eq';
CREATE FUNCTION md5_ne(md5hash, md5hash) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'md5_ne';
CREATE FUNCTION md5_ge(md5hash, md5hash) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'md5_ge';
CREATE FUNCTION md5_gt(md5hash, md5hash) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'md5_gt';
CREATE FUNCTION md5_le(md5hash, md5hash) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'md5_le';
CREATE FUNCTION md5_lt(md5hash, md5hash) RETURNS bool IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'md5_lt';
CREATE FUNCTION md5_hash(md5hash) RETURNS int IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'md5_hash';

CREATE OPERATOR <> ( PROCEDURE = md5_ne,
	LEFTARG = md5hash, RIGHTARG = md5hash,
	NEGATOR = =, COMMUTATOR= <>,
	RESTRICT = neqsel, JOIN = neqjoinsel);
CREATE OPERATOR > ( PROCEDURE = md5_gt,
	LEFTARG = md5hash, RIGHTARG = md5hash,
	COMMUTATOR = <, NEGATOR = <=,
	RESTRICT = scalargtsel, JOIN = scalargtjoinsel);
CREATE OPERATOR < ( PROCEDURE = md5_lt,
	LEFTARG = md5hash, RIGHTARG = md5hash,
	COMMUTATOR = >, NEGATOR = >=,
	RESTRICT = scalarltsel, JOIN = scalarltjoinsel);
CREATE OPERATOR >= ( PROCEDURE = md5_ge,
	LEFTARG = md5hash, RIGHTARG = md5hash,
	COMMUTATOR = <=, NEGATOR = <,
	RESTRICT = scalargtsel, JOIN = scalargtjoinsel);
CREATE OPERATOR <= ( PROCEDURE = md5_le,
	LEFTARG = md5hash, RIGHTARG = md5hash,
	COMMUTATOR = >=, NEGATOR = >,
	RESTRICT = scalarltsel, JOIN = scalarltjoinsel);
CREATE OPERATOR = ( PROCEDURE = md5_eq,
	LEFTARG = md5hash, RIGHTARG = md5hash,
	COMMUTATOR = =, NEGATOR = <>,
	RESTRICT = eqsel, JOIN = eqjoinsel, HASHES, MERGES);

CREATE OPERATOR CLASS md5hash_ops DEFAULT FOR TYPE md5hash USING btree AS
       OPERATOR 1 <, OPERATOR 2 <=, OPERATOR 3 =, OPERATOR 4 >=, OPERATOR 5 >,
       FUNCTION 1 md5_cmp(md5hash, md5hash);
CREATE OPERATOR CLASS md5hash_ops DEFAULT FOR TYPE md5hash USING hash AS
       OPERATOR 1 =, FUNCTION 1 md5_hash(md5hash);

CREATE FUNCTION text(md5hash) RETURNS TEXT LANGUAGE C IMMUTABLE STRICT AS 'hashtypes', 'md5_to_text';
CREATE CAST (md5hash AS text) WITH FUNCTION text(md5hash) AS ASSIGNMENT;

CREATE FUNCTION md5t(text) RETURNS md5hash LANGUAGE C IMMUTABLE STRICT AS 'hashtypes', 'text_to_md5';
CREATE CAST (text AS md5hash) WITH FUNCTION md5t(text) AS ASSIGNMENT;

CREATE FUNCTION md5b(bytea) RETURNS md5hash LANGUAGE C IMMUTABLE STRICT AS 'hashtypes', 'bytea_to_md5';
CREATE CAST (bytea AS md5hash) WITH FUNCTION md5b(bytea) AS ASSIGNMENT;
CREATE FUNCTION bytea(md5hash) RETURNS bytea LANGUAGE C IMMUTABLE STRICT AS 'hashtypes', 'md5_to_bytea';
CREATE CAST (md5hash AS bytea) WITH FUNCTION bytea(md5hash) AS ASSIGNMENT;
set search_path = @extschema@;

CREATE TYPE crc32;

CREATE FUNCTION crc32_in(cstring) RETURNS crc32
AS
  'hashtypes',
  'crc32_in'
LANGUAGE C STRICT IMMUTABLE;

CREATE FUNCTION crc32_out(crc32) RETURNS cstring
AS
  'hashtypes',
  'crc32_out'
LANGUAGE C STRICT IMMUTABLE;

CREATE TYPE crc32 (
  INPUT = crc32_in,
  OUTPUT = crc32_out,
  LIKE = int4
);

CREATE FUNCTION crc32lt(crc32, crc32)
  RETURNS boolean
  AS 'int4lt'
  LANGUAGE 'internal'
  IMMUTABLE STRICT;

CREATE FUNCTION crc32le(crc32, crc32)
  RETURNS boolean
  AS 'int4le'
  LANGUAGE 'internal'
  IMMUTABLE STRICT;

CREATE FUNCTION crc32eq(crc32, crc32)
  RETURNS boolean
  AS 'int4eq'
  LANGUAGE 'internal'
  IMMUTABLE STRICT;

CREATE FUNCTION crc32ge(crc32, crc32)
  RETURNS boolean
  AS 'int4ge'
  LANGUAGE 'internal'
  IMMUTABLE STRICT;

CREATE FUNCTION crc32gt(crc32, crc32)
  RETURNS boolean
  AS 'int4gt'
  LANGUAGE 'internal'
  IMMUTABLE STRICT;

CREATE FUNCTION crc32ne(crc32, crc32)
  RETURNS boolean
  AS 'int4ne'
  LANGUAGE 'internal'
  IMMUTABLE STRICT;

CREATE OPERATOR < (
  PROCEDURE = crc32lt,
  LEFTARG = crc32,
  RIGHTARG = crc32,
  COMMUTATOR = >,
  NEGATOR = >=,
  RESTRICT = scalarltsel,
  JOIN = scalarltjoinsel);

CREATE OPERATOR <= (
  PROCEDURE = crc32le,
  LEFTARG = crc32,
  RIGHTARG = crc32,
  COMMUTATOR = >=,
  NEGATOR = >,
  RESTRICT = scalarltsel,
  JOIN = scalarltjoinsel);

CREATE OPERATOR = (
  PROCEDURE = crc32eq,
  LEFTARG = crc32,
  RIGHTARG = crc32,
  COMMUTATOR = =,
  NEGATOR = <>,
  RESTRICT = eqsel,
  JOIN = eqjoinsel,
  MERGES,
  HASHES);

CREATE OPERATOR >= (
  PROCEDURE = crc32ge,
  LEFTARG = crc32,
  RIGHTARG = crc32,
  COMMUTATOR = <=,
  NEGATOR = <,
  RESTRICT = scalargtsel,
  JOIN = scalargtjoinsel);

CREATE OPERATOR > (
  PROCEDURE = crc32gt,
  LEFTARG = crc32,
  RIGHTARG = crc32,
  COMMUTATOR = <,
  NEGATOR = <=,
  RESTRICT = scalargtsel,
  JOIN = scalargtjoinsel);

CREATE OPERATOR <> (
  PROCEDURE = crc32ne,
  LEFTARG = crc32,
  RIGHTARG = crc32,
  COMMUTATOR = <>,
  NEGATOR = =,
  RESTRICT = neqsel,
  JOIN = neqjoinsel);

CREATE OPERATOR FAMILY crc32_ops USING btree;

CREATE OPERATOR FAMILY crc32_ops USING hash;

CREATE FUNCTION btcrc32cmp(crc32, crc32)
  RETURNS int4
  AS 'btint4cmp'
  LANGUAGE 'internal'
  IMMUTABLE STRICT;

CREATE OPERATOR CLASS crc32_ops DEFAULT
  FOR TYPE crc32 USING btree FAMILY crc32_ops AS
  OPERATOR 1  <,
  OPERATOR 2  <=,
  OPERATOR 3  =,
  OPERATOR 4  >=,
  OPERATOR 5  >,
  FUNCTION 1  btcrc32cmp(crc32, crc32);

CREATE FUNCTION hashcrc32(crc32)
  RETURNS int4
  AS 'hashint4'
  LANGUAGE 'internal' IMMUTABLE STRICT;

CREATE OPERATOR CLASS crc32_ops DEFAULT
  FOR TYPE crc32 USING hash FAMILY crc32_ops AS
  OPERATOR 1  =,
  FUNCTION 1  hashcrc32(crc32);

CREATE CAST (int4 AS crc32) WITHOUT FUNCTION AS ASSIGNMENT;
CREATE CAST (crc32 AS int4) WITHOUT FUNCTION AS ASSIGNMENT;
