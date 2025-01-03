MuntsOS Embedded Linux
======================

This framework supports Linux on several single board microcomputers.
The goal of the MuntsOS project is to deliver a turnkey, RAM resident
Linux operating system for very low cost single board microcomputers.
With MuntsOS installed, such microcomputers can treated as components,
as *Linux microcontrollers*, and integrated into other projects just
like traditional single chip microcontrollers.

News
----

-   17 December 2024 -- Moved all 32-bit target deliverables (toolchain
    packages, kernels, extensions, and thin servers) to
    <http://repo.munts.com/muntsos/attic>. I did a final build of the
    32-bit target kernels with **`sysconfig`** modified to fetch
    extensions from the attic. I do not anticipate ever building the
    32-bit target kernels or thin servers again.
-   20 December 2024 -- Upgraded the Raspberry Pi kernel to 6.6.67.
    Added a new device tree overlay, **`Pi4ClickShield`**, to support
    the eponymous [mikroBUS
    shield](https://www.mikroe.com/pi-4-click-shield).
-   26 December 2024 -- Added *preliminary* support for the [Orange Pi
    Zero
    2W](http://www.orangepi.org/orangepiwiki/index.php/Orange_Pi_Zero_2W).
    I have the [U-Boot](https://www.u-boot.org) boot loader and the
    Linux mainline 6.12 LTS kernel, both with serial port console,
    working all the way to the login prompt. Much work on the kernel and
    device tree remains before MuntsOS on the Orange Pi Zero 2W is ready
    for production use.
-   28 December 2024 -- I had to drop back to the manufacturer Linux 6.1
    kernel tree for the Orange Pi Zero 2W. The Linux mainline 6.12 LTS
    tree does not have drivers for PWM outputs nor the built-in WiFi
    chipset, both of which are required for the application I have in
    mind. MuntsOS for the Orange Pi Zero 2W built on Linux 6.1 is about
    at the same point or a litte further along than what I had running
    on Linux 6.12 LTS. Most things seem to be working except HDMI and
    internal WiFi. I have been testing with a [Broadcom WiFi Adapter and
    Two Port
    Hub](https://uk.pi-supply.com/collections/dongles-hubs/products/broadcom-wifi-adapter-2-port-usb-hub-raspberry-pi)
    I got years ago for the Raspberry Pi Zero.
-   3 January 2025 -- Upgraded the Raspberry Pi Linux kernel to 6.6.69.
    Got the Orange Pi Zero 2W console on USB keyboard / HDMI monitor
    working. Modified **`/etc/inittab`** to support four virtual
    terminals on HDMI video target platforms. Changed the kernel default
    **`printk`** quiet priority level to 2, to suppress most
    **`printk`** noise to the console. Added support for importing
    settings from **`/etc/sysctl.conf`**.

Quick Setup Instructions for the Impatient
------------------------------------------

Instructions for installing the MuntsOS cross-toolchain development
environment onto a **host computer** are found in [Application Note
\#1](http://git.munts.com/muntsos/doc/AppNote1-Setup-Debian.pdf) and
[Application Note
\#2](http://git.munts.com/muntsos/doc/AppNote2-Setup-RPM.pdf). Or just
download and run one of the following quick setup scripts:

[setup-debian](http://git.munts.com/muntsos/scripts/setup-debian)  
[setup-fedora](http://git.munts.com/muntsos/scripts/setup-fedora)  
[setup-rhel](http://git.munts.com/muntsos/scripts/setup-rhel)

Instructions for installing MuntsOS to a **target computer** are found
in [Application Note
\#3](http://git.munts.com/muntsos/doc/AppNote3-Installation-from-Linux.pdf)
and [Application Note
\#15](http://git.munts.com/muntsos/doc/AppNote15-Installation-from-Windows.pdf).

Documentation
-------------

The documentation for MuntsOS (mostly application notes) is available
online at:

<http://git.munts.com/muntsos/doc>

Embedded Linux Distribution in a Kernel
---------------------------------------

MuntsOS is a stripped down Linux distribution that includes a small
compressed root file system within the kernel image binary itself. At
boot time the root file system is unpacked into RAM and thereafter the
system runs entirely in RAM.

Each kernel release tarball contains a kernel image file (**`.img`**),
which may be common to several different microcomputer boards, and one
or more [device tree](http://elinux.org/Device_Tree_Reference) files
(**`.dtb`**) that are specific to particular microcomputer boards. Some
kernel release tarballs also contain one or more device tree overlay
files (**`.dtbo`**) that can make small changes to the device tree at
boot time.

Prebuilt MuntsOS kernel release tarballs are available at:

<http://repo.munts.com/muntsos/kernels>

Extensions
----------

The MuntsOS root file system can be *extended* at boot time using any of
three mechanisms:

First, if **`/boot/tarballs`** exists, any **`gzip`**'ed tarball files
(**`.tgz`**) in it will be extracted on top of the root file system.
Typically you would use this mechanism for customized **`/etc/passwd`**,
**`.ssh/authorized_keys`**, and similiar system configuration files.

Secondly, if **`/boot/packages`** exists, any Debian package files
(**`.deb`**) in it will be installed into the root file system. Note
that packages from the [Debian](http://www.debian.org) project will
probably not work; they must be built specifically for MuntsOS. The
startup script that installs **`.deb`** packages also installs
**`.rpm`** and **`.nupkg`** packages.

The [GPIO Server](http://git.munts.com/muntsos/extensions/gpio-server)
extension package demonstrates how to build a Debian package that adds
application specific software to MuntsOS.

Thirdly, the system startup script **`/etc/rc`** can be configured via a
kernel command line option to search for a subdirectory called
**`autoexec.d`** in various places, such as SD card, USB flash drive,
USB CD-ROM or NFS mount. If an **`autoexec.d`** subdirectory is found,
each executable program or script in it will be executed when the system
boots.

The idea is to build a MuntsOS kernel (which takes a long time) once and
install it to the target platform. Then application specific software
can be built after the fact and installed as tarball files in
**`/boot/tarballs`**; Debian, RPM, and NuGet package files in
**`/boot/packages`**; or executable programs and scripts in
**`/boot/autoexec.d`**.

Prebuilt MuntsOS extension packages are available at:

<http://repo.munts.com/muntsos/extensions>

Thin Servers
------------

### Boot Files + Kernel Files + Extensions = Thin Server

The *Thin Server* is a system design pattern that is little more than a
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
one of the prebuilt Thin Server **`.zip`** files and extract it to a
freshly formatted FAT32 SD card. You can then modify
**`autoexec.d/00-wlan-init`** on the SD card to pre-configure it for
your wireless network environment, if desired, before inserting it in
the target board. After booting MuntsOS, log in from the console or via
SSH (user "**`root`**", password "**`default`**") and run
**`sysconfig`** to perform more system configuration.

*Note: Some platforms require the [boot
flag](https://en.wikipedia.org/wiki/Boot_flag) to be set on the FAT32
boot partition on the SD card or on-board eMMC. The ROM boot loader in
the CPU will ignore any partitions that are not marked as bootable.*

MuntsOS Application Notes
[3](http://git.munts.com/muntsos/doc/AppNote3-Installation-from-Linux.pdf)
and
[15](http://git.munts.com/muntsos/doc/AppNote15-Installation-from-Windows.pdf)
contain more detailed instructions about how to install a MuntsOS Thin
Server.

Prebuilt MuntsOS Thin Servers are at available at:

<http://repo.munts.com/muntsos/thinservers>

Boards
------

### Orange Pi Zero 2W

The [Orange Pi Zero
2W](http://www.orangepi.org/orangepiwiki/index.php/Orange_Pi_Zero_2W) is
a small Linux microcomputer with a form factor very similiar to the
[Raspberry Pi Zero 2
W](https://www.raspberrypi.com/products/raspberry-pi-zero-2-w/), making
it ideal for embedded system projects. It has a 1500 MHz Allwinner H618
Cortex-A53 quad-core CPU and comes with 1 to 4 GB of RAM and on-board
Bluetooth and WiFi radios. It is available for sale on Amazon for $21.99
(1 GB RAM) to $33.99 (4 GB RAM).

The much larger RAM is a big advantage and I have been able to purchase
as many as I want without limits when the Raspberry Pi Zero 2 W has been
unavailable. Unfortunately, the manufacturer [kernel source
tree](https://github.com/orangepi-xunlong/linux-orangepi/tree/orange-pi-6.1-sun50iw9)
has not been maintained regularly and is currently at 6.1.31.

### Raspberry Pi

The [Raspberry Pi](http://www.raspberrypi.com) is a family of low cost
Linux microcomputers selling for USD $15 to $80, depending on model.
There have been five generations of Raspberry Pi microcomputers, each
using a successively more sophisticated Broadcom ARM core CPU. The first
two generations (32-bit ARMv6 Raspberry Pi 1 and 32-bit ARMv7 Raspberry
Pi 2) are now obsolete.

Some Raspberry Pi models have an on-board Bluetooth radio that uses the
serial port signals that are also brought out to the expansion header.
By default, MuntsOS port disables the on-board Bluetooth radio, in favor
of the serial port on the expansion header.

All of the following 64-bit Raspberry Pi models use the same AArch64
cross-toolchain.

#### Raspberry Pi 3

The [Raspberry Pi 2 Model
B](https://www.raspberrypi.com/products/raspberry-pi-2-model-b) Revision
1.2 with the 900 MHz BCM2710 ARMv8 Cortex-A53 quad-core CPU can be
treated as a power conserving Raspberry Pi 3 Model B− and is useful for
industrial applications where wired Ethernet is preferred.

The [Rasbperry Pi 3 Model
B](https://www.raspberrypi.com/products/raspberry-pi-3-model-b) has a
1200 MHz BCM2710 ARMv8 Cortex-A53 quad-core CPU and has 1 GB of RAM
along with on-board Bluetooth and WiFi radios.

The [Raspberry Pi 3 Model
A+](https://www.raspberrypi.com/products/raspberry-pi-3-model-a-plus)
has the same form factor as the Raspberry Pi 1 Model A+, with only one
USB host port and no wired Ethernet. It has a 1400 MHz BCM2710 ARMv8
Cortex-A53 quad-core CPU and has 512 MB of RAM along with on-board
Bluetooth and WiFi radios.

The [Raspberry Pi 3 Model
B+](https://www.raspberrypi.com/products/raspberry-pi-3-model-b-plus)
has a 1400 MHz BCM2710 ARMv8 Cortex-A53 quad-core CPU and has improved
power management and networking components.

The [Raspberry Pi Zero 2
W](https://www.raspberrypi.com/products/raspberry-pi-zero-2-w) has the
same form factor as the Raspberry Pi Zero W, with a 1000 MHz BCM2710
ARMv8 Cortex-A53 quad core CPU and 512 MB of RAM along with on-board
Bluetooth and WiFi radios. This small, light, and inexpensive board is
probably one of the best Linux microcomputers available for implementing
embedded systems.

All Raspberry Pi 3 models use the same ARMv8 kernel, with different
device trees.

#### Raspberry Pi 4

The [Raspberry Pi 4 Model
B](https://www.raspberrypi.com/products/raspberry-pi-4-model-b) has a
1500 MHz BCM2711 ARMv8 Cortex-A72 quad-core CPU and is available with 1
to 8 GB of RAM. It diverged significantly from the Raspberry Pi 1 B+
form factor, with the USB and Ethernet ports reversed, two micro-HDMI
connectors instead of a single full size HDMI connector, and a USB-C
power connector instead of micro-USB. Two of the USB ports are 3.0 and
two are 2.0. A major improvement is a Gigabit Ethernet controller
connected via PCI Express instead of the USB connected Ethernet used for
all earlier models. The Raspberry Pi 4 Model B uses the same wireless
chip set as the 3+.

There are also a myriad of [Raspberry Pi 4 Compute
Modules](https://www.raspberrypi.com/products/compute-module-4), with
varying combinations of wireless Ethernet, RAM and eMMC.

All Raspberry Pi 4 models use the same ARMv8 kernel, with different
device trees.

#### Raspberry Pi 5

The [Raspberry Pi
5](https://www.raspberrypi.com/products/raspberry-pi-5) yields another
2-3x increase in performance over the Raspberry Pi 4, at the expense of
greater power consumption. It has a 2400 MHz BCM2712 ARMv8 Cortex-A76
quad-core CPU and is available with 4 or 8 GB of RAM. The Ethernet
socket and USB ports have swapped sides, so it has a form factor that is
sort of a cross between the Raspberry Pi 1 B+ (same grouping of Ethernet
and USB ports) and the Raspberry Pi 4 (same dual micro-HDMI sockets and
USB-C power socket).

There are also a myriad of [Raspberry Pi 5 Compute
Modules](https://www.raspberrypi.com/products/compute-module-5), with
varying combinations of wireless Ethernet, RAM and eMMC.

All Raspberry Pi 5 models use the same ARMv8 kernel, with different
device trees.

The Raspberry Pi 5 introduced a breaking GPIO API change. See
[Application Note
\#11](http://git.munts.com/muntsos/doc/AppNote11-link-gpiochip.pdf) for
more information.

The Raspberry Pi 5 also introduced a breaking PWM API change. It has
four hardware PWM outputs with different pin mapping. Notably, PWM chip
2 channel 2 is mapped to GPIO18 instead of PWM chip 0 channel 0 on
previous Raspberry Pi boards. See [RP1
Peripherals](https://datasheets.raspberrypi.com/rp1/rp1-peripherals.pdf)
page 15 for more information.

#### Raspberry Pi USB Gadget Kernels

MuntsOS also provides Raspberry Pi kernels with dedicated [USB
Gadget](http://www.linux-usb.org/gadget) support enabled. These kernels
run on 3 A+, CM3, Zero 2 W, 4 B, and CM4. You can supply power to and
communicate with a compatible Raspberry Pi solely through the USB port.
This kernel supports USB Network, Raw HID, and Serial Port gadgets,
selected by bits in the **`OPTIONS`** word passed on the kernel command
line. The USB Gadget Thin Servers have USB Network Gadget selected by
default.

The absolute minimum possible usable Raspberry Pi kit consists of a
Raspberry Pi Zero 2 W, a micro-USB cable, and a micro-SD card with one
of the MuntsOS Raspberry Pi 3 USB Gadget Thin Servers installed.

Cross-Toolchains
----------------

I build a custom Ada/C/C++/Fortran/Go/Modula-2 GCC cross-toolchain for
each MuntsOS platform family. Each GCC cross-toolchain requires a number
of additional software component libraries, which are packaged and
distributed separately but installed into the same directory tree as the
parent cross-toolchain. I also build [Free
Pascal](https://www.freepascal.org) cross-compilers. Each of these rely
on the libraries contained in the corresponding GCC cross-toolchain
package.

Cross-toolchain packages built for [Debian](https://www.debian.org)
Linux (x86-64 *and* ARM64) development host computers are available at
either:

<http://repo.munts.com/debian12> (Debian package repository)  
<http://repo.munts.com/muntsos/toolchain-debs> (just the package files).

x86-64 RPM packages containing the exact same binaries and known to work
on Fedora 40 and RHEL 9.1 and its derivatives are available at:

<http://repo.munts.com/muntsos/toolchain-rpms>

[Alire](https://alire.ada.dev) Crates
-------------------------------------

[![muntsos\_aarch64](https://img.shields.io/endpoint?url=https://alire.ada.dev/badges/muntsos_aarch64.json)](https://alire.ada.dev/crates/muntsos_aarch64.html)

Adding **`muntsos_aarch64`** to an Alire Ada program project turns it
into one that produces a cross-compiled AArch64/ARMv8 program for
MuntsOS. See [Application Note
\#7](http://git.munts.com/muntsos/doc/AppNote7-Flash-LED-Ada-Alire.pdf)
for a complete example using the **`alr`** command line tool.

Please note that none of the other MuntsOS library crates in Alire
(*e.g.* **muntsos\_beaglebone**) are useable due to breaking changes in
**`alr`** 2.0. Unfortunately, Alire project policies prohibit removing
obsolete crates, so **muntsos\_beaglebone** *et al* remain in the
repository as broken and abandoned orphans.

[Microsoft .Net](https://dotnet.microsoft.com)
----------------------------------------------

[![libsimpleio](https://img.shields.io/nuget/v/libsimpleio?style=flat&logo=nuget&label=libsimpleio)](https://www.nuget.org/packages/libsimpleio)
[![libsimpleio-templates](https://img.shields.io/nuget/v/libsimpleio-templates?style=flat&logo=nuget&label=libsimpleio-templates)](https://www.nuget.org/packages/libsimpleio-templates)

With the **`dotnet`** extension installed, MuntsOS can run architecture
independent .Net programs produced by **`dotnet build`**,
**`dotnet publish`**, **`dotnet pack`** or the equivalent actions in
[Microsoft Visual Studio](https://visualstudio.microsoft.com). Many if
not most of the library packages published on
[Nuget](https://www.nuget.org) can be used in such programs.

The NuGet library package
[libsimpleio](https://www.nuget.org/packages/libsimpleio) provides
**`libsimpleio.dll`**, a .Net Standard 2.0 library assembly that binds
to the Linux shared library **`libsimpleio.so`** that is an integral
part of MuntsOS. The NuGet library package
[libsimpleio-templates](https://www.nuget.org/packages/libsimpleio)
provides a .Net Core console application project template
**`csharp_console_libsimpleio`** that, while not strictly necessary,
greatly simplifies creating an embedded system .Net Core console
application project for MuntsOS.

See [Application Note
\#8](http://git.munts.com/muntsos/doc/AppNote8-Flash-LED-C%23.pdf) for a
complete example using C\# to flash an LED. See also the [API
specification](http://tech.munts.com/libsimpleio.dll) for
**`libsimpleio.dll`**.

The combination of Visual Studio + NuGet + libsimpleio provides a very
high productivity development environment for creating embedded systems
software to run on MuntsOS. With [RemObjects
Elements](https://www.remobjects.com/elements), a commercial Visual
Studio addon product, you can even compile Object Pascal, Java, Go, and
Swift programs, all using **`libsimpleio.dll`**, to .Net program
assemblies that run on MuntsOS.

Git Repository
--------------

The source code for MuntsOS is available at:

<https://github.com/pmunts/muntsos>

Use the following command to clone it:

    git clone https://github.com/pmunts/muntsos.git

File Repository
---------------

Prebuilt binaries for MuntsOS (extensions, kernels, thin servers, and
cross-toolchain packages) are available at:

<http://repo.munts.com/muntsos>

------------------------------------------------------------------------

Questions or comments to Philip Munts <phil@munts.net>
