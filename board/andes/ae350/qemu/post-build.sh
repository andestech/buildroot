#!/bin/sh
set -ex
BOARD_DIR="$(dirname "$0")"
DEFCONFIG_NAME="$(basename "$2")"
README_FILES="${BOARD_DIR}/readme.txt"

# Kernel Image and DTB are fetched via extlinux.conf
IMAGE="${BINARIES_DIR}/Image"
DTB="${BINARIES_DIR}/ax66_c1_d_ae350.dtb"

# QEMU boot script for starting Host and Guest Linux
START_QEMU_SCRIPT="${BINARIES_DIR}/start-qemu.sh"
START_QEMU_GUEST_SCRIPT="${BOARD_DIR}/start-qemu-guest.sh"
QEMU_CONFIG="${BOARD_DIR}/andes_qemu_config"

# Check if source files exist
if [ ! -f ${IMAGE} ]; then
    echo "Error: files do not exist"
    exit 1
fi

# Prepare QEMU startup script:
# Search for "# qemu_*_defconfig" tag in all readme.txt files.
# Qemu command line on multilines using back slash are accepted.
# shellcheck disable=SC2086 # glob over each readme file
QEMU_CMD_LINE="$(sed -r ':a; /\\$/N; s/\\\n//; s/\t/ /; ta; /# '"${DEFCONFIG_NAME}"'$/!d; s/#.*//' ${README_FILES})"

# Remove output/images path since the script will be in
# the same directory as the kernel and the rootfs images.
QEMU_CMD_LINE="${QEMU_CMD_LINE//output\/images\//}"

# Remove any string before qemu-system-*
QEMU_CMD_LINE="$(sed -r -e 's/^.*(qemu-system-)/\1/' <<<"${QEMU_CMD_LINE}")"

sed -e "s|@QEMU_CMD_LINE@|${QEMU_CMD_LINE}|g" \
	-e "s|@HOST_DIR@|${HOST_DIR}|g" \
	<"${BOARD_DIR}/start-qemu.sh.in" \
	>"${START_QEMU_SCRIPT}"
chmod +x "${START_QEMU_SCRIPT}"


# Copy files to target directory
mkdir -p "${TARGET_DIR}/GuestOS"
cp ${START_QEMU_GUEST_SCRIPT} "${TARGET_DIR}/GuestOS"
cp ${IMAGE} "${TARGET_DIR}/boot"
cp ${DTB}   "${TARGET_DIR}/boot"

# Copy files to image directory
cp ${QEMU_CONFIG} ${BINARIES_DIR}

