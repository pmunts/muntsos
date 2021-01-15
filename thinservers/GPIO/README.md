Dedicated GPIO Server using MuntsOS
===================================

[MuntsOS](http://git.munts.com/muntsos) is a very small embedded Linux
distribution based on [BusyBox](http://www.busybox.net) and other
components. MuntsOS is delivered as a single Linux kernel image file,
which also contains the root file system using the
[`initramfs`](http://en.wikipedia.org/wiki/Initramfs) facility. After
the Linux kernel has booted, the system runs entirely from RAM. There
are several advantages to this, especially for remote and/or headless
embedded systems:

-   Boot time is significantly faster
-   File system access is very fast
-   Risk of SD card corruption is minimized
-   No need to perform an orderly shutdown

At boot time the MuntsOS environment can be extended by packages in
`/boot/packages` or *extension modules* which are executable shell
archive scripts installed in the directory `autoexec.d` on various media
such as the SD card boot partition, USB mass storage device, USB CD-ROM,
or NFS mount.

This `Makefile` builds a `.zip` file containing everything needed to
boot MuntsOS running the [GPIO
Server](http://git.munts.com/muntsos/extensions/GPIO) Extension.

Just download one of the GPIO Thin Server zip files from
<http://repo.munts.com/muntsos/thinservers> and extract it to a freshly
formatted FAT32 SD card, and insert it into the target system. You can
then modify `autoexec.d/00-wlan-init` on the SD card to customize it for
your wireless network environment, if desired.

------------------------------------------------------------------------

Questions or comments to Philip Munts <phil@munts.net>

I am available for custom system development (hardware and software) of
products based on embedded Linux microcomputers or other processors.
