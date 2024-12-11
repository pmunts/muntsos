MuntsOS Embedded Linux

This framework supports Linux on several single board microcomputers.
The goal of the MuntsOS project is to deliver a turnkey, RAM resident
Linux operating system for very low cost single board microcomputers.
With MuntsOS installed, such microcomputers can treated as components,
as Linux microcontrollers, and integrated into other projects just like
traditional single chip microcontrollers.

News

-   1 January 2024 -- I have suspended development for 32-bit target
    platforms. The 32-bit BeagleBone kernel is frozen at 5.4.106. The
    32-bit Raspberry Pi 1 and 2 kernels are frozen at 5.15.92. The
    muntsos-dev package has been updated to only pull in 64-bit
    AArch64/ARMv8 toolchains. The 32-bit target platform deliverables
    (toolchains, kernels, extensions, thin servers etc.) will be left in
    the repositories until the end of the year.
-   30 July 2024 -- Upgraded OpenSSL to 3.3.1, curl to 8.9.0, libtirpc
    to 1.3.5, libnl to 3.10.0, libsodium to 1.0.20, gdbm to 1.24, and xz
    to 5.6.2. Upgraded .Net Runtime to 8.0.7, OpenSSH to 9.8p1, rpcbind
    to 1.2.7, and nano to 8.1. Upgraded the 64-bit Raspberry Pi kernel
    to 6.6.42.
-   22 November 2024 -- Upgraded the .Net Runtime extension to 9.0.0.
-   24 November 2024 -- Upgraded some library components: OpenSSL to
    3.4.0, icu to 76.1, curl to 8.11.0, libtirpc to 1.3.6, libpcap to
    1.10.5, libnl to 3.11.0, libmysqlclient (MariaDB Connector/C) to
    3.4.3, rabbitmq to 0.15.0, libmodbus to 3.1.11, and xz to 5.6.3.
-   25 November 2024 -- Upgraded some initramfs programs: OpenSSH to
    9.9p1, ethtool to 6.11, and nano to 8.2. Added iw. Upgraded the
    Python runtime extension to 3.13.0.
-   26 November 2024 -- Upgraded Raspberry Pi 64-bit kernels to 6.6.63.
-   11 December 2024 -- Upgraded Raspberry Pi 64-bit kernels to 6.6.64.
    Added initial support for Raspberry Pi Compute Module 5.

Quick Setup Instructions for the Impatient

Instructions for installing the MuntsOS cross-toolchain development
environment onto a host computer are found in Application Note #1 and
Application Note #2. Or just download and run one of the following quick
setup scripts:

setup-debian
setup-fedora
setup-rhel

Instructions for installing MuntsOS to a target computer are found in
Application Note #3 and Application Note #15.

Documentation

The documentation for MuntsOS (mostly application notes) is available
online at:

http://git.munts.com/muntsos/doc

Embedded Linux Distribution in a Kernel

MuntsOS is a stripped down Linux distribution that includes a small
compressed root file system within the kernel image binary itself. At
boot time the root file system is unpacked into RAM and thereafter the
system runs entirely in RAM.

Each kernel release tarball contains a kernel image file (.img), which
may be common to several different microcomputer boards, and one or more
device tree files (.dtb) that are specific to particular microcomputer
boards. Some kernel release tarballs also contain one or more device
tree overlay files (.dtbo) that can make small changes to the device
tree at boot time.

Prebuilt MuntsOS kernel release tarballs are available at:

http://repo.munts.com/muntsos/kernels

Extensions

The MuntsOS root file system can be extended at boot time using any of
three mechanisms:

First, if /boot/tarballs exists, any gzip'ed tarball files (.tgz) in it
will be extracted on top of the root file system. Typically you would
use this mechanism for customized /etc/passwd, .ssh/authorized_keys, and
similiar system configuration files.

Secondly, if /boot/packages exists, any Debian package files (.deb) in
it will be installed into the root file system. Note that packages from
the Debian project will probably not work; they must be built
specifically for MuntsOS. The startup script that installs .deb packages
also installs .rpm and .nupkg packages.

The GPIO Server extension package demonstrates how to build a Debian
package that adds application specific software to MuntsOS.

