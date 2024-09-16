################################################################################
#
# toolchain-external-andes-riscv64
#
################################################################################

TOOLCHAIN_EXTERNAL_ANDES_RISCV64_VERSION = 5_3_0
TOOLCHAIN_EXTERNAL_ANDES_RISCV64_SITE = https://github.com/andestech/Andes-Development-Kit/releases/download/ast-v$(TOOLCHAIN_EXTERNAL_ANDES_RISCV64_VERSION)-release-linux
TOOLCHAIN_EXTERNAL_ANDES_RISCV64_SOURCE = nds64le-linux-glibc-v5d.txz

# riscv64-linux-gdb requires python, replace it with riscv64-linux-gdb-nopython
define TOOLCHAIN_EXTERNAL_ANDES_RISCV64_EXTRACT_CMDS
	$(TAR) -xvf $(TOOLCHAIN_EXTERNAL_ANDES_RISCV64_DL_DIR)/$(TOOLCHAIN_EXTERNAL_ANDES_RISCV64_SOURCE) \
		-C $(TOOLCHAIN_EXTERNAL_ANDES_RISCV64_DIR) \
		--strip-components=1 nds64le-linux-glibc-v5d
	rm -rf $(TOOLCHAIN_EXTERNAL_ANDES_RISCV64_DIR)/python
	mv $(TOOLCHAIN_EXTERNAL_ANDES_RISCV64_DIR)/bin/riscv64-linux-gdb-nopython \
		$(TOOLCHAIN_EXTERNAL_ANDES_RISCV64_DIR)/bin/riscv64-linux-gdb
endef

$(eval $(toolchain-external-package))
