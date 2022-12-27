/*
 * md5 type definition
 *
 * This type is a pass-by-reference type with no varlena overhead
 * to store MD5 digests.
 *
 * Portions Copyright (c) 2001-2009, PostgreSQL Global Development Group
 */
#include "postgres.h"

#include "access/hash.h"
#include "common.h"
#include "fmgr.h"
#include "utils/builtins.h"
#include "libpq/pqformat.h"

#define MD5_LENGTH	16

typedef struct Md5 {
	unsigned char	bytes[MD5_LENGTH];
} Md5;

#define DatumGetMd5(X)		((Md5 *) DatumGetPointer(X))
#define Md5GetDatum(X)		PointerGetDatum(X)
#define PG_GETARG_MD5(n)	DatumGetMd5(PG_GETARG_DATUM(n))
#define PG_RETURN_MD5(x)	return Md5GetDatum(x)

Datum md5_in(PG_FUNCTION_ARGS);
Datum md5_out(PG_FUNCTION_ARGS);
Datum md5_recv(PG_FUNCTION_ARGS);
Datum md5_send(PG_FUNCTION_ARGS);
Datum md5_to_text(PG_FUNCTION_ARGS);
Datum text_to_md5(PG_FUNCTION_ARGS);
Datum bytea_to_md5(PG_FUNCTION_ARGS);
Datum md5_to_bytea(PG_FUNCTION_ARGS);
Datum md5_cmp(PG_FUNCTION_ARGS);
Datum md5_eq(PG_FUNCTION_ARGS);
Datum md5_ne(PG_FUNCTION_ARGS);
Datum md5_ge(PG_FUNCTION_ARGS);
Datum md5_gt(PG_FUNCTION_ARGS);
Datum md5_le(PG_FUNCTION_ARGS);
Datum md5_lt(PG_FUNCTION_ARGS);
Datum md5_hash(PG_FUNCTION_ARGS);


/*
 * Generic md5 input function.
 */
PG_FUNCTION_INFO_V1(md5_in);
Datum
md5_in(PG_FUNCTION_ARGS)
{
	char   *arg = PG_GETARG_CSTRING(0);
	Md5	   *output;
	
	output = (Md5 *) cstring_to_hexarr(arg, MD5_LENGTH, "MD5");

	PG_RETURN_MD5(output);
}

PG_FUNCTION_INFO_V1(md5_recv);
Datum
md5_recv(PG_FUNCTION_ARGS)
{
	StringInfo	buf = (StringInfo) PG_GETARG_POINTER(0);
	Md5	   		*result;
	int			nbytes;

	nbytes = buf->len - buf->cursor;
	// check nbytes == 16
	if (nbytes != MD5_LENGTH)
		ereport(ERROR,
				(errmsg("received incorrect length (expected %d bytes, got %d)",
						MD5_LENGTH, nbytes)));

	result = palloc(sizeof(Md5));

	pq_copymsgbytes(buf, result->bytes, nbytes);

	PG_RETURN_MD5(result);
}

PG_FUNCTION_INFO_V1(text_to_md5);
Datum
text_to_md5(PG_FUNCTION_ARGS)
{
	text   *arg = PG_GETARG_TEXT_P(0);
	Md5	   *value;

	value = (Md5 *) text_to_hexarr(arg, MD5_LENGTH, "MD5");

	PG_RETURN_MD5(value);
}

/*
 * Generic md5 output function.
 */
PG_FUNCTION_INFO_V1(md5_out);
Datum
md5_out(PG_FUNCTION_ARGS)
{
	Md5    *value = PG_GETARG_MD5(0);

	PG_RETURN_CSTRING(hexarr_to_cstring(value->bytes, MD5_LENGTH));
}

PG_FUNCTION_INFO_V1(md5_send);
Datum
md5_send(PG_FUNCTION_ARGS)
{
	Md5    *value = PG_GETARG_MD5(0);

	PG_RETURN_BYTEA_P(hexarr_to_bytea(value->bytes, MD5_LENGTH));
}

PG_FUNCTION_INFO_V1(md5_to_text);
Datum
md5_to_text(PG_FUNCTION_ARGS)
{
	Md5	   *value = PG_GETARG_MD5(0);
	char   *cstring;
	text   *textval;

	cstring = hexarr_to_cstring(value->bytes, MD5_LENGTH);
	textval = DatumGetTextP(DirectFunctionCall1(textin, CStringGetDatum(cstring)));
	
	PG_RETURN_TEXT_P(textval);
}

