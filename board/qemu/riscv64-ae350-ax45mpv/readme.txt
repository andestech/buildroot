Run Linux in emulation with:

  qemu-system-riscv64 -nographic -M andes_ae350 -cpu andes-ax45mpv -smp 2 -m 2G  -bios none -net nic,model=atfmac100 -net user,net=192.168.96.0/24,dhcpstart=192.168.96.10,hostfwd=tcp::2222-:22 -S -gdb tcp::6533 # qemu_riscv64_ae350_ax45mpv_defconfig
