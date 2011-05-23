
extern unsigned char *cstring_to_hexarr(char *arg, int length, char *hashname);
extern unsigned char *text_to_hexarr(text *arg, int length, char *hashname);
extern char *hexarr_to_cstring(unsigned char *value, int length);
extern int hexarr_cmp_int(unsigned char *a, unsigned char *b, int length);
extern bytea *hexarr_to_bytea(unsigned char *value, int length);
