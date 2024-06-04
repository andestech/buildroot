Intro
=====

Andes AE350 Platform

The AE350 prototype demonstrates the AE350 platform on the FPGA.

How to build it
===============

Configure Buildroot
-------------------

  $ make qemu_riscv64_kvm_ae350_defconfig

If you want to customize your configuration:

  $ make menuconfig

If you want to customize your linux configuration:

  $ make linux-menuconfig

If you want to customize your busybox configuration:

  $ make busybox-menuconfig

Build everything
----------------

Note: you will need to access to the network, since Buildroot will
download the packages sources.

  $ make

Result of the build
-------------------

After building, you should obtain the following files:

  output/images/
  ├── Image
  ├── andes_qemu_config
  ├── ax66_c1_d_ae350.dtb
  ├── fw_dynamic.bin
  ├── fw_dynamic.elf
  ├── rootfs.ext2
  ├── rootfs.ext4 -> rootfs.ext2
  ├── sdcard.img
  ├── start-qemu.sh
  ├── u-boot-spl
  └── u-boot.itb

As a reference, the SD card partition will be like:

  Disk sdcard.img: 1 GiB, 1073741824 bytes, 2097152 sectors
  Units: sectors of 1 * 512 = 512 bytes
  Sector size (logical/physical): 512 bytes / 512 bytes
  I/O size (minimum/optimal): 512 bytes / 512 bytes
  Disklabel type: dos
  Disk identifier: 0x00000000

  Device      Boot Start     End Sectors  Size Id Type
  sdcard.img1 *        1 1048576 1048576  512M 83 Linux

Run Linux in emulation with
----------------------------

qemu-system-riscv64 -readconfig andes_qemu_config -nographic -M andes_ae350 -cpu andes-ax66 -m 2G -smp 1 -bios output/images/u-boot-spl -device loader,file=output/images/u-boot.itb,addr=0x10000000 -dtb output/images/ax66_c1_d_ae350.dtb -net nic,model=atfmac100 -net user,net=192.168.86.0/24,dhcpstart=192.168.86.10,domainname=andestech.com,hostfwd=tcp::2999-:23 -drive file=sdcard.img,format=raw,id=sd2 -device sd-card,drive=sd2 -no-reboot # qemu_riscv64_kvm_ae350_defconfig

The login prompt will appear in the terminal that started Qemu.

References
----------

[1] Included in the collection at https://github.com/andestech/Andes-Development-Kit
