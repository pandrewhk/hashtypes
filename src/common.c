/*
 * SHA-1 type definition
 *
 * This type is a pass-by-reference type with no varlena overhead
 * to store SHA-1 digests.
 *
 * Portions Copyright (c) 2001-2008, PostgreSQL Global Development Group
 */
#include "postgres.h"

#include "common.h"
#include "fmgr.h"

PG_MODULE_MAGIC;

#ifndef SET_VARSIZE
#define SET_VARSIZE(PTR, len) (VARATT_SIZEP(PTR) = len)
#endif

static const int8 hexlookup[128] = {
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, -1, -1, -1, -1, -1, -1,
    -1, 10, 11, 12, 13, 14, 15, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, 10, 11, 12, 13, 14, 15, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
};

static char
get_hex(char c)
{
	int         res = -1;

	if (c > 0 && c < 127)
		res = hexlookup[(unsigned char) c];

	if (res < 0)
		ereport(ERROR,
				(errcode(ERRCODE_INVALID_PARAMETER_VALUE),
				 errmsg("invalid hexadecimal digit: \"%c\"", c)));

	return (char) res;
}

/*
 * non-SQL-callable function to take a cstring and return a parsed array of hex
 * bytes
 */
unsigned char *
cstring_to_hexarr(char *arg, int length, char *hashname)
{
	char   *a,
		   *argend;
	char	v1,
			v2;
	unsigned char   *output;
	unsigned char   *p;
	int		filled;

	output = palloc0(length);

	argend = arg + strlen(arg);
	a = arg;
	p = output;
	filled = 0;
	while (a < argend)
	{
		if (*a == ' ' || *a == '\n' || *a == '\t' || *a == '\r')
		{
			a++;
			continue;
		}
		v1 = get_hex(*a++) << 4;
		if (a >= argend)
			ereport(ERROR,
					(errcode(ERRCODE_INVALID_PARAMETER_VALUE),
					 errmsg("invalid %s data: odd number of digits", hashname)));

		v2 = get_hex(*a++);
		filled++;
		if (filled > length)
			ereport(ERROR,
					(errmsg("invalid %s data: too many digits (expected %d)",
							hashname, length * 2)));
		*p++ = v1 | v2;
	}

	if (filled != length)
		ereport(ERROR,
				(errmsg("invalid MD5 data: not enough digits (got %d, expected %d)",
						filled * 2, length * 2)));

	return output;
}

unsigned char *
text_to_hexarr(text *arg, int length, char *hashname)
{
	int		txtsz;
	char   *bytes;
	unsigned char *value;

	/*
	 * NOTE: we'd love to pass VARDATA(arg) to cstring_to_hexarr directly, but
	 * but it's possible that it's not NUL-terminated so we must create a copy.
	 */
	txtsz = VARSIZE(arg) - VARHDRSZ;
	bytes = palloc(txtsz + 1);
	memcpy(bytes, VARDATA(arg), txtsz);
	bytes[txtsz] = '\0';
	value = cstring_to_hexarr(bytes, length, hashname);
	pfree(bytes);

	return value;
}

/* non-SQL-callable function for converting any digest value into a C-String */
char *
hexarr_to_cstring(unsigned char *value, int length)
{
	char   *output;
	int		outlen = length * 2 + 1;
	int		c;
	int		offset;

	output = palloc(outlen + 1);

	c = 0;
	offset = 0;
	/* we know all lengths are multiples of 4 */
	for (;;)
	{
		snprintf(output + offset, 9, "%02x%02x%02x%02x",
				 value[c + 0], value[c + 1], value[c + 2], value[c + 3]);
		c += 4;
		if (c >= length)
			break;
		offset += 8;
	}

	return output;
}

/* Non-SQL-callable comparison function */
int
hexarr_cmp_int(unsigned char *a, unsigned char *b, int length)
{
	int	i;

	for (i = 0; i < length; i++)
	{
		if (a[i] > b[i])
			return 1;
		if (a[i] < b[i])
			return -1;
	}

	return 0;
}

bytea *
hexarr_to_bytea(unsigned char *value, int length)
{
	bytea  *output;

	output = palloc(length + VARHDRSZ);
	memcpy(VARDATA(output), value, length);
	SET_VARSIZE(output, length + VARHDRSZ);
	return output;
}