Thirdly, the system startup script /etc/rc can be configured via a
kernel command line option to search for a subdirectory called
autoexec.d in various places, such as SD card, USB flash drive, USB
CD-ROM or NFS mount. If an autoexec.d subdirectory is found, each
executable program or script in it will be executed when the system
boots.

The idea is to build a MuntsOS kernel (which takes a long time) once and
install it to the target platform. Then application specific software
can be built after the fact and installed as tarball files in
/boot/tarballs; Debian, RPM, and NuGet package files in /boot/packages;
or executable programs and scripts in /boot/autoexec.d.

Prebuilt MuntsOS extension packages are available at:

http://repo.munts.com/muntsos/extensions

Thin Servers

Boot Files + Kernel Files + Extensions = Thin Server

The Thin Server is a system design pattern that is little more than a
network interface for a single I/O device. Ideally, a Thin Server will
be built from a cheap and ubiquitous network microcomputer like the
Raspberry Pi. The software must be easy to install from a user's PC or
Mac without requiring any special programming tools. It must be able to
run headless, administered via the network. It must be able to survive
without orderly shutdowns, and must not write much to flash media. It
must provide a network based API (Application Programming Interface)
using HTTP as a lowest common denominator.

MuntsOS, with its operating system running entirely from RAM, serves
well for the Thin Server, and the two concepts have evolved together
over the past few years. The simplest way to use MuntsOS is to download
one of the prebuilt Thin Server .zip files and extract it to a freshly
formatted FAT32 SD card. You can then modify autoexec.d/00-wlan-init on
the SD card to pre-configure it for your wireless network environment,
if desired, before inserting it in the target board. After booting
MuntsOS, log in from the console or via SSH (user "root", password
"default") and run sysconfig to perform more system configuration.

Note: Some platforms require the boot flag to be set on the FAT32 boot
partition on the SD card or on-board eMMC. The ROM boot loader in the
CPU will ignore any partitions that are not marked as bootable.

MuntsOS Application Notes 3 and 15 contain more detailed instructions
about how to install a MuntsOS Thin Server.

Prebuilt MuntsOS Thin Servers are at available at:

http://repo.munts.com/muntsos/thinservers

Boards

Raspberry Pi

The Raspberry Pi is a family of low cost Linux microcomputers selling
for USD $15 to $80, depending on model. There have been five generations
of Raspberry Pi microcomputers, each using a successively more
sophisticated Broadcom ARM core CPU. The first two generations (32-bit
ARMv6 Raspberry Pi 1 and 32-bit ARMv7 Raspberry Pi 2) are now obsolete.

Some Raspberry Pi models have an on-board Bluetooth radio that uses the
serial port signals that are brought out to the expansion header. By
default, MuntsOS port disables the on-board Bluetooth radio, in favor of
the serial port on the expansion header.

Raspberry Pi 3

The 64-bit Raspberry Pi 2 Model B Revision 1.2 with the 900 MHz BCM2710
ARMv8 Cortex-A53 quad-core CPU can be treated as a power conserving
Raspberry Pi 3 Model B− and is useful for industrial applications where
wired Ethernet is preferred.

The Rasbperry Pi 3 Model B has a 1200 MHz BCM2710 ARMv8 Cortex-A53
quad-core CPU and has 1 GB of RAM along with on-board Bluetooth and WiFi
radios.

The Raspberry Pi 3 Model A+ has the same form factor as the Raspberry Pi
1 Model A+, with only one USB host port and no wired Ethernet. It has a
1400 MHz BCM2710 ARMv8 Cortex-A53 quad-core CPU and has 512 MB of RAM
along with on-board Bluetooth and WiFi radios.

The Raspberry Pi 3 Model B+ has a 1400 MHz BCM2710 ARMv8 Cortex-A53
quad-core CPU and has improved power management and networking
components.

The Raspberry Pi Zero 2 W has the same form factor as the Raspberry Pi
Zero W, with a 1000 MHz BCM2710 ARMv8 Cortex-A53 quad core CPU and 512
MB of RAM along with on-board Bluetooth and WiFi radios.

All Raspberry Pi 3 models use the same AArch64 toolchain and ARMv8
kernels, but different device trees.

Raspberry Pi 4

