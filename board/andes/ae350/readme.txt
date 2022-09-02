Intro
=====

Andestech AE350 Platform

The AE350 prototype demonstrates the AE350 example platform on the FPGA.
This branch builds with AndeSight 5.1.0 packages of following version:

* Linux 5.4.147
* OpenSBI 0.7
* U-boot v2020.10

How to build it
===============

Configure Buildroot
-------------------

  $ make andes_ae350_45_defconfig

If you want to customize your configuration:

  $ make menuconfig

Build everything
----------------
Note: you will need to access to the network, since Buildroot will
download the packages' sources.

  $ make

Result of the build
-------------------

After building, you should obtain the following files:

  output/images/
  +-- ae350_c4_64_d.dtb
  +-- boot.scr
  +-- boot.vfat
  +-- fw_dynamic.bin
  +-- fw_dynamic.elf
  +-- Image
  +-- rootfs.ext2
  +-- rootfs.ext4 -> rootfs.ext2
  +-- rootfs.tar
  +-- sdcard.img
  +-- u-boot-spl.bin
  +-- u-boot.itb


Copy the sdcard.img to a SD card with "dd":

  $ sudo dd if=sdcard.img of=/dev/sdX bs=4096

As a reference, the SD card partition will be like:

  Disk /dev/mmcblk0: 31457280 sectors, 3072M
  Logical sector size: 512
  Disk identifier (GUID): 546663ee-d2f1-427f-93a5-5c7b69dd801c
  Partition table holds up to 128 entries
  First usable sector is 34, last usable sector is 385062

  Number  Start (sector)    End (sector)  Size Name
       1              34          262177  128M u-boot
       2          262178          385057 60.0M rootfs

Run
---

Use the SPI_Burn tool [1] to burn the u-boot-spl.bin file onto the flash.  Reference command:

  $ ./SPI_Burn --image u-boot-spl.bin --verify --unlock
  $ ./SPI_Burn --image ae350_c4_64_d.dtb -a 0xf0000 --verify --unlock

Make sure the SD card is inserted and then reset the board, it should boot Linux from mmc.

References
----------

[1] Included in the collection at https://github.com/andestech/Andes-Development-Kit
