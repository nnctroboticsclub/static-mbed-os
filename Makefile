TARGET?=NUCLEO_F446RE
BUILD?=BUILD/${TARGET}

.PHONY: all
all: build

$(BUILD)/build.ninja: CMakeLists.txt
	[ -d $(BUILD) ] || mkdir -p $(BUILD)
	$(shell which cmake) \
		-DCMAKE_BUILD_TYPE=Develop \
		-DMBED_TARGET=$(TARGET) \
		-DCMAKE_INSTALL_PREFIX=/usr/arm-none-eabi \
		-B $(BUILD) -S . -G Ninja

.PHONY: clean
clean:
	rm -rf $(BUILD)

.PHONY: rebuild
rebuild: clean build

.PHONY: build
build: $(BUILD)/build.ninja
	ninja -C $(BUILD) -j 12

.PHONY: install
install: $(BUILD)/build.ninja
	ninja -C $(BUILD) -j 12
	sudo ninja -C $(BUILD) -j 12 install