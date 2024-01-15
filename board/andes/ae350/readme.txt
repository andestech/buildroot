Intro
=====

Andestech AE350 Platform

The AE350 prototype demonstrates the AE350 platform on the FPGA.

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
  |-- ax45mp_c4_d_dsp_ae350.dtb
  |-- boot.vfat
  |-- fw_dynamic.bin
  |-- fw_dynamic.elf
  |-- Image.gz
  |-- rootfs.ext2
  |-- rootfs.ext4 -> rootfs.ext2
  |-- sdcard.img
  |-- u-boot-spl.bin
  `-- u-boot.itb

Copy the sdcard.img to a SD card with "dd":

  $ sudo dd if=sdcard.img of=/dev/sdX bs=4096
  $ sudo sync

As a reference, the SD card partition will be like:

  Disk /dev/sdb: 14.48 GiB, 15552479232 bytes, 30375936 sectors
  Disk model: Multi-Card
  Units: sectors of 1 * 512 = 512 bytes
  Sector size (logical/physical): 512 bytes / 512 bytes
  I/O size (minimum/optimal): 512 bytes / 512 bytes
  Disklabel type: dos
  Disk identifier: 0x00000000

  Device     Boot Start    End Sectors Size Id Type
  /dev/sdb1           1   4096    4096   2M  c W95 FAT32 (LBA)
  /dev/sdb2  *     4097 126976  122880  60M 83 Linux


Run
---

Use the SPI_Burn tool [1] to burn the u-boot-spl.bin file onto the flash.  Reference command:

  $ ./SPI_Burn --image u-boot-spl.bin --verify --unlock

Make sure the SD card is inserted and then reset the board, it should boot Linux from mmc.

References
----------

[1] Included in the collection at https://github.com/andestech/Andes-Development-Kit