PG_FUNCTION_INFO_V1(bytea_to_md5);
Datum
bytea_to_md5(PG_FUNCTION_ARGS)
{
	bytea  *value = PG_GETARG_BYTEA_P(0);
	Md5	   *output;

	/* FIXME: this probably doesn't work cleanly with 1-byte varlena headers */
	if (VARSIZE(value) - VARHDRSZ != MD5_LENGTH)
		ereport(ERROR,
				(errmsg("bytea data of incorrect length (expected %d bytes, got %d)",
						MD5_LENGTH, VARSIZE(value) - VARHDRSZ)));

	output = palloc(sizeof(Md5));
	memcpy(output->bytes, VARDATA(value), MD5_LENGTH);

	PG_RETURN_MD5(output);
}

PG_FUNCTION_INFO_V1(md5_to_bytea);
Datum
md5_to_bytea(PG_FUNCTION_ARGS)
{
	Md5	   *value = PG_GETARG_MD5(0);

	PG_RETURN_BYTEA_P(hexarr_to_bytea(value->bytes, MD5_LENGTH));
}

PG_FUNCTION_INFO_V1(md5_cmp);
Datum
md5_cmp(PG_FUNCTION_ARGS)
{
	Md5    *a = PG_GETARG_MD5(0);
	Md5    *b = PG_GETARG_MD5(1);

	PG_RETURN_INT32(hexarr_cmp_int(a->bytes, b->bytes, MD5_LENGTH));
}

PG_FUNCTION_INFO_V1(md5_eq);
Datum
md5_eq(PG_FUNCTION_ARGS)
{
	Md5    *a = PG_GETARG_MD5(0);
	Md5    *b = PG_GETARG_MD5(1);

	PG_RETURN_BOOL(hexarr_cmp_int(a->bytes, b->bytes, MD5_LENGTH) == 0);
}

PG_FUNCTION_INFO_V1(md5_ne);
Datum
md5_ne(PG_FUNCTION_ARGS)
{
	Md5    *a = PG_GETARG_MD5(0);
	Md5    *b = PG_GETARG_MD5(1);

	PG_RETURN_BOOL(hexarr_cmp_int(a->bytes, b->bytes, MD5_LENGTH) != 0);
}

PG_FUNCTION_INFO_V1(md5_ge);
Datum
md5_ge(PG_FUNCTION_ARGS)
{
	Md5    *a = PG_GETARG_MD5(0);
	Md5    *b = PG_GETARG_MD5(1);

	PG_RETURN_BOOL(hexarr_cmp_int(a->bytes, b->bytes, MD5_LENGTH) >= 0);
}


PG_FUNCTION_INFO_V1(md5_gt);
Datum
md5_gt(PG_FUNCTION_ARGS)
{
	Md5    *a = PG_GETARG_MD5(0);
	Md5    *b = PG_GETARG_MD5(1);

	PG_RETURN_BOOL(hexarr_cmp_int(a->bytes, b->bytes, MD5_LENGTH) > 0);
}

PG_FUNCTION_INFO_V1(md5_le);
Datum
md5_le(PG_FUNCTION_ARGS)
{
	Md5    *a = PG_GETARG_MD5(0);
	Md5    *b = PG_GETARG_MD5(1);

	PG_RETURN_BOOL(hexarr_cmp_int(a->bytes, b->bytes, MD5_LENGTH) <= 0);
}

PG_FUNCTION_INFO_V1(md5_lt);
Datum
md5_lt(PG_FUNCTION_ARGS)
{
	Md5    *a = PG_GETARG_MD5(0);
	Md5    *b = PG_GETARG_MD5(1);

	PG_RETURN_BOOL(hexarr_cmp_int(a->bytes, b->bytes, MD5_LENGTH) < 0);
}

PG_FUNCTION_INFO_V1(md5_hash);
Datum
md5_hash(PG_FUNCTION_ARGS)
{
	Md5    *a = PG_GETARG_MD5(0);

	PG_RETURN_INT32(DatumGetInt32(hash_any(a->bytes, MD5_LENGTH)));
}
