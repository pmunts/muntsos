MuntsOS Embedded Linux

This framework supports Linux on several single board microcomputers.
The goal of the MuntsOS project is to deliver a turnkey, RAM resident
Linux operating system for very low cost single board microcomputers.
With MuntsOS installed, such microcomputers can treated as components,
as Linux microcontrollers, and integrated into other projects just like
traditional single chip microcontrollers.

News

-   17 December 2024 -- Moved all 32-bit target deliverables (toolchain
    packages, kernels, extensions, and thin servers) to
    http://repo.munts.com/muntsos/attic. I did a final build of the
    32-bit target kernels with sysconfig modified to fetch extensions
    from the attic. I do not anticipate ever building the 32-bit target
    kernels or thin servers again.

-   20 December 2024 -- Upgraded the Raspberry Pi kernel to 6.6.67.
    Added a new device tree overlay, Pi4ClickShield, to support the
    eponymous mikroBUS shield.

-   26 December 2024 -- Added preliminary support for the Orange Pi Zero
    2W. I have the U-Boot boot loader and the Linux mainline 6.12 LTS
    kernel, both with serial port console, working all the way to the
    login prompt. Much work on the kernel and device tree remains before
    MuntsOS on the Orange Pi Zero 2W is ready for production use.

-   28 December 2024 -- I had to drop back to the manufacturer Linux 6.1
    kernel tree for the Orange Pi Zero 2W. The Linux mainline 6.12 LTS
    tree does not have drivers for PWM outputs nor the built-in WiFi
    chipset, both of which are required for the application I have in
    mind. MuntsOS for the Orange Pi Zero 2W built on Linux 6.1 is about
    at the same point or a litte further along than what I had running
    on Linux 6.12 LTS. Most things seem to be working except HDMI and
    internal WiFi. I have been testing with a Broadcom WiFi Adapter and
    Two Port Hub I got years ago for the Raspberry Pi Zero.

-   3 January 2025 -- Upgraded the Raspberry Pi Linux kernel to 6.6.69.
    Got the Orange Pi Zero 2W console on USB keyboard / HDMI monitor
    working. Modified /etc/inittab to support four virtual terminals on
    HDMI video target platforms. Changed the kernel default printk quiet
    priority level to 2, to suppress most printk noise to the console.
    Added support for importing settings from /etc/sysctl.conf.

-   4 January 2025 -- Added tclsh, expect, and socat extension packages.
    Tcl is a scripting language that has been around in the Unix world
    for a very long time, since 1988. tclsh is the Tcl interpreter
    program. Some years ago I used Tcl for text fixture automation, an
    application for which it is very well suited.

    expect is both an extension to Tcl and a standalone program that is
    extremely useful for automating a dialog between a computer and an
    I/O device with a serial port interface. All manner of older lab
    instruments and other industrial equipment had a serial port control
    interface, as do more modern devices such as the ESP8266 WiFi
    microcontroller. Many modern instruments, such as my oscilloscope,
    have a USB port that enumerates as a serial port when plugged into a
    computer.

    socat is a Linux utility program that bridges two byte stream
    communications channels of various kinds, such as stdin/stdout and a
    serial port, in the case of the expect script I was using to
    configure the ESP8266.

-   8 January 2025 -- As I was preparing to begin work on USB Gadget
    mode for the Orange Pi Zero 2W, I realized that, unlike the
    Raspberry Pi 3, the Raspberry Pi 4 does not need a separate USB
    Gadget kernel. The old obsolete BeagleBones, the Raspberry Pi 4
    Model B, and the Raspberry Pi 5 Model B all have a USB controller
    dedicated to the USB Mini-A/USB micro-A/USB-C power connector that
    is entirely separate from the USB controller dedicated to the USB-A
    receptacle(s). The BeagleBone family never needed a separate USB
    Gadget kernel and neither do the Raspberry Pi 4 or 5.

    The direction (host or peripheral) of the Raspberry Pi 4 Model B
    (and the Raspberry Pi 5 Model B) USB-C connector is set in the
    device tree, by adding either dtoverlay=dwc2,dr_mode=host or
    dtoverlay=dwc2,dr_mode=peripheral to /boot/config.txt. This may or
    may work on CM4/CM5 carrier boards: The Compute Module 4 IO Board
    can be placed into USB peripheral mode but the Waveshare CM4-Duino
    cannot. Negotiating USB peripheral mode seems to require USB OTG (On
    The Go) configuration signals and/or resistors that are wired on the
    CM4 I/O Board but not on the CM4-Duino.

    This USB Gadget scheme works equally well on the Raspberry Pi 5
    Model B and I have enabled support for USB Gadget mode in the
    Raspberry Pi 5 kernel. Both my Windows laptop and Dell tower running
    Debian Linux Bookworm are able to supply enough current to their
    USB-A receptacles to power up a Raspberry Pi 5 Model B with 4 GB of
    RAM running MuntsOS. YMMV.

    Just for the fun of it, I have added the stress-ng extension package
    to MuntsOS see how a Raspberry Pi 5 Model B would hold up drawing
    power from the Dell tower's front panel USB-A receptacle.

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

