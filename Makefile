SKYNET_ROOT ?= ../skynet
include $(SKYNET_ROOT)/platform.mk

PLAT ?= none

TARGET = ./lcrypt.so

ifeq ($(PLAT), macosx)
	CFLAGS = -g -O2 -dynamiclib -Wl,-undefined,dynamic_lookup -DUSE_EXPORT_NAME -DUSE_RDTSC
else
ifeq ($(PLAT), linux)
	CFLAGS = -g -O2 -shared -fPIC -DUSE_EXPORT_NAME -DUSE_RDTSC
endif
endif

LUA_INC ?= $(SKYNET_ROOT)/3rd/lua
TLS_INC ?=/usr/local/opt/openssl@1.1/include
TLS_LIB ?=/usr/local/opt/openssl@1.1/lib

SRC = .

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(foreach dir, $(SRC), $(wildcard $(dir)/*.c))
	$(CC) $(CFLAGS) $(SHARED) -I$(LUA_INC) -I$(TLS_INC) -L$(TLS_LIB) $^ -o $@ -lssl

clean:
	rm -f *.o $(TARGET) && \
	rm -rf *.dSYM