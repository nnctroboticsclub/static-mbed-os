TARGET?=NUCLEO_F446RE
BUILD?=BUILD/${TARGET}
DIST?=BUILD/dist

.PHONY: pack-all
pack-all:
	$(MAKE) pack-core
	$(MAKE) pack TARGET=NUCLEO_F446RE
	$(MAKE) pack TARGET=NUCLEO_F303K8

.PHONY: clean-all
clean-all:
	rm -rf BUILD

.PHONY: pack-core
pack-core:
	$(MAKE) -C pack-core pack

$(BUILD)/build.ninja: CMakeLists.txt
	[ -d $(BUILD) ] || mkdir -p $(BUILD)
	$(shell which cmake) \
		-DCMAKE_BUILD_TYPE=Develop \
		-DMBED_TARGET=$(TARGET) \
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

.PHONY: push
push:
	curl -X POST "$(ROBO_EP)/api/deb/upload?group=mbed" -F "file=@$(F)"


.PHONY: test
test:
	$(MAKE) build >a 2>&1