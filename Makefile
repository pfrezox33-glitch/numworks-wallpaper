Q ?= @
CC = arm-none-eabi-gcc
BUILD_DIR = output
NWLINK = npx --yes -- nwlink@0.0.16
CFLAGS = -std=c99 $(shell $(NWLINK) eadk-cflags) -Os -Wall -ffunction-sections -fdata-sections
LDFLAGS = -Wl,--relocatable -nostartfiles --specs=nano.specs -Wl,-e,main -Wl,-u,eadk_app_name -Wl,-u,eadk_app_icon -Wl,-u,eadk_api_level -Wl,--gc-sections

.PHONY: build clean
build: $(BUILD_DIR)/wallpaper.nwa

$(BUILD_DIR)/wallpaper.nwa: $(BUILD_DIR)/main.o $(BUILD_DIR)/icon.o
	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@

$(BUILD_DIR)/main.o: src/main.c | $(BUILD_DIR)
	$(Q)$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/icon.o: $(BUILD_DIR)/icon.png
	$(Q)$(NWLINK) png-icon-o $< $@

$(BUILD_DIR)/icon.png: | $(BUILD_DIR)
	python3 tools/make_icon.py $@

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)
