ALTER FUNCTION sha1_in (cstring) IMMUTABLE;
ALTER FUNCTION sha1_out (sha1) IMMUTABLE;
ALTER FUNCTION sha224_in (cstring) IMMUTABLE;
ALTER FUNCTION sha224_out (sha224) IMMUTABLE;
ALTER FUNCTION sha256_in (cstring) IMMUTABLE;
ALTER FUNCTION sha256_out (sha256) IMMUTABLE;
ALTER FUNCTION sha384_in (cstring) IMMUTABLE;
ALTER FUNCTION sha384_out (sha384) IMMUTABLE;
ALTER FUNCTION sha512_in (cstring) IMMUTABLE;
ALTER FUNCTION sha512_out (sha512) IMMUTABLE;
ALTER FUNCTION md5_in (cstring) IMMUTABLE;
ALTER FUNCTION md5_out (md5hash) IMMUTABLE;

CREATE FUNCTION md5_recv (internal) RETURNS md5hash IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'md5_recv';
CREATE FUNCTION md5_send (md5hash) RETURNS bytea IMMUTABLE LANGUAGE c STRICT AS 'hashtypes', 'md5_send';

UPDATE pg_catalog.pg_type t
  SET typreceive = 'md5_recv', typsend = 'md5_send'
WHERE t.typname = 'md5hash';
