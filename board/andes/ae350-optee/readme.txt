Intro
=====

AndesTech AE350 Platform with OP-TEE

The AE350 prototype demonstrates the AE350 platform with OP-TEE support on
both FPGA hardware and QEMU simulation.

How to build it
===============

Configure Buildroot
-------------------

  $ make andes_ae350_45_optee_defconfig

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
  |-- ax45_c1_d_dsp_noncoherent_ae350_optee.dtb
  |-- ax45mp_c4_d_dsp_ae350_optee.dtb  
  |-- boot.vfat
  |-- fw_dynamic.bin
  |-- fw_dynamic.elf
  |-- Image.gz
  |-- rootfs.ext2
  |-- rootfs.ext4 -> rootfs.ext2
  |-- sdcard.img
  |-- tee.bin
  |-- u-boot-spl.bin
  `-- u-boot.itb

How to update the bootloader and device-tree
============================================

To update the bootloader and device tree, make sure you have
an ICEman (Andes OpenOCD [1]) and AICE [2] connection set up
as below:

  Local Host                 Local/Remote Host
 .-----------------.          .--------------.
 | buildroot images|          |              |
 |                 |         ICEman host <IP:PORT>
 | .----------.    |          |  .--------.  |
 | | SPI_burn |<---+--socket--+->| ICEman |  |
 | '----------'    |          |  '--.-----'  |
 '-----------------'          '-----|--------'
                                    |
                                    USB
   .--------------.                 |
   | target       |           .-----v-----.
   | board        <----JTAG---| AICE      |
   |              |           '-----------'
   '--------------'

[1] https://github.com/andestech/ICEman
[2] https://www.andestech.com/en/products-solutions/andeshape-platforms/aice-micro/

The Andes SPI_burn tool will be located in output/host/bin. 
Use the following commands to update the bootloader and device tree:

  $ SPI_burn --host $ICE_IP --port $ICE_BURNER_PORT --addr 0x000000 -i u-boot-spl.bin
  $ SPI_burn --host $ICE_IP --port $ICE_BURNER_PORT --addr 0x020000 -i u-boot.itb
  $ SPI_burn --host $ICE_IP --port $ICE_BURNER_PORT --addr 0x1E0000 \
	-i ax45_c1_d_dsp_noncoherent_ae350_optee.dtb

Note that the --addr option specifies the offset starting from
the flash base address 0x80000000 and set by U-Boot configurations.
e.g.
u-boot-spl.bin: CONFIG_SPL_TEXT_BASE=0x80000000
u-boot.itb:     CONFIG_SPL_LOAD_FIT_ADDRESS=0x80020000
ax45_c1_d_dsp_noncoherent_ae350_optee.dtb: CONFIG_SYS_FDT_BASE=0x801E0000

How to write the SD card
========================

Copy the sdcard.img to a SD card with "dd":

  $ sudo dd if=sdcard.img of=/dev/sdX bs=4096
  $ sudo sync

OP-TEE OS (tee.bin)
===================

The file `tee.bin` is the OP-TEE OS secure world binary.
It provides a Trusted Execution Environment (TEE) that runs alongside Linux in
secure mode.

The OP-TEE OS binary (`tee.bin`) is packaged inside the `u-boot.itb` image on 
the AE350 platform.

OP-TEE provides the following core security services:

- Secure execution of Trusted Applications (TAs)
- Secure key storage and cryptographic operations
- Hardware-backed isolation between Secure World and Normal World
- Secure monitor call (SMC) interface for Linux communication

Linux communicates with OP-TEE through the standard OP-TEE Linux driver using
SMC calls. This allows normal world applications to access secure services
without exposing sensitive data to the Linux kernel.

For the quad-core configuration, switch to ax45mp_c4_d_dsp_ae350_optee.dts.
Set the following options in menuconfig:

Kernel  ---> In-tree Device Tree Source file names
BR2_LINUX_KERNEL_INTREE_DTS_NAME="andes/ax45mp_c4_d_dsp_ae350_optee"

Bootloaders  ---> Additional build variables
BR2_TARGET_OPTEE_OS_ADDITIONAL_VARIABLES="CFG_TEE_CORE_NB_CORE=4 CFG_NUM_THREADS=8"

OP-TEE User-space Configuration (4.3.0)
======================================

The OP-TEE user-space components are built from custom upstream
tarballs and provide Linux support for OP-TEE OS.

They can be enabled from Buildroot menuconfig:
  Target packages  --->
    Security  --->

  -*- optee-client
      optee-client version (Custom tarball)  --->
        URL of custom optee-client tarball:
          $(call github,OP-TEE,optee_client,4.3.0)/optee_client-4.3.0.tar.gz

  [*] optee-examples
      optee-examples version (Custom tarball)  --->
        $(call github,linaro-swg,optee_examples,4.3.0)/optee_examples-4.3.0.tar.gz

  [*] optee-test
      optee-test version (Custom tarball)  --->
        $(call github,OP-TEE,optee_test,4.3.0)/optee_test-4.3.0.tar.gz

QEMU (AE350 simulation)  
=======================

To run the andes_ae350 machine model, use the QEMU version:
https://github.com/andestech/qemu

Boot command example:
  qemu-system-riscv64 \
    -nographic \
    -M andes_ae350 \
    -cpu andes-ax45 \
    -m 2G -smp 1 \
    -bios none \
    -device loader,file=u-boot-spl.bin,addr=0x80000000 \
    -device loader,file=u-boot.itb,addr=0x80020000 \
    -device loader,file=dtb/ax45_c1_d_dsp_noncoherent_ae350_optee.dtb,addr=0x801E0000 \
    -drive file=sdcard.img,format=raw,id=sd1 \
    -device sd-card,drive=sd1 \
    -net nic,model=atfmac100 \
    -net user,net=192.168.96.0/24,dhcpstart=192.168.96.10,domainname=andestech.com,hostfwd=tcp::9623-:23 \
    -gdb tcp::9696

