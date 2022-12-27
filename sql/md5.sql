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
CREATE FUNCTION md5hash(text) RETURNS md5hash LANGUAGE C IMMUTABLE STRICT AS 'hashtypes', 'text_to_md5';
CREATE CAST (text AS md5hash) WITH FUNCTION md5t(text) AS ASSIGNMENT;

CREATE FUNCTION md5b(bytea) RETURNS md5hash LANGUAGE C IMMUTABLE STRICT AS 'hashtypes', 'bytea_to_md5';
CREATE FUNCTION md5hash(bytea) RETURNS md5hash language C IMMUTABLE STRICT AS 'hashtypes', 'bytea_to_md5';
CREATE CAST (bytea AS md5hash) WITH FUNCTION md5b(bytea) AS ASSIGNMENT;
CREATE FUNCTION bytea(md5hash) RETURNS bytea LANGUAGE C IMMUTABLE STRICT AS 'hashtypes', 'md5_to_bytea';
CREATE CAST (md5hash AS bytea) WITH FUNCTION bytea(md5hash) AS ASSIGNMENT;

DO $$
DECLARE version_num integer;
BEGIN
 SELECT current_setting('server_version_num') INTO STRICT version_num;
 IF version_num > 90600 THEN
  EXECUTE $E$ ALTER FUNCTION md5_in(cstring) PARALLEL SAFE $E$;
  EXECUTE $E$ ALTER FUNCTION md5_out(md5hash) PARALLEL SAFE $E$;
  EXECUTE $E$ ALTER FUNCTION md5_send(md5hash) PARALLEL SAFE $E$;
  EXECUTE $E$ ALTER FUNCTION md5_recv(internal) PARALLEL SAFE $E$;
  EXECUTE $E$ ALTER FUNCTION md5_lt(md5hash,md5hash) PARALLEL SAFE $E$;
  EXECUTE $E$ ALTER FUNCTION md5_le(md5hash,md5hash) PARALLEL SAFE $E$;
  EXECUTE $E$ ALTER FUNCTION md5_eq(md5hash,md5hash) PARALLEL SAFE $E$;
  EXECUTE $E$ ALTER FUNCTION md5_gt(md5hash,md5hash) PARALLEL SAFE $E$;
  EXECUTE $E$ ALTER FUNCTION md5_ge(md5hash,md5hash) PARALLEL SAFE $E$;
  EXECUTE $E$ ALTER FUNCTION md5_ne(md5hash,md5hash) PARALLEL SAFE $E$;
  EXECUTE $E$ ALTER FUNCTION md5_cmp(md5hash,md5hash) PARALLEL SAFE $E$;
  EXECUTE $E$ ALTER FUNCTION md5_hash(md5hash) PARALLEL SAFE $E$;
  EXECUTE $E$ ALTER FUNCTION md5hash(text) PARALLEL SAFE $E$;
  EXECUTE $E$ ALTER FUNCTION md5hash(bytea) PARALLEL SAFE $E$;
  EXECUTE $E$ ALTER FUNCTION md5t(text) PARALLEL SAFE $E$;
  EXECUTE $E$ ALTER FUNCTION md5b(bytea) PARALLEL SAFE $E$;
  EXECUTE $E$ ALTER FUNCTION text(md5hash) PARALLEL SAFE $E$;
  EXECUTE $E$ ALTER FUNCTION bytea(md5hash) PARALLEL SAFE $E$;
 END IF;
END;
$$; 
