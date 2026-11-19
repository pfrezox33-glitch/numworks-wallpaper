Q ?= @
CC = arm-none-eabi-gcc
BUILD_DIR = output
NWLINK = nwlink
LINK_GC = 1
LTO = 1

src = src/main.c

CFLAGS = -std=c99 -Iepsilon-sdk/epsilon/eadk/include/eadk
CFLAGS += -Os -Wall -ggdb
LDFLAGS = -Wl,--relocatable -nostartfiles --specs=nano.specs

ifeq ($(LINK_GC),1)
CFLAGS += -fdata-sections -ffunction-sections
LDFLAGS += -Wl,-e,main -Wl,-u,eadk_app_name -Wl,-u,eadk_app_icon -Wl,-u,eadk_api_level
LDFLAGS += -Wl,--gc-sections
endif

ifeq ($(LTO),1)
CFLAGS += -flto -fno-fat-lto-objects -fwhole-program -fvisibility=internal
LDFLAGS += -flinker-output=nolto-rel
endif

.PHONY: build clean
build: $(BUILD_DIR)/app.nwa

$(BUILD_DIR)/app.nwa: $(BUILD_DIR)/main.o $(BUILD_DIR)/icon.o
	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@

$(BUILD_DIR)/main.o: src/main.c | $(BUILD_DIR)
	$(Q)$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/icon.o: src/icon.png | $(BUILD_DIR)
	$(Q)$(NWLINK) png-icon-o $< $@

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)
