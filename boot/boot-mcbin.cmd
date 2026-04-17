# MACCHIATObin Double Shot — Armbian boot script
# Loads kernel by actual filename (bypasses symlinks that U-Boot cannot follow)
#
# Compile:
#   mkimage -C none -A arm64 -T script -d boot-mcbin.cmd boot-mcbin.scr
# Deploy:
#   Copy boot-mcbin.scr to /boot/boot.scr on the SD card

setenv kernel_ver    6.12.81-current-mvebu64
setenv dtb_path      /boot/dtb-${kernel_ver}/marvell/armada-8040-mcbin.dtb

# Load armbianEnv.txt overrides (fdtfile, extraargs, etc.)
if ext4load mmc 1:1 ${scriptaddr} /boot/armbianEnv.txt; then
    env import -t ${scriptaddr} ${filesize}
fi

# Allow armbianEnv.txt to override fdtfile
if test -n "${fdtfile}"; then
    setenv dtb_path /boot/dtb-${kernel_ver}/marvell/${fdtfile}
fi

setenv bootargs "root=UUID=cfcc7e73-749a-4c3d-9fc1-194da22cc1ed rootfstype=ext4 rootwait console=ttyS0,115200 loglevel=${verbosity:-1} ${extraargs}"

echo "Loading kernel: /boot/vmlinuz-${kernel_ver}"
ext4load mmc 1:1 ${kernel_addr_r}   /boot/vmlinuz-${kernel_ver}

echo "Loading DTB: ${dtb_path}"
ext4load mmc 1:1 ${fdt_addr_r}      ${dtb_path}

echo "Loading initrd: /boot/uInitrd-${kernel_ver}"
ext4load mmc 1:1 ${ramdisk_addr_r}  /boot/uInitrd-${kernel_ver}

booti ${kernel_addr_r} ${ramdisk_addr_r}:${filesize} ${fdt_addr_r}
