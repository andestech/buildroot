Run Linux in emulation with:

  qemu-system-riscv64 -nographic -M andes_ae350 -cpu andes-ax45mpv -smp 2 -m 2G  -bios none -net nic,model=atfmac100 -net user,net=192.168.96.0/24,dhcpstart=192.168.96.10,hostfwd=tcp::2222-:22 -S -gdb tcp::6533 # qemu_riscv64_ae350_ax45mpv_defconfig

  qemu-system-riscv64 -M andes_ae350 -cpu andes-ax45mpv -nographic -m 2G -smp 2 -bios output/images/fw_jump.elf -kernel output/images/Image -dtb output/images/ax45mpv_c2_d_dsp_ae350.dtb -append "rootwait root=/dev/vda rw" # qemu_riscv64_ae350_ax45mpv_fwjump_defconfig