Orange Pi Zero 2W

The Orange Pi Zero 2W is a small Linux microcomputer with a form factor
very similiar to the Raspberry Pi Zero 2 W, making it ideal for embedded
system projects. It has a 1500 MHz Allwinner H618 Cortex-A53 quad-core
CPU and comes with 1 to 4 GB of RAM and on-board Bluetooth and WiFi
radios. It is available for sale on Amazon for $21.99 (1 GB RAM) to
$33.99 (4 GB RAM).

The much larger RAM is a big advantage and I have been able to purchase
as many as I want without limits when the Raspberry Pi Zero 2 W has been
unavailable. Unfortunately, the manufacturer kernel source tree has not
been maintained regularly and is currently at 6.1.31.

Raspberry Pi

The Raspberry Pi is a family of low cost Linux microcomputers selling
for USD $15 to $80, depending on model. There have been five generations
of Raspberry Pi microcomputers, each using a successively more
sophisticated Broadcom ARM core CPU. The first two generations (32-bit
ARMv6 Raspberry Pi 1 and 32-bit ARMv7 Raspberry Pi 2) are now obsolete.

Some Raspberry Pi models have an on-board Bluetooth radio that uses the
serial port signals that are also brought out to the expansion header.
By default, MuntsOS port disables the on-board Bluetooth radio, in favor
of the serial port on the expansion header.

All of the following 64-bit Raspberry Pi models use the same AArch64
cross-toolchain.

Raspberry Pi 3

The Raspberry Pi 2 Model B Revision 1.2 with the 900 MHz BCM2710 ARMv8
Cortex-A53 quad-core CPU can be treated as a power conserving Raspberry
Pi 3 Model B− and is useful for industrial applications where wired
Ethernet is preferred.

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
MB of RAM along with on-board Bluetooth and WiFi radios. This small,
light, and inexpensive board is probably one of the best Linux
microcomputers available for implementing embedded systems.

All Raspberry Pi 3 models use the same ARMv8 kernel, with different
device trees.

USB Gadgets

MuntsOS also provides a second, different Raspberry Pi 3 ARMv8 kernel
with dedicated USB Gadget support enabled. This kernel only runs on 3
A+, Zero 2 W, and certain CM3 carrier boards which lack the USB hub
present on all Model B boards. The single USB controller that is part of
the BCM27xx SOC (System On Chip) is wired directly to the USB-A
receptacle on the 3 A+ or the USB Micro-A receptacle on the CM3 I/O
board or the Raspberry Pi Zero 2 W.

All of the MuntsOS USB Gadget kernels and Thin Servers support USB
Network, Raw HID, and Serial Port gadgets, selected by bits in the
OPTIONS word passed on the kernel command line (as configured in
/boot/cmdline.txt). All of the USB Gadget Thin Servers have USB Network
Gadget selected by default.

You can supply power to and communicate with a compatible Raspberry Pi 3
(A+, CM3, or Zero 2W) running the USB Gadget kernel through the USB
port. The absolute minimum possible usable Raspberry Pi kit consists of
a Raspberry Pi Zero 2 W, a micro-USB cable, and a micro-SD card with one
of the MuntsOS Raspberry Pi 3 USB Gadget Thin Servers installed.

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

All Raspberry Pi 4 models use the same ARMv8 kernel, with different
device trees.

USB Gadgets

Raspberry Pi 4 USB Gadget Thin Servers contain /boot/cmdline.txt and
/boot/config.txt files that place the USB-C receptable on the Raspberry
Pi 4 Model B into USB Gadget mode. This may or may not work on CM4
carrier boards, as some extra signals and/or programming resistors seem
to be required to negotiate USB Gadget mode, and not all carrier boards
have these.

The Raspberry Pi 4 family consumes significantly more power than the
Raspberry Pi 3 and not all host computers will be able to supply enough
current to a single USB receptacle to support a Raspberry Pi 4 in USB
Gadget mode.

