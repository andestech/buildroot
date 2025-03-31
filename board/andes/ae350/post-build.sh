#!/bin/sh
# Install extlinux.conf and all sample dtb files to the boot partition.
# The Kernel, Image.gz, will be installed as specified in genimage_sdcard.cfg
# when executing genimage.sh.
BOARD_DIR="$(dirname "$0")"

# Install extlinux/extlinux.conf to the boot partition
install -m 0644 -D "${CONFIG_DIR}/${BOARD_DIR}/extlinux/extlinux.conf" "${BINARIES_DIR}"/extlinux/extlinux.conf

# Copy all sample DTB files to the dtb folder under the boot partition
mkdir -p "${BINARIES_DIR}/dtb"
cd ${BUILD_DIR}/linux-custom/arch/riscv/boot/dts/andes/
for f in *.dtb; do
	cp -av "$f" "${BINARIES_DIR}/dtb/"
done

