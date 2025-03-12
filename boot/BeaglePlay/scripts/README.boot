MuntsOS Embedded Linux for the BeagplePlay can be configure to boot from
either on board eMMC (/dev/mmcblk0p1) or microSD (/dev/mmcblk1p1).

Furthermore, U-Boot can load the kernel and related files from
either on board eMMC (/dev/mmcblk0p1) or microSD (/dev/mmcblk1p1).

The two most useful scenarios are:

1. Both U-Boot and kernel are on eMMC.

2. U-Boot is on eMMC and kernel is on microSD.

How To Install Boot Files To eMMC:
----------------------------------

This only needs to be done one time, from Debian Linux.

wget http://git.munts.com/muntsos/boot/BeaglePlay/bootfiles.tgz
mount /dev/mmcblk0p1 /mnt
tar xzf bootfiles.tgz --directory=/mnt
dd if=/mnt/tiboot3.bin of=/dev/mmcblk0boot0 bs=512
cp /mnt/boota.scr /mnt/boot.scr # Load Linux from eMMC
cp /mnt/boot1.scr /mnt/boot.scr # Load Linux from microSD
umount /mnt
