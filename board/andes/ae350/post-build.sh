#!/bin/sh
# Kernel Image and DTB are fetched via extlinux.conf
IMAGE="${BINARIES_DIR}/Image.gz"
DTB="${BINARIES_DIR}/andes/ax45mp_c4_d_dsp_ae350.dtb"

# Check if source files exist
if [ ! -f ${IMAGE} ] || [ ! -f ${DTB} ]; then
    echo "Error: files do not exist"
    exit 1
fi

# Copy files to target directory
cp ${IMAGE} "${TARGET_DIR}/boot"
cp ${DTB}   "${TARGET_DIR}/boot"
