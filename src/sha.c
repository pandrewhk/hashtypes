/*
 * SHA type definition
 *
 * This type is a pass-by-reference type with no varlena overhead
 * to store SHA digests.
 *
 * Note that this module is not specific to any digest length; the length (in
 * bytes) and hash "name" (the number that suffixes the "SHA" word) must be
 * defined externally via CFLAGS as symbols SHA_LENGTH and SHA_NAME,
 * respectively.
 *
 * Portions Copyright (c) 2001-2009, PostgreSQL Global Development Group
 */
#include "postgres.h"

#include "access/hash.h"
#include "common.h"
#include "fmgr.h"
#include "utils/builtins.h"

#ifndef SHA_LENGTH
#error No digest length defined
#endif
#ifndef SHA_NAME
#error No algorithm name defined
#endif

typedef struct Sha {
	unsigned char	bytes[SHA_LENGTH];
} Sha;

#define DatumGetSha(X)		((Sha *) DatumGetPointer(X))
#define ShaGetDatum(X)		PointerGetDatum(X)
#define PG_GETARG_SHA(n)	DatumGetSha(PG_GETARG_DATUM(n))
#define PG_RETURN_SHA(x)	return ShaGetDatum(x)


/*
 * We build the input and output function name according to the passed
 * digest name.  Names are of the form "sha_in224" for SHA-224.
 */
#define funcname(basename, sha_name) CppConcat(basename, sha_name)

#define input_function funcname(sha_in, SHA_NAME)
#define output_function funcname(sha_out, SHA_NAME)
#define bytea_to_sha_fn funcname(byteasha, SHA_NAME)
#define sha_to_bytea_fn funcname(shabytea, SHA_NAME)
#define sha_to_text_fn funcname(shatext, SHA_NAME)
#define text_to_sha_fn funcname(textsha, SHA_NAME)
#define cmp_function funcname(sha_cmp, SHA_NAME)
#define equal_function funcname(sha_eq, SHA_NAME)
#define notequal_function funcname(sha_neq, SHA_NAME)
#define ge_function funcname(sha_ge, SHA_NAME)
#define gt_function funcname(sha_gt, SHA_NAME)
#define le_function funcname(sha_le, SHA_NAME)
#define lt_function funcname(sha_lt, SHA_NAME)
#define hash_function funcname(sha_hash, SHA_NAME)


Datum input_function(PG_FUNCTION_ARGS);
Datum output_function(PG_FUNCTION_ARGS);
Datum sha_to_text_fn(PG_FUNCTION_ARGS);
Datum text_to_sha_fn(PG_FUNCTION_ARGS);
Datum bytea_to_sha_fn(PG_FUNCTION_ARGS);
Datum sha_to_bytea_fn(PG_FUNCTION_ARGS);
Datum cmp_function(PG_FUNCTION_ARGS);
Datum equal_function(PG_FUNCTION_ARGS);
Datum notequal_function(PG_FUNCTION_ARGS);
Datum ge_function(PG_FUNCTION_ARGS);
Datum gt_function(PG_FUNCTION_ARGS);
Datum le_function(PG_FUNCTION_ARGS);
Datum lt_function(PG_FUNCTION_ARGS);
Datum hash_function(PG_FUNCTION_ARGS);


/*
 * Generic SHA input function.
 */
PG_FUNCTION_INFO_V1(input_function);
Datum
input_function(PG_FUNCTION_ARGS)
{
	char   *arg = PG_GETARG_CSTRING(0);
	Sha    *output;
	char	hashname[32];

	snprintf(hashname, 32, "SHA%d", SHA_NAME);
	output = (Sha *) cstring_to_hexarr(arg, SHA_LENGTH, hashname);

	PG_RETURN_SHA(output);
}

PG_FUNCTION_INFO_V1(text_to_sha_fn);
Datum
text_to_sha_fn(PG_FUNCTION_ARGS)
{
	text   *arg = PG_GETARG_TEXT_P(0);
	Sha	   *value;
	char	hashname[32];

	snprintf(hashname, 32, "SHA%d", SHA_NAME);
	value = (Sha *) text_to_hexarr(arg, SHA_LENGTH, hashname);

	PG_RETURN_SHA(value);
}

/*
 * Generic output function.
 */
PG_FUNCTION_INFO_V1(output_function);
Datum
output_function(PG_FUNCTION_ARGS)
{
	Sha    *value = PG_GETARG_SHA(0);

	PG_RETURN_CSTRING(hexarr_to_cstring(value->bytes, SHA_LENGTH));
}

