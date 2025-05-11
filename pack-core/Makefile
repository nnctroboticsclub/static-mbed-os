BUILD?=../BUILD/Core
DIST?=../BUILD/dist


$(BUILD)/build.ninja: CMakeLists.txt
	[ -d $(BUILD) ] || mkdir -p $(BUILD)
	$(shell which cmake) \
		-DCMAKE_BUILD_TYPE=Develop \
		-DCMAKE_INSTALL_PREFIX=/usr/arm-none-eabi \
		-DCPACK_PACKAGING_INSTALL_PREFIX=/usr/arm-none-eabi \
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

.PHONY: pack
pack: $(BUILD)/build.ninja
	ninja -C $(BUILD) -j 12 package

	[ -d $(DIST) ] || mkdir -p $(DIST)
	cp $(BUILD)/dist/*.deb $(BUILD)/dist/*.tar.gz $(DIST)