Raspberry Pi 5

The Raspberry Pi 5 Model B yields another 2-3x increase in performance
over the Raspberry Pi 4, at the expense of greater power consumption. It
has a 2400 MHz BCM2712 ARMv8 Cortex-A76 quad-core CPU and is available
with 4 or 8 GB of RAM. The Ethernet receptacle and USB ports have
swapped sides, so it has a form factor that is sort of a cross between
the Raspberry Pi 1 B+ (same grouping of Ethernet and USB ports) and the
Raspberry Pi 4 (same dual micro-HDMI receptacles and USB-C power
receptacle).

There are also a myriad of Raspberry Pi 5 Compute Modules, with varying
combinations of wireless Ethernet, RAM and eMMC.

All Raspberry Pi 5 models use the same ARMv8 kernel, with different
device trees.

The Raspberry Pi 5 introduced a breaking GPIO API change. See
Application Note #11 for more information.

The Raspberry Pi 5 also introduced a breaking PWM API change. It has
four hardware PWM outputs with different pin mapping. Notably, PWM chip
2 channel 2 is mapped to GPIO18 instead of PWM chip 0 channel 0 on
previous Raspberry Pi boards. See RP1 Peripherals page 15 for more
information.

USB Gadgets

Raspberry Pi 5 USB Gadget Thin Servers contain /boot/cmdline.txt and
/boot/config.txt files that place the USB-C receptable on the Raspberry
Pi 5 Model B into USB Gadget mode. This may or may not work on CM5
carrier boards, as some extra signals and/or programming resistors seem
to be required to negotiate USB Gadget mode, and not all carrier boards
have these.

The Raspberry Pi 5 family consumes even more power than the Raspberry Pi
4 and not all host computers will be able to supply enough current to a
single USB receptacle to support a Raspberry Pi 5 in USB Gadget mode.

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

http://repo.munts.com/debian12 (Debian package repository)
http://repo.munts.com/muntsos/toolchain-debs (just the package files).

x86-64 RPM packages containing the exact same binaries and known to work
on Fedora 40 and RHEL 9.1 and its derivatives are available at:

http://repo.munts.com/muntsos/toolchain-rpms

Alire Crates

https://alire.ada.dev/crates/muntsos_aarch64.html

Adding muntsos_aarch64 to an Alire Ada program project turns it into one
that produces a cross-compiled AArch64/ARMv8 program for MuntsOS. See
Application Note #7 for a complete example using the alr command line
tool.

Please note that none of the other MuntsOS library crates in Alire (e.g.
muntsos_beaglebone) are useable due to breaking changes in alr 2.0.
Unfortunately, Alire project policies prohibit removing obsolete crates,
so muntsos_beaglebone et al remain in the repository as broken and
abandoned orphans.

Microsoft .Net

https://www.nuget.org/packages/libsimpleio
https://www.nuget.org/packages/libsimpleio-templates

With the dotnet extension installed, MuntsOS can run architecture
independent .Net programs produced by dotnet build, dotnet publish,
dotnet pack or the equivalent actions in Microsoft Visual Studio. Many
if not most of the library packages published on Nuget can be used in
such programs.

The NuGet library package libsimpleio provides libsimpleio.dll, a .Net
Standard 2.0 library assembly that binds to the Linux shared library
libsimpleio.so that is an integral part of MuntsOS. The NuGet library
package libsimpleio-templates provides a .Net Core console application
project template csharp_console_libsimpleio that, while not strictly
necessary, greatly simplifies creating an embedded system .Net Core
console application project for MuntsOS.

See Application Note #8 for a complete example using C# to flash an LED.
See also the API specification for libsimpleio.dll.

The combination of Visual Studio + NuGet + libsimpleio provides a very
high productivity development environment for creating embedded systems
software to run on MuntsOS. With RemObjects Elements, a commercial
Visual Studio addon product, you can even compile Object Pascal, Java,
Go, and Swift programs, all using libsimpleio.dll, to .Net program
assemblies that run on MuntsOS.

Git Repository

The source code for MuntsOS is available at:

https://github.com/pmunts/muntsos

Use the following command to clone it:

git clone https://github.com/pmunts/muntsos.git

File Repository

Prebuilt binaries for MuntsOS (extensions, kernels, thin servers, and
cross-toolchain packages) are available at:

http://repo.munts.com/muntsos

------------------------------------------------------------------------

Questions or comments to Philip Munts phil@munts.net
