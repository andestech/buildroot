#!/bin/sh

qemu-system-riscv64 -cpu host -M virt \
	--enable-kvm \
	-smp 1 -m 512M \
	-kernel /mnt/Image \
	-append "rootwait root=/dev/vda ro" \
	-drive file=/mnt/rootfs.ext2,format=raw,id=hd0,if=none \
	-device virtio-blk-device,drive=hd0 \
	-netdev user,id=net0 \
	-device virtio-net-device,netdev=net0 \
	-nographic
