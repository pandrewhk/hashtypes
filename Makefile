# $PostgreSQL$

HASHTYPESVERSION = 0.1.5
EXTENSION = hashtypes
DOCS = README.md
MODULE_big = hashtypes
OBJS = src/common.o src/md5.o src/crc32.o $(LN_OBJS)
DATA_built = sql/hashtypes--$(HASHTYPESVERSION).sql sql/hashtypes--0.1.2--0.1.3.sql
DATA = $(filter-out $(DATA_built), $(wildcard sql/*--*.sql))
REGRESS = regress_sha regress_sha_upgrade parallel_test

PG_CONFIG ?= pg_config

LN_OBJS = src/sha1.o src/sha224.o src/sha256.o src/sha384.o src/sha512.o
LN_SOURCES = $(subst .o,.c,$(LN_OBJS))

PGXS := $(shell $(PG_CONFIG) --pgxs)

include $(PGXS)

ifeq ($(shell test $(VERSION_NUM) -lt 90600; echo $$?),0)
REGRESS := $(filter-out parallel_test, $(REGRESS))
endif

# PostgreSQL 11 is not compatible with extensions before 0.1.5
ifeq ($(shell test $(VERSION_NUM) -ge 110000; echo $$?), 0)
REGRESS := $(filter-out regress_sha_upgrade, $(REGRESS))
endif

ifeq ($(shell test $(VERSION_NUM) -ge 90600; echo $$?),0)
  	ALTEROP = alter_op
else
	ALTEROP = no_alter_op
endif


$(LN_SOURCES) : % : src/sha.c
	rm -f $@ && $(LN_S) $(notdir $<) $@

clean: clean-ln clean-sql.in

clean-ln:
	rm -f $(LN_SOURCES)

clean-sql.in:
	rm -f sql/hashtypes--$(HASHTYPESVERSION).sql.in

TYPES=1 224 256 384 512
length_1=20
length_224=28
length_256=32
length_384=48
length_512=64

sql/hashtypes--$(HASHTYPESVERSION).sql.in: sql/sha.sql.type sql/md5.sql sql/crc32.sql
	> $@
	$(foreach type,$(TYPES),sed -e "s/@SHATYPE@/$(type)/g" -e "s/@SHALENGTH@/$(length_$(type))/g" $< >> $@ ; )
	cat sql/md5.sql >> $@
	cat sql/crc32.sql >> $@

sql/hashtypes--0.1.2--0.1.3.sql: sql/hashtypes--0.1.2--0.1.3.sql.in
	sed 's,MODULE_PATHNAME,$$libdir/$*,g' $< >$@
	cat ${<}_${ALTEROP} >> $@



# Maybe this can be built using $(TYPES) too but I don't see how
src/sha1.o: CFLAGS+=-DSHA_NAME=1 -DSHA_LENGTH=20
src/sha224.o: CFLAGS+=-DSHA_NAME=224 -DSHA_LENGTH=28
src/sha256.o: CFLAGS+=-DSHA_NAME=256 -DSHA_LENGTH=32
src/sha384.o: CFLAGS+=-DSHA_NAME=384 -DSHA_LENGTH=48
src/sha512.o: CFLAGS+=-DSHA_NAME=512 -DSHA_LENGTH=64

# install_llvm_module needs to know how to build bytecode for particular types
src/sha1.bc: CPPFLAGS+=-DSHA_NAME=1 -DSHA_LENGTH=20
src/sha224.bc: CPPFLAGS+=-DSHA_NAME=224 -DSHA_LENGTH=28
src/sha256.bc: CPPFLAGS+=-DSHA_NAME=256 -DSHA_LENGTH=32
src/sha384.bc: CPPFLAGS+=-DSHA_NAME=384 -DSHA_LENGTH=48
src/sha512.bc: CPPFLAGS+=-DSHA_NAME=512 -DSHA_LENGTH=64

dist:
	git archive --format zip \
		--prefix=hashtypes-$(HASHTYPESVERSION)/ \
		--output hashtypes-$(HASHTYPESVERSION).zip \
		master