PG_FUNCTION_INFO_V1(sha_to_text_fn);
Datum
sha_to_text_fn(PG_FUNCTION_ARGS)
{
	Sha	   *value = PG_GETARG_SHA(0);
	char   *cstring;
	text   *textval;

	cstring = hexarr_to_cstring(value->bytes, SHA_LENGTH);
	textval = DatumGetTextP(DirectFunctionCall1(textin, CStringGetDatum(cstring)));
	
	PG_RETURN_TEXT_P(textval);
}

PG_FUNCTION_INFO_V1(bytea_to_sha_fn);
Datum
bytea_to_sha_fn(PG_FUNCTION_ARGS)
{
	bytea  *value = PG_GETARG_BYTEA_P(0);
	Sha	   *output;

	/* FIXME: this probably doesn't work cleanly with 1-byte varlena headers */
	if (VARSIZE(value) - VARHDRSZ != SHA_LENGTH)
		ereport(ERROR,
				(errmsg("bytea data of incorrect length (expected %d bytes, got %d)",
						SHA_LENGTH, VARSIZE(value) - VARHDRSZ)));

	output = palloc(sizeof(Sha));
	memcpy(output->bytes, VARDATA(value), SHA_LENGTH);

	PG_RETURN_SHA(output);
}

PG_FUNCTION_INFO_V1(sha_to_bytea_fn);
Datum
sha_to_bytea_fn(PG_FUNCTION_ARGS)
{
	Sha	   *value = PG_GETARG_SHA(0);

	PG_RETURN_BYTEA_P(hexarr_to_bytea(value->bytes, SHA_LENGTH));
}

PG_FUNCTION_INFO_V1(cmp_function);
Datum
cmp_function(PG_FUNCTION_ARGS)
{
	Sha    *a = PG_GETARG_SHA(0);
	Sha    *b = PG_GETARG_SHA(1);

	PG_RETURN_INT32(hexarr_cmp_int(a->bytes, b->bytes, SHA_LENGTH));
}

PG_FUNCTION_INFO_V1(equal_function);
Datum
equal_function(PG_FUNCTION_ARGS)
{
	Sha    *a = PG_GETARG_SHA(0);
	Sha    *b = PG_GETARG_SHA(1);

	PG_RETURN_BOOL(hexarr_cmp_int(a->bytes, b->bytes, SHA_LENGTH) == 0);
}

PG_FUNCTION_INFO_V1(notequal_function);
Datum
notequal_function(PG_FUNCTION_ARGS)
{
	Sha    *a = PG_GETARG_SHA(0);
	Sha    *b = PG_GETARG_SHA(1);

	PG_RETURN_BOOL(hexarr_cmp_int(a->bytes, b->bytes, SHA_LENGTH) != 0);
}

PG_FUNCTION_INFO_V1(ge_function);
Datum
ge_function(PG_FUNCTION_ARGS)
{
	Sha    *a = PG_GETARG_SHA(0);
	Sha    *b = PG_GETARG_SHA(1);

	PG_RETURN_BOOL(hexarr_cmp_int(a->bytes, b->bytes, SHA_LENGTH) >= 0);
}


PG_FUNCTION_INFO_V1(gt_function);
Datum
gt_function(PG_FUNCTION_ARGS)
{
	Sha    *a = PG_GETARG_SHA(0);
	Sha    *b = PG_GETARG_SHA(1);

	PG_RETURN_BOOL(hexarr_cmp_int(a->bytes, b->bytes, SHA_LENGTH) > 0);
}

PG_FUNCTION_INFO_V1(le_function);
Datum
le_function(PG_FUNCTION_ARGS)
{
	Sha    *a = PG_GETARG_SHA(0);
	Sha    *b = PG_GETARG_SHA(1);

	PG_RETURN_BOOL(hexarr_cmp_int(a->bytes, b->bytes, SHA_LENGTH) <= 0);
}

PG_FUNCTION_INFO_V1(lt_function);
Datum
lt_function(PG_FUNCTION_ARGS)
{
	Sha    *a = PG_GETARG_SHA(0);
	Sha    *b = PG_GETARG_SHA(1);

	PG_RETURN_BOOL(hexarr_cmp_int(a->bytes, b->bytes, SHA_LENGTH) < 0);
}

PG_FUNCTION_INFO_V1(hash_function);
Datum
hash_function(PG_FUNCTION_ARGS)
{
	Sha    *a = PG_GETARG_SHA(0);

	PG_RETURN_INT32(DatumGetInt32(hash_any(a->bytes, SHA_LENGTH)));
}
