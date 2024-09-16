## Build Andes QEMU and AndeSight v5.3.0 packages

The defconfig is using Andes pre-built toolchian.

```
$ git clone https://github.com/andestech/buildroot -b dev-qemu-ax45mpv
$ cd buildroot
$ make qemu_riscv64_ae350_ax45mpv_defconfig
$ make
```

## Run QEMU with GDB server

```
$ ./output/images/start-qemu.sh
```

The terminal running the script is also the Linux console.

## Attach GDB and load U-Boot binaries

Launch another terminal and access the toolchain locate at `<buildroot>/output/host`:

```
$ export PATH=$PWD/output/host/bin:$PATH
$ export CROSS_COMPILE=riscv64-linux-
```

Attach the QEMU GDB:

```
$ QEMU_HOST=127.0.0.1
$ QEMU_PORT=6533
$ IMAGE_DIR=$PWD/output/images
$ ${CROSS_COMPILE}gdb -q \
    -ex "target remote $QEMU_HOST:$QEMU_PORT" \
    -ex 'set confirm off' \
    -ex 'set pagination off' \
    -ex 'monitor reset halt' \
    -ex 'set $ra=0' \
    -ex 'set $sp=0' \
    -ex 'maintenance flush register-cache' \
    -ex "file $IMAGE_DIR/u-boot-spl" \
    -ex "load" \
    -ex "restore $IMAGE_DIR/u-boot.itb binary 0x10000000" \
    -ex "restore $IMAGE_DIR/ax45mpv_c2_d_dsp_ae350.dtb binary 0x20000000" \
    -ex 'thread apply all set $pc=&_start' \
    -ex 'thread apply all set $a0=$mhartid' \
    -ex 'thread apply all set $a1=0x20000000' \
    -ex 'continue' \
    $IMAGE_DIR/u-boot-spl
```

## Load and boot Liunx image with initramfs

Wait for the U-Boot prompt to appear.
In the GDB terminal, press `<Ctrl-C>` to interrupt the system.

```
(gdb) restore output/images/Image binary 0x600000
(gdb) continue
```

Enter the following U-Boot command to boot the Linux image:

```
RISC-V # booti $kernel_addr_r - $fdtcontroladdr
```
