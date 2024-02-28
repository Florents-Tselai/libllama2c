CC=gcc
UNAME_S := $(shell sh -c 'uname -s 2>/dev/null || echo not')
UNAME_M := $(shell sh -c 'uname -m 2>/dev/null || echo not')
CLANG := $(findstring clang,$(shell sh -c '$(CC) --version | head -1'))

CFLAGS=-fPIC
EXTRA_FLAGS?=
CFLAGS += $(EXTRA_FLAGS)
LDFLAGS=-lm

PREFIX?=/usr/local
INSTALL_BIN=$(PREFIX)/bin
INSTALL_LIB=$(PREFIX)/lib
INSTALL=install

# Determine the OS and set the appropriate shared library extension
ifeq ($(UNAME_S),Linux)
    TARGET_LIB_EXT = .so
endif
ifeq ($(UNAME_S),Darwin)
    TARGET_LIB_EXT = .dylib
endif

TARGET_EXEC = llama2c
TARGET_LIB = libllama2c$(TARGET_LIB_EXT)

SRCS=llama2c.c
OBJS=$(SRCS:.c=.o)

all: $(TARGET_LIB) $(TARGET_EXEC)

debug: CFLAGS += $(DEBUG_FLAGS)
debug: all

$(TARGET_EXEC): CFLAGS += -DMAIN
$(TARGET_EXEC): $(OBJS)
	$(CC) -o $@ $^ $(LDFLAGS)

$(TARGET_LIB): $(OBJS)
	$(CC) $(CFLAGS) -shared -o $@ $^ $(LDFLAGS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

install:
	$(INSTALL) -d $(PREFIX)/bin
	$(INSTALL) -d $(PREFIX)/lib
	$(INSTALL) -m 755 $(TARGET_EXEC) $(PREFIX)/bin
	$(INSTALL) -m 644 $(TARGET_LIB) $(PREFIX)/lib

uninstall:
	rm -f $(PREFIX)/bin/$(TARGET_EXEC)
	rm -f $(PREFIX)/lib/$(TARGET_LIB)

TEST_SRC=test_llama2c.c
TEST_EXEC=test_llama2c

test: $(TARGET_LIB) $(TEST_SRC)
	$(CC) $(CFLAGS) -L. -lllama2c -o $(TEST_EXEC) $(TEST_SRC)
	LD_LIBRARY_PATH=. DYLD_LIBRARY_PATH=. ./$(TEST_EXEC)

clean:
	rm -f $(OBJS) $(TARGET_EXEC) $(TARGET_LIB) $(TEST_EXEC)

.PHONY: all clean test
