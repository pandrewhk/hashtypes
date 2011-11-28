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
