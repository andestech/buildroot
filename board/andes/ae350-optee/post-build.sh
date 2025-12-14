#!/bin/sh

mkdir -p "${BINARIES_DIR}"/dtb
cd "${BUILD_DIR}"/linux-custom/arch/riscv/boot/dts/andes/ || exit 1
for f in *.dtb; do
	[ -e "$f" ] || continue
	cp -av "$f" "${BINARIES_DIR}"/dtb/
done

cp "$BINARIES_DIR"/Image.gz "$TARGET_DIR"/boot
cp "$BINARIES_DIR"/dtb/ax45_c1_d_dsp_noncoherent_ae350_optee.dtb "$TARGET_DIR"/boot
cp "$BINARIES_DIR"/dtb/ax45mp_c4_d_dsp_ae350_optee.dtb "$TARGET_DIR"/boot