The Raspberry Pi 4 Model B has a 1500 MHz BCM2711 ARMv8 Cortex-A72
quad-core CPU and is available with 1 to 8 GB of RAM. It diverged
significantly from the Raspberry Pi 1 B+ form factor, with the USB and
Ethernet ports reversed, two micro-HDMI connectors instead of a single
full size HDMI connector, and a USB-C power connector instead of
micro-USB. Two of the USB ports are 3.0 and two are 2.0. A major
improvement is a Gigabit Ethernet controller connected via PCI Express
instead of the USB connected Ethernet used for all earlier models. The
Raspberry Pi 4 Model B uses the same wireless chip set as the 3+.

There are also a myriad of Raspberry Pi 4 Compute Modules, with varying
combinations of wireless Ethernet, RAM and eMMC.

All Raspberry Pi 4 models use the same AArch64 toolchain and ARMv8
kernels, but different device trees.

Raspberry Pi 5

The Raspberry Pi 5 yields another 2-3x increase in performance over the
Raspberry Pi 4, at the expense of greater power consumption. It has a
2400 MHz BCM2712 ARMv8 Cortex-A76 quad-core CPU and is available with 4
or 8 GB of RAM. The Ethernet socket and USB ports have swapped sides, so
it has a form factor that is sort of a cross between the Raspberry Pi 1
B+ (same grouping of Ethernet and USB ports) and the Raspberry Pi 4
(same dual micro-HDMI sockets and USB-C power socket).

There are also a myriad of Raspberry Pi 5 Compute Modules, with varying
combinations of wireless Ethernet, RAM and eMMC.

All Raspberry Pi 5 models use the same AArch64 toolchain and ARMv8
kernels, but different device trees.

The Raspberry Pi 5 introduced a breaking GPIO API change. See
Application Note #11 for more information.

The Raspberry Pi 5 also introduced a breaking PWM API change. It has
four hardware PWM outputs, but the pin mapping has changed as well.
Notably, channel 2 is mapped to GPIO18 instead of channel 0 on previous
Raspberry Pi boards. See RP1 Peripherals page 15 for more information.

Raspberry Pi USB Gadget Kernels

MuntsOS also provides Raspberry Pi kernels with dedicated USB Gadget
support enabled. These kernels run on 3 A+, CM3, Zero 2 W, 4 B, and CM4.
You can supply power to and communicate with a compatible Raspberry Pi
solely through the USB port. This kernel supports USB Network, Raw HID,
and Serial Port gadgets, selected by bits in the OPTIONS word passed on
the kernel command line. The USB Gadget Thin Servers have USB Network
Gadget selected by default.

The absolute minimum possible usable Raspberry Pi kit consists of a
Raspberry Pi Zero 2 W, a micro-USB cable, and a micro-SD card with one
of the MuntsOS Raspberry Pi 3 USB Gadget Thin Servers installed.

Cross-Toolchains

I build a custom Ada/C/C++/Fortran/Go/Modula-2 GCC cross-toolchain for
each MuntsOS platform family. Each GCC cross-toolchain requires a number
of additional software component libraries, which are packaged and
distributed separately but installed into the same directory tree as the
parent cross-toolchain. I also build Free Pascal cross-compilers. Each
of these rely on the libraries contained in the corresponding GCC
cross-toolchain package.

Cross-toolchain packages built for Debian Linux (x86-64 and ARM64)
development host computers are available at either:

http://repo.munts.com/debian12 (Debian package repository) or
http://repo.munts.com/muntsos/toolchain-debs (just the package files).

x86-64 RPM packages containing the exact same binaries and known to work
on Fedora 40 and RHEL 9.1 and its derivatives are available at:

http://repo.munts.com/muntsos/toolchain-rpms

Debian Package Repository

Prebuilt cross-toolchain packages for Debian Linux are available at:

http://repo.munts.com/debian12

File Repository

Prebuilt binaries for MuntsOS are available at:

http://repo.munts.com/muntsos

Git Repository

The source code for MuntsOS is available at:

https://github.com/pmunts/muntsos

Use the following command to clone it:

git clone https://github.com/pmunts/muntsos.git

------------------------------------------------------------------------

Questions or comments to Philip Munts phil@munts.net
