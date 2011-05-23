# $PostgreSQL$

MODULE_big = sha
LN_OBJS = sha1.o sha224.o sha256.o sha384.o sha512.o
OBJS = common.o md5.o $(LN_OBJS)
DATA_built = sha.sql
DATA = uninstall_sha.sql
REGRESS = sha

PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)

LN_SOURCES = $(subst .o,.c,$(LN_OBJS))
$(LN_SOURCES) : % : sha.c
	rm -f $@ && $(LN_S) $< $@

clean: clean-ln clean-sql.in

clean-ln:
	rm -f $(LN_SOURCES)

clean-sql.in:
	rm -f sha.sql.in

TYPES=1 224 256 384 512
length_1=20
length_224=28
length_256=32
length_384=48
length_512=64

sha.sql.in: sha.sql.type md5.sql
	> $@
	$(foreach type,$(TYPES),sed -e "s/@SHATYPE@/$(type)/g" -e "s/@SHALENGTH@/$(length_$(type))/g" $< >> $@ ; )
	cat md5.sql >> $@

# Maybe this can be built using $(TYPES) too but I don't see how
sha1.o: CFLAGS+=-DSHA_NAME=1 -DSHA_LENGTH=20
sha224.o: CFLAGS+=-DSHA_NAME=224 -DSHA_LENGTH=28
sha256.o: CFLAGS+=-DSHA_NAME=256 -DSHA_LENGTH=32
sha384.o: CFLAGS+=-DSHA_NAME=384 -DSHA_LENGTH=48
sha512.o: CFLAGS+=-DSHA_NAME=512 -DSHA_LENGTH=64
