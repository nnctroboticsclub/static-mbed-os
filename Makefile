TARGET?=NUCLEO_F446RE
BUILD?=BUILD/${TARGET}

.PHONY: all
all: build

$(BUILD)/build.ninja: CMakeLists.txt
	[ -d $(BUILD) ] || mkdir -p $(BUILD)
	cd $(BUILD); cmake \
		-DCMAKE_BUILD_TYPE=Develop \
		-DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
		-DMBED_TARGET=$(TARGET) \
		-DCMAKE_INSTALL_PREFIX=/usr/arm-none-eabi/local \
		-B . -S ../../ -G Ninja

.PHONY: clean
clean:
	rm -rf $(BUILD)

.PHONY: rebuild
rebuild: clean build

.PHONY: build
build: $(BUILD)/build.ninja
	cd $(BUILD); ninja -j 12

.PHONY: install
install: $(BUILD)/build.ninja
	cd $(BUILD); ninja -j 12
	cd $(BUILD); sudo ninja -j 12 install