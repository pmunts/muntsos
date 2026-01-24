# **MuntsOS** Embedded Linux

**MuntsOS** is a *ferociously* reduced Linux distribution for **embedded
systems**. It runs on several microcomputer boards, including all 64-bit
[Raspberry Pi](https://www.raspberrypi.com) models, providing a turnkey
RAM resident Linux operating system. With **MuntsOS** installed, a small
and low cost Linux microcomputer becomes a *Linux microcontroller*, and
can be integrated into an embedded system just like a single chip
microcontroller but coming with a much, much richer development
ecosystem.

Other embedded system Linux distributions such as
[Buildroot](https://buildroot.org) or [Yocto
Linux](https://www.yoctoproject.org) are *very* cumbersome and have
*very* steep learning curves. If you are building a test fixture or
process controller or almost any other embedded system that contains a
Raspberry Pi board, **MuntsOS** offers a very high productivity
development environment and a very easy to deploy target operating
system.

**MuntsOS** always includes the shared library **`libsimpleio.so`** from
the [Linux Simple I/O Library](https://github.com/pmunts/libsimpleio),
which facilitates building embedded system programs for **MuntsOS**
target computers using Ada, C, C++, Fortran, Go, Free Pascal, Java,
Modula-2, .Net, and Python3 programming languages.

Shared libraries for [libgpiod](https://libgpiod.readthedocs.io) are
available for **MuntsOS** target computers by installing the
**`libgpiod1`** or **`libgpiod2`** extension packages.

## News

- 6 January 2026 -- Upgraded the Raspberry Pi kernel to 6.12.63. Added
  extension package libpaho-mqtt3. Added an Ada binding to Paho MQTT C
  to the Linux Simple I/O Library.

- 14 January 2026 -- Upgraded the .Net Runtime to 10.0.2.

- 24 January 2026 -- I abandoned support for Java on **MuntsOS** in 2020
  after Oracle ended support for [Java SE
  Embedded](https://www.oracle.com/java/technologies/javase-embedded/javase-embedded.html)
  in 2019. I have now added a new *experimental* Java Runtime extension
  package for **MuntsOS** AArch64 targets, built with **`jlink`**, from
  the OpenJDK 25.0.2 AArch64 release. The Java bindings in the Linux
  Simple I/O Library are incomplete and remain in the
  [attic](https://github.com/pmunts/libsimpleio/tree/master/attic). I
  will be working on those bindings for awhile to see if supporting Java
  will be worthwhile.

## Quick Setup Instructions for the Impatient

Instructions for installing the **MuntsOS** cross-toolchain development
environment onto a development **host computer** are found in
[Application Note
\#1](https://repo.munts.com/muntsos/doc/AppNote1-Setup-Debian.pdf),
[Application Note
\#2](https://repo.munts.com/muntsos/doc/AppNote2-Setup-RPM.pdf), or
[Application Note
\#24](https://repo.munts.com/muntsos/doc/AppNote24-Setup-Win64.pdf). Or
just download and run one of the following quick setup scripts:

[setup-debian](https://repo.munts.com/muntsos/scripts/setup-debian)  
[setup-fedora](https://repo.munts.com/muntsos/scripts/setup-fedora)  
[setup-rhel  
](https://repo.munts.com/muntsos/scripts/setup-rhel)
[setup-win64.bat](https://repo.munts.com/muntsos/scripts/setup-win64.bat)

Instructions for installing **MuntsOS** to a **target computer** are
found in [Application Note
\#3](https://repo.munts.com/muntsos/doc/AppNote3-Installation-from-Linux.pdf)
and [Application Note
\#15](https://repo.munts.com/muntsos/doc/AppNote15-Installation-from-Windows.pdf).

## Documentation

The documentation for **MuntsOS** (mostly application notes) is
available online at:

<https://repo.munts.com/muntsos/doc>

## Embedded Linux Distribution in a Kernel

**MuntsOS** is a stripped down Linux distribution that includes a small
compressed root file system within the kernel image binary itself. At
boot time the root file system is unpacked into RAM and thereafter the
system runs entirely in RAM. After **MuntsOS** has finished booting, it
unmounts the boot media, so you don't have to worry about an orderly
shutdown. Just power off the microcomputer board whenever you want to.

Each kernel release tarball contains a kernel image file (**`.img`**),
which may be common to several different microcomputer boards, and one
or more [device tree](https://elinux.org/Device_Tree_Reference) files
(**`.dtb`**) that are specific to particular microcomputer boards. Some
kernel release tarballs also contain one or more device tree overlay
files (**`.dtbo`**) that can make small changes to the device tree at
boot time.

Prebuilt **MuntsOS** kernel release tarballs are available at:

<https://repo.munts.com/muntsos/kernels>

## Extensions

The **MuntsOS** root file system can be *extended* at boot time using
any of three mechanisms:

First, if **`/boot/tarballs`** exists, any **`gzip`**'ed tarball files
(**`.tgz`**) in it will be extracted on top of the root file system.
Typically you would use this mechanism for customized **`/etc/passwd`**,
**`.ssh/authorized_keys`**, and similiar system configuration files.

Secondly, if **`/boot/extensions`** exists, any Debian package files
(**`.deb`**) in it will be installed into the root file system. Note
that packages from the [Debian](https://www.debian.org) project will
probably not work; they must be built specifically for **MuntsOS**. The
startup script that installs **`.deb`** packages from
**`/boot/extensions`** also installs **`.nupkg`** and **`.rpm`**
packages as well as self-contained executable extension programs (*e.g.*
**`remoteio_server-aarch64`**).

Thirdly, the system startup script **`/etc/rc`** can be configured via a
kernel command line option to search for a subdirectory called
**`autoexec.d`** in various places, such as SD card, USB flash drive,
USB CD-ROM or NFS mount. If an **`autoexec.d`** subdirectory is found,
each executable program or script in it will be executed when the system
boots.

The idea is to build a **MuntsOS** kernel (which takes a long time) once
and install it to the target platform. Then application specific
software can be built after the fact and installed as tarball files in
**`/boot/tarballs`**; Debian, RPM, and NuGet package files or executable
extension programs in **`/boot/extensions`**; or executable programs and
scripts in **`/boot/autoexec.d`**.

Prebuilt **MuntsOS** extension packages are available at:

<https://repo.munts.com/muntsos/extensions>

## Thin Servers

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

**MuntsOS**, with its operating system running entirely from RAM, serves
well for the Thin Server, and the two concepts have evolved together
over the past few years. The simplest way to use **MuntsOS** is to
download one of the prebuilt Thin Server **`.zip`** files and extract it
to a freshly formatted FAT32 SD card. You can then modify
**`autoexec.d/00-wlan-init`** on the SD card to pre-configure it for
your wireless network environment, if desired, before inserting it in
the target board. After booting **MuntsOS**, log in from the console or
via SSH (user "**`root`**", password "**`default`**") and run
**`sysconfig`** to perform more system configuration.

*Note: Some platforms require the [boot
flag](https://en.wikipedia.org/wiki/Boot_flag) to be set on the FAT32
boot partition on the SD card or on-board eMMC. The ROM boot loader in
the CPU will ignore any partitions that are not marked as bootable.*

**MuntsOS** Application Notes
[3](https://repo.munts.com/muntsos/doc/AppNote3-Installation-from-Linux.pdf)
and
[15](https://repo.munts.com/muntsos/doc/AppNote15-Installation-from-Windows.pdf)
contain more detailed instructions about how to install a **MuntsOS**
Thin Server.

Prebuilt **MuntsOS** Thin Servers are at available at:

<https://repo.munts.com/muntsos/thinservers>

## Boards

### BeaglePlay

The [BeaglePlay](https://www.beagleboard.org/boards/beagleplay) is a
small Linux microcomputer board with industry standard interfaces for
add-on I/O modules (a [mikroBUS](https://www.mikroe.com/mikrobus)
socket, a [QWIIC](https://www.sparkfun.com/qwiic) socket, and a
[Grove](https://wiki.seeedstudio.com/Grove_System) socket) instead of a
general purpose expansion header. It has a Texas Instruments AM6254
ARMv8 Cortex-A53 quad core CPU and comes with 2 GB of RAM. The
BeaglePlay has one USB-A receptacle for peripheral devices and one USB-C
receptacle for power and tethering. It has a 10/100/1000BASE-T wired
Ethernet interface, a
[10BASE-T1L](https://www.analog.com/en/resources/technical-articles/the-new-10base-t1l-standard.html)
single pair Ethernet interface (intended for a factory automation
network and worthless for any other purpose), and a
[CC1352P7](https://www.ti.com/product/CC1352P) wireless microcontroller
capable of supporting a wide variety of radio networks. For more
information read the target platform notes in [Application Note
\#19](https://repo.munts.com/muntsos/doc/AppNote19-BeaglePlay.pdf).

The BeaglePlay has a couple of serious design defects: The AM6254 CPU
hardware watchdog timers are unusable and the
[ADC102S051](https://www.ti.com/product/ADC102S051) A/D converter has
only 10 bit resolution and lacks a Linux kernel driver. Furthermore, the
manufacturer [kernel source
repository](https://github.com/beagleboard/linux) does not often pull
changes from the corresponding stable or longterm kernel trees and
therefore lacks many upstream changes.

##### USB Gadgets

You will need to edit **`/boot/config.txt`** to enable USB Gadget mode.
Change the **`OPTIONS`** word to **`0x172C`** for a USB HID gadget,
**`0x072E`** for a USB Ethernet gadget, or **`0x03AC`** for a USB serial
port gadget. See [Application Note
\#10](https://repo.munts.com/muntsos/doc/AppNote10-OPTIONS.pdf) for more
information about the **`OPTIONS`** word.

### Orange Pi Zero 2W

The [Orange Pi Zero
2W](http://www.orangepi.org/orangepiwiki/index.php/Orange_Pi_Zero_2W) is
a small Linux microcomputer with a form factor very similiar to the
[Raspberry Pi Zero 2
W](https://www.raspberrypi.com/products/raspberry-pi-zero-2-w), making
it ideal for embedded system projects. It has a 1500 MHz Allwinner H618
ARMv8 Cortex-A53 quad-core CPU and comes with 1 to 4 GB of RAM and
on-board Bluetooth and WiFi radios. It is available for sale on Amazon
for \$21.99 (1 GB RAM) to \$33.99 (4 GB RAM). See [Application Note
\#20](https://repo.munts.com/muntsos/doc/AppNote20-OrangePiZero2W.pdf)
for more information.

The much larger RAM is a big advantage and I have been able to purchase
as many as I want without limits when the Raspberry Pi Zero 2 W has been
unavailable. Unfortunately, the manufacturer [kernel source
repository](https://github.com/orangepi-xunlong/linux-orangepi/tree/orange-pi-6.1-sun50iw9)
has not been maintained and is currently frozen at 6.1.31.

##### USB Gadgets

You will need to edit **`/boot/config.txt`** to enable USB Gadget mode.
Change the **`OPTIONS`** word to **`0x172C`** for a USB HID gadget,
**`0x072E`** for a USB Ethernet gadget, or **`0x03AC`** for a USB serial
port gadget. See [Application Note
\#10](https://repo.munts.com/muntsos/doc/AppNote10-OPTIONS.pdf) for more
information about the **`OPTIONS`** word.

### Raspberry Pi

The [Raspberry Pi](https://www.raspberrypi.com) is a family of low cost
Linux microcomputers selling for USD \$15 to \$80, depending on model.
There have been five generations of Raspberry Pi microcomputers, each
using a successively more sophisticated Broadcom ARM core CPU. The first
two generations (32-bit ARMv6 Raspberry Pi 1 and 32-bit ARMv7 Raspberry
Pi 2) are now obsolete.

Some Raspberry Pi models have an on-board Bluetooth radio that uses the
serial port signals that are also brought out to the expansion header.
By default, **MuntsOS** disables the on-board Bluetooth radio, in favor
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
USB host receptacle and no wired Ethernet. It has a 1400 MHz BCM2710
ARMv8 Cortex-A53 quad-core CPU and has 512 MB of RAM along with on-board
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

##### USB Gadgets

**MuntsOS** also offers a second, different Raspberry Pi 3 kernel with
USB host support disabled and [USB
Gadget](http://www.linux-usb.org/gadget) peripheral support enabled.
This kernel only runs on 3 A+, Zero 2 W, and certain CM3 carrier boards
which lack the USB hub present on Raspberry Pi 3 Model B and B+ boards.
The single USB controller that is part of the BCM2710 CPU is wired
directly to the USB-A receptacle on the 3 A+ or the USB Micro-A
receptacle on the CM3 I/O board or the Raspberry Pi Zero 2 W.

The Raspberry Pi 3 USB Gadget kernel supports USB Ethernet, Raw HID, and
Serial Port gadgets, selected by bits in the **`OPTIONS`** word passed
on the kernel command line (as configured in **`/boot/cmdline.txt`**).
See [Application Note
\#10](https://repo.munts.com/muntsos/doc/AppNote10-OPTIONS.pdf) for more
information about the **`OPTIONS`** word. Raspberry Pi 3 USB Gadget Thin
Servers have USB Network Gadget selected by default.

You can supply power to and communicate with a compatible Raspberry Pi 3
(A+, CM3, or Zero 2W) running the USB Gadget kernel through the USB
receptacle. The absolute minimum possible usable Raspberry Pi kit
consists of a Raspberry Pi Zero 2 W, a micro-USB cable, and a micro-SD
card with one of the **MuntsOS** Raspberry Pi 3 USB Gadget Thin Servers
installed.

#### Raspberry Pi 4

The [Raspberry Pi 4 Model
B](https://www.raspberrypi.com/products/raspberry-pi-4-model-b) has a
1500 MHz BCM2711 ARMv8 Cortex-A72 quad-core CPU and is available with 1
to 8 GB of RAM. It diverged significantly from the Raspberry Pi 1 B+
form factor, with the USB and Ethernet receptacles reversed, two
micro-HDMI receptacles instead of a single full size HDMI receptacle,
and a USB-C power receptacle instead of micro-USB. Two of the USB
receptacles are 3.0 and two are 2.0. A major improvement is a Gigabit
Ethernet controller connected via PCI Express instead of the USB
connected Ethernet used for all earlier models. The Raspberry Pi 4 Model
B uses the same wireless chip set as the 3+.

There are also a myriad of [Raspberry Pi 4 Compute
Modules](https://www.raspberrypi.com/products/compute-module-4), with
varying combinations of wireless Ethernet, RAM and eMMC.

All Raspberry Pi 4 models use the same ARMv8 kernel, with different
device trees.

##### USB Gadgets

You will need to edit some boot configuration files to enable USB Gadget
mode on a Raspberry Pi 4. First, change
**`dtoverlay=dwc2,dr_mode=host`** to
**`dtoverlay=dwc2,dr_mode=peripheral`** in **`/boot/config.txt`** to
change the USB-C receptacle from USB host to USB peripheral. Then change
the **`OPTIONS`** word in **`/boot/cmdline.txt`** to **`0x172C`** for a
USB HID gadget, **`0x072E`** for a USB Ethernet gadget, or **`0x03AC`**
for a USB serial port gadget. See [Application Note
\#10](https://repo.munts.com/muntsos/doc/AppNote10-OPTIONS.pdf) for more
information about the **`OPTIONS`** word.

The Raspberry Pi 4 family consumes significantly more power than the
Raspberry Pi 3 and not all host computers will be able to supply enough
current to a single USB receptacle to support a Raspberry Pi 4 in USB
Gadget mode.

#### Raspberry Pi 5

The [Raspberry Pi
5](https://www.raspberrypi.com/products/raspberry-pi-5) yields another
2-3x increase in performance over the Raspberry Pi 4, at the expense of
greater power consumption. It has a 2400 MHz BCM2712 ARMv8 Cortex-A76
quad-core CPU and is available with 2 to 16 GB of RAM. The Ethernet
receptacle and USB receptacles have swapped sides, so it has a form
factor that is sort of a cross between the Raspberry Pi 1 B+ (same
grouping of Ethernet and USB receptacles) and the Raspberry Pi 4 (same
dual micro-HDMI receptacles and USB-C power receptacle).

There are also a myriad of [Raspberry Pi 5 Compute
Modules](https://www.raspberrypi.com/products/compute-module-5), with
varying combinations of wireless Ethernet, RAM and eMMC.

All Raspberry Pi 5 models use the same ARMv8 kernel, with different
device trees.

The Raspberry Pi 5 introduced a breaking PWM (Pulse Width Modulated)
output API change: It has four hardware PWM outputs on **`pwmchip2`**
(all previous Raspberry Pi models had two PWM outputs on **`pwmchip0`**)
with different pin mapping. Notably, PWM chip 2 channel 2 is mapped to
GPIO18 instead of PWM chip 0 channel 0 on previous Raspberry Pi boards.
See [RP1
Peripherals](https://datasheets.raspberrypi.com/rp1/rp1-peripherals.pdf)
page 15 for more information.

##### USB Gadgets

You will need to edit some boot configuration files to enable USB Gadget
mode on a Raspberry Pi 5. First, change
**`dtoverlay=dwc2,dr_mode=host`** to
**`dtoverlay=dwc2,dr_mode=peripheral`** in **`/boot/config.txt`** to
change the USB-C receptacle from USB host to USB peripheral. Then change
the **`OPTIONS`** word in **`/boot/cmdline.txt`** to **`0x172C`** for a
USB HID gadget, **`0x072E`** for a USB Ethernet gadget, or **`0x03AC`**
for a USB serial port gadget. See [Application Note
\#10](https://repo.munts.com/muntsos/doc/AppNote10-OPTIONS.pdf) for more
information about the **`OPTIONS`** word.

The Raspberry Pi 5 family consumes even more power than the Raspberry Pi
4 and not all host computers will be able to supply enough current to a
single USB receptacle to support a Raspberry Pi 5 in USB Gadget mode.

## Cross-Toolchains

I build a custom Ada/C/C++/Fortran/Go/Modula-2 GCC cross-toolchain for
each **MuntsOS** platform family. Each GCC cross-toolchain requires a
number of additional software component libraries, which are packaged
and distributed separately but installed into the same directory tree as
the parent cross-toolchain. I also build [Free
Pascal](https://www.freepascal.org) cross-compilers. Each of these rely
on the libraries contained in the corresponding GCC cross-toolchain
package.

Cross-toolchain packages containing GCC 15.2.0, including support for
[Ada 2022](https://www.adaic.org/ada-resources/standards/ada22), and
built for [Debian](https://www.debian.org) Linux (x86-64 *and* ARM64)
development host computers are available at:

<https://repo.munts.com/debian13> (Debian package repository)  
<https://repo.munts.com/muntsos/toolchain-debs> (just the package
files).

x86-64 RPM packages containing the exact same binaries, and known to
work on Fedora 42 and RHEL 9 and its derivatives, are available at:

<https://repo.munts.com/muntsos/toolchain-rpms>

## [Alire](https://alire.ada.dev) Crates

[![muntsos_aarch64](https://img.shields.io/endpoint?url=https://alire.ada.dev/badges/muntsos_aarch64.json)](https://alire.ada.dev/crates/muntsos_aarch64.html)
[![muntsos_raspberrypi1](https://img.shields.io/endpoint?url=https://alire.ada.dev/badges/muntsos_raspberrypi1.json)](https://alire.ada.dev/crates/muntsos_raspberrypi1.html)

Adding the **`muntsos_aarch64`** crate to an Alire Ada program project
transforms said project into one that produces a cross-compiled AArch64
program for **MuntsOS**. The **`muntsos_aarch64`** crate depends upon
the Linux distribution meta-package **`muntsos-dev-aarch64`** that pulls
in the rest of the **MuntsOS** AArch64 cross-toolchain packages. See
[Application Note
\#7](https://repo.munts.com/muntsos/doc/AppNote7-Flash-LED-Ada-Alire.pdf)
for a complete example using the **`alr`** command line tool.

The **`muntsos_raspberrypi1`** crate functions in an identical manner
for 32-bit ARMv6 Raspberry Pi 1 target computers.

Please note that the other **MuntsOS** library crates in Alire (*e.g.*
**muntsos_beaglebone**) are unusable due to breaking changes in
**`alr`** 2.0. Unfortunately, Alire project policies prohibit removing
obsolete crates, so **muntsos_beaglebone** *et al* remain in the
repository as broken and abandoned orphans.

## [Microsoft .Net](https://dotnet.microsoft.com)

[![libsimpleio](https://img.shields.io/nuget/v/libsimpleio?style=flat&logo=nuget&label=libsimpleio)](https://www.nuget.org/packages/libsimpleio)
[![libsimpleio-templates](https://img.shields.io/nuget/v/libsimpleio-templates?style=flat&logo=nuget&label=libsimpleio-templates)](https://www.nuget.org/packages/libsimpleio-templates)

With the **`dotnet`** runtime extension installed, **MuntsOS** can run
architecture independent .Net programs produced by **`dotnet build`**,
**`dotnet publish`**, **`dotnet pack`** or the equivalent actions in
[Microsoft Visual Studio](https://visualstudio.microsoft.com). Many if
not most of the library packages published on
[NuGet](https://www.nuget.org) can be used in such programs.

The NuGet library package
[libsimpleio](https://www.nuget.org/packages/libsimpleio) provides
**`libsimpleio.dll`**, a .Net Standard 2.0 library assembly that binds
to the Linux shared library **`libsimpleio.so`** that is an integral
part of **MuntsOS**. The NuGet library package
[libsimpleio-templates](https://www.nuget.org/packages/libsimpleio)
provides a .Net Core console application project template
**`csharp_console_libsimpleio`** that, while not strictly necessary,
greatly simplifies creating an .Net Core console embedded system
application project for **MuntsOS**.

    dotnet new install libsimpleio-templates
    mkdir myprogram
    cd myprogram
    dotnet new csharp_console_libsimpleio
    dotnet new sln
    dotnet sln add myprogram.csproj

See [Application Note
\#8](https://repo.munts.com/muntsos/doc/AppNote8-Flash-LED-C%23.pdf) for
a complete example using C# to flash an LED. See also the [API
specification](https://repo.munts.com/libsimpleio/doc/libsimpleio.dll)
for **`libsimpleio.dll`**.

The combination of Visual Studio + NuGet + **`libsimpleio.dll`**
delivers a very high productivity development environment for creating
embedded systems software to run on **MuntsOS**. With [RemObjects
Elements](https://www.remobjects.com/elements), a commercial Visual
Studio addon product, you can even compile Object Pascal, Java, Go, and
Swift programs, all using **`libsimpleio.dll`**, to .Net program
assemblies that run on **MuntsOS**.

## Git Repository

The source code for **MuntsOS** is available at:

<https://github.com/pmunts/muntsos>

Use the following command to clone it:

    git clone https://github.com/pmunts/muntsos.git

## File Repository

Prebuilt binaries for **MuntsOS** (extensions, kernels, thin servers,
and cross-toolchain packages) are available at:

<https://repo.munts.com/muntsos>

------------------------------------------------------------------------

Questions or comments to Philip Munts <phil@munts.net>
