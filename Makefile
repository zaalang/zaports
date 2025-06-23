.PHONY: default build-all

ARCH?=x86_64
BUILD_DIR=build/$(ARCH)
BUILD_SETUP_TARGET=${BUILD_DIR}/.setup

default: build-all

${BUILD_SETUP_TARGET}:
	mkdir -p ${BUILD_DIR}
	echo "define_options:" > ${BUILD_DIR}/bootstrap-site.yml
	echo "    arch: ${ARCH}" >> ${BUILD_DIR}/bootstrap-site.yml
	echo "    arch-triple: ${ARCH}-unknown-zaos-llvm" >> ${BUILD_DIR}/bootstrap-site.yml
	echo "labels:" >> ${BUILD_DIR}/bootstrap-site.yml
	echo "    ban:" >> ${BUILD_DIR}/bootstrap-site.yml
	echo "      - no_${ARCH}" >> ${BUILD_DIR}/bootstrap-site.yml
	(cd ${BUILD_DIR} && xbstrap init ../..)
	touch $@

rebuild-libc: ${BUILD_SETUP_TARGET}
	(cd ${BUILD_DIR} && xbstrap install --reconfigure libc)

build-all: ${BUILD_SETUP_TARGET}
	(cd ${BUILD_DIR} && xbstrap install -c --all)
