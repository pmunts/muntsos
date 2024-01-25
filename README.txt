                             MuntsOS Embedded Linux

   This framework supports Linux on several single board microcomputers.
   The goal of the MuntsOS project is to deliver a turnkey, RAM resident
   Linux operating system for very low cost single board microcomputers.
   With MuntsOS installed, such microcomputers can treated as components,
   as Linux microcontrollers, and integrated into other projects just like
   traditional single chip microcontrollers.

News

     * 1 January 2024 -- I have decided to suspend active development for
       32-bit platforms. The 32-bit BeagleBone kernel is frozen at
       5.4.106. The 32-bit Raspberry Pi 1 and 2 kernels are frozen at
       5.15.92. The 32-bit extensions, kernels and thin servers will still
       be rebuilt from time to time to incorporate userland improvements.
       The muntsos-dev package has been updated to only pull in 64-bit
       AArch toolchains.

     * 1 January 2024 -- The 64-bit Raspberry Pi 3 and 4 kernels have been
       upgraded to 6.1.69 and will track
       [1]https://github.com/raspberrypi/linux again.

     * 6 January 2024 -- Added a libusb extension package. It just
       installs /usr/local/lib/libusb-1.0.so.0, which is no longer
       included in the kernel RAM file system.

     * 6 January 2024 -- In the course of porting MuntsOS to the 64-bit
       [2]Raspberry Pi 5 and the [3]Orange Pi Zero 2 W, the previous
       naming convention for MuntsOS AArch64 (arm64) extension packages
       with "RaspberryPi3" has proven shortsighted. Therefore the
       extension package naming scheme has updated to be more meaningful
       for all platforms:

       dma-muntsos-BeagleBone.deb   becomes dma-muntsos-armhf-beaglebone.deb
       dma-muntsos-RaspberryPi1.deb becomes dma-muntsos-armhf-raspberrypi1.deb
       dma-muntsos-RaspberryPi2.deb becomes dma-muntsos-armhf-raspberrypi2.deb
       dma-muntsos-RaspberryPi3.deb becomes dma-muntsos-aarch64.deb

     * 7 January 2024 -- Except for porting MuntsOS to the Raspberry Pi 5,
       which is ongoing, I have caught up with my backlog of improvements
       and fixes. Among other things, the MuntsOS startup scripts
       (/etc/rc) and friends have been extensively reworked to prevent
       race conditions. These changes also improve the system boot time.
       Support for the Raspberry 5 and the Orange Pi Zero 2 W is under
       development.

     * 13 January 2024 -- You can now write programs for MuntsOS in
       Modula-2, for which support was merged into GCC 13. During the late
       1980's and early 1990's, there was a lot of interest in Modula-2 as
       a system programming language, a more robust alternative to C. As a
       student and beginning software engineer, I spent real money on at
       least three different Modula-2 compilers for DOS.
       Some platform modules and test programs have been moved from
       libsimpleio to muntsos/examples/modula2/.

     * 13 January 2024 -- Upgraded libcurl to 8.5.0. Upgraded libnl to
       3.9.0. Took advantage of the opportunity to fix the cross-tool
       package dependency chains. Now if you remove the gcc package, all
       the corresponding free pascal compiler and library packages will be
       removed as well.

     * 20 January 2024 -- Added two new device tree overlays:
       disable-ethernet-pi4 and disable-ethernet-pi5. These disable the
       on-board Ethernet interface, exactly like disable-wifi disables the
       on-board WiFi interface. These are useful for boards like the
       [4]CM4-Duino, which doesn't have an Ethernet connector.

     * 22 January 2024 -- First cut at the Raspberry Pi 5 kernel is done.
       Much testing and verification needs to be performed.

     * 24 January 2024 -- Reworked the RPM setup scripts [5]setup-debian
       and [6]setup-rhel to improve the user experience and to
       interoperate with [7]Alire better. Verified on Fedora 39 and RHEL
       lookalikes.

     * 25 January 2025 -- Validation of the Raspberry Pi 5 port continues,
       with few issues found. I did have to implement a fix for a breaking
       GPIO API change, though, described in [8]Application Note #11.

Quick Setup Instructions for the Impatient

   Instructions for installing the MuntsOS cross-toolchain development
   environment onto a host computer are found in [9]Application Note #1
   and [10]Application Note #2. Or just download and run one of the
   following quick setup scripts:

   [11]setup-debian
   [12]setup-fedora
   [13]setup-rhel (including lookalikes)

   Instructions for installing MuntsOS to a target computer are found in
   [14]Application Note #3 and [15]Application Note #15.

Documentation

   The documentation for MuntsOS (mostly application notes) is available
   online at:

   [16]http://git.munts.com/muntsos/doc

Embedded Linux Distribution in a Kernel

   MuntsOS is a stripped down Linux distribution that includes a small
   compressed root file system within the kernel image binary itself. At
   boot time the root file system is unpacked into RAM and thereafter the
   system runs entirely in RAM.

   Each kernel release tarball contains a kernel image file (.img), which
   may be common to several different microcomputer boards, and one or
   more [17]device tree files (.dtb) that are specific to particular
   microcomputer boards. Some kernel release tarballs also contain one or
   more device tree overlay files (.dtbo) that can make small changes to
   the device tree at boot time.

   Prebuilt MuntsOS kernel release tarballs are available at:

   [18]http://repo.munts.com/muntsos/kernels

Extensions

   The MuntsOS root file system can be extended at boot time using any of
   three mechanisms:

   First, if /boot/tarballs exists, any gzip'ed tarball files (.tgz) in it
   will be extracted on top of the root file system. Typically you would
   use this mechanism for customized /etc/passwd, .ssh/authorized_keys,
   and similiar system configuration files.

   Secondly, if /boot/packages exists, any Debian package files (.deb) in
   it will be installed into the root file system. Note that packages from
   the [19]Debian project will probably not work; they must be built
   specifically for MuntsOS. The startup script that installs .deb
   packages also installs .rpm and .nupkg packages.

   The [20]GPIO Server extension package demonstrates how to build a
   Debian package that adds application specific software to MuntsOS.

   Thirdly, the system startup script /etc/rc can be configured via a
   kernel command line option to search for a subdirectory called
   autoexec.d in various places, such as SD card, USB flash drive, USB
   CD-ROM or NFS mount. If an autoexec.d subdirectory is found, each
   executable program or script in it will be executed when the system
   boots.

   The idea is to build a MuntsOS kernel (which takes a long time) once
   and install it to the target platform. Then application specific
   software can be built after the fact and installed as tarball files in
   /boot/tarballs; Debian, RPM, and NuGet package files in /boot/packages;
   or executable programs and scripts in /boot/autoexec.d.

   Prebuilt MuntsOS extension packages are available at:

   [21]http://repo.munts.com/muntsos/extensions

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

   Note: Some platforms require the [22]boot flag to be set on the FAT32
   boot partition on the SD card or on-board eMMC. The ROM boot loader in
   the CPU will ignore any partitions that are not marked as bootable.
   MuntsOS Application Notes [23]3 and [24]15 contain more detailed
   instructions about how to install a MuntsOS Thin Server.

   Prebuilt MuntsOS Thin Servers are at available at:

   [25]http://repo.munts.com/muntsos/thinservers

Boards

  Raspberry Pi

   The [26]Raspberry Pi is a family of low cost Linux microcomputers
   selling for USD $15 to $80, depending on model. There have been five
   generations of Raspberry Pi microcomputers, each using a successively
   more sophisticated Broadcom ARM core CPU. The first two generations
   (32-bit ARMv6 Raspberry Pi 1 and 32-bit ARMv7 Raspberry Pi 2) are now
   obsolete.

   Some Raspberry Pi models have an on-board Bluetooth radio that uses the
   serial port signals that are brought out to the expansion header. By
   default, MuntsOS port disables the on-board Bluetooth radio, in favor
   of the serial port on the expansion header.

    Raspberry Pi 3

   The 64-bit [27]Raspberry Pi 2 Model B Revision 1.2 with the 900 MHz
   BCM2710 ARMv8 Cortex-A53 quad-core CPU can be treated as a power
   conserving Raspberry Pi 3 Model B− and is useful for industrial
   applications where wired Ethernet is preferred.

   The [28]Rasbperry Pi 3 Model B has a 1200 MHz BCM2710 ARMv8 Cortex-A53
   quad-core CPU and has 1 GB of RAM along with on-board Bluetooth and
   WiFi radios.

   The [29]Raspberry Pi 3 Model A+ has the same form factor as the
   Raspberry Pi 1 Model A+, with only one USB host port and no wired
   Ethernet. It has a 1400 MHz BCM2710 ARMv8 Cortex-A53 quad-core CPU and
   has 512 MB of RAM along with on-board Bluetooth and WiFi radios.

   The [30]Raspberry Pi 3 Model B+ has a 1400 MHz BCM2710 ARMv8 Cortex-A53
   quad-core CPU and has improved power management and networking
   components.

   The [31]Raspberry Pi Zero 2 W has the same form factor as the Raspberry
   Pi Zero W, with a 1000 MHz BCM2710 ARMv8 Cortex-A53 quad core CPU and
   512 MB of RAM along with on-board Bluetooth and WiFi radios.

   All Raspberry Pi 3 models use the same AArch64 toolchain and ARMv8
   kernels, but different device trees.

    Raspberry Pi 4

   The [32]Raspberry Pi 4 Model B has a 1500 MHz BCM2711 ARMv8 Cortex-A72
   quad-core CPU and is available with 1 to 8 GB of RAM. It diverged
   significantly from the Raspberry Pi 1 B+ form factor, with the USB and
   Ethernet ports reversed, two micro-HDMI connectors instead of a single
   full size HDMI connector, and a USB-C power connector instead of
   micro-USB. Two of the USB ports are 3.0 and two are 2.0. A major
   improvement is a Gigabit Ethernet controller connected via PCI Express
   instead of the USB connected Ethernet used for all earlier models. The
   Raspberry Pi 4 Model B uses the same wireless chip set as the 3+.

   There are also a myriad of [33]Raspberry Pi 4 Compute Modules, with
   varying combinations of wireless Ethernet, RAM and eMMC.

   All Raspberry Pi 4 models use the same AArch64 toolchain and ARMv8
   kernels, but different device trees.

    Raspberry Pi 5

   The [34]Raspberry Pi 5 yields another 2-3x increase in performance over
   the Raspberry Pi 4, at the expense of greater power consumption. It has
   a 2400 MHz BCM2712 ARMv8 Cortex-A76 quad-core CPU and is available with
   4 or 8 GB of RAM. The Ethernet socket and USB ports have swapped sides,
   so it has a form factor that is sort of a cross between the Raspberry
   Pi 1 B+ (same grouping of Ethernet and USB ports) and the Raspberry Pi
   4 (same dual micro-HDMI sockets and USB-C power socket). It uses the
   same AArch64 toolchain as all of the other 64-bit Raspberry Pi models,
   but a separate kernel and device tree.

   The Raspberry Pi 5 introduced a breaking GPIO API change. See
   [35]Application Note #11 for more information.

    Raspberry Pi USB Gadget Kernels

   MuntsOS also provides Raspberry Pi kernels with dedicated [36]USB
   Gadget support enabled. These kernels run on 3 A+, CM3, Zero 2 W, 4 B,
   and CM4. You can supply power to and communicate with a compatible
   Raspberry Pi solely through the USB port. This kernel supports USB
   Network, Raw HID, and Serial Port gadgets, selected by bits in the
   OPTIONS word passed on the kernel command line. The USB Gadget Thin
   Servers have USB Network Gadget selected by default.

   The absolute minimum possible usable Raspberry Pi kit consists of a
   Raspberry Pi Zero 2 W, a micro-USB cable, and a micro-SD card with one
   of the MuntsOS Raspberry Pi 3 USB Gadget Thin Servers installed.

Cross-Toolchains

   I build a custom Ada/C/C++/Fortran/Go/Modula-2 GCC cross-toolchain for
   each MuntsOS platform family. Each GCC cross-toolchain requires a
   number of additional software component libraries, which are packaged
   and distributed separately but installed into the same directory tree
   as the parent cross-toolchain. I also build [37]Free Pascal
   cross-compilers. Each of these rely on the libraries contained in the
   corresponding GCC cross-toolchain package.

   Cross-toolchain packages built for [38]Debian Linux (x86-64 and ARM64)
   development host computers are available at:
   [39]http://repo.munts.com/debian12

   x86-64 RPM packages containing the exact same binaries and known to
   work on Fedora 37 and RHEL 9.1 and its derivatives are available at:
   [40]http://repo.munts.com/muntsos/rpms

Git Repository

   The source code for MuntsOS is available at:

   [41]https://github.com/pmunts/muntsos

   Use the following command to clone it:

   git clone https://github.com/pmunts/muntsos.git

File Repository

   Prebuilt binaries for MuntsOS are available at:

   [42]http://repo.munts.com/muntsos

[43]Make With Ada Projects

     * 2017 [44]Ada Embedded Linux Framework
     * 2019 [45]Modbus RTU Framework for Ada (Prize Winner!)
   _________________________________________________________

   Questions or comments to Philip Munts [46]phil@munts.net

References

   1. https://github.com/raspberrypi/linux
   2. https://www.raspberrypi.com/products/raspberry-pi-5
   3. http://www.orangepi.org/orangepiwiki/index.php/Orange_Pi_Zero_2W
   4. https://www.waveshare.com/wiki/CM4-Duino
   5. http://git.munts.com/muntsos/scripts/setup-debian
   6. http://git.munts.com/muntsos/scripts/setup-rhel
   7. https://alire.ada.dev/
   8. http://git.munts.com/muntsos/doc/AppNote11-link-gpiochip.pdf
   9. http://git.munts.com/muntsos/doc/AppNote1-Setup-Debian.pdf
  10. http://git.munts.com/muntsos/doc/AppNote2-Setup-RPM.pdf
  11. http://git.munts.com/muntsos/scripts/setup-debian
  12. http://git.munts.com/muntsos/scripts/setup-fedora
  13. http://git.munts.com/muntsos/scripts/setup-rhel
  14. http://git.munts.com/muntsos/doc/AppNote3-Installation-from-Linux.pdf
  15. http://git.munts.com/muntsos/doc/AppNote15-Installation-from-Windows.pdf
  16. http://git.munts.com/muntsos/doc
  17. http://elinux.org/Device_Tree_Reference
  18. http://repo.munts.com/muntsos/kernels
  19. http://www.debian.org/
  20. http://git.munts.com/muntsos/extensions/gpio-server
  21. http://repo.munts.com/muntsos/extensions
  22. https://en.wikipedia.org/wiki/Boot_flag
  23. http://git.munts.com/muntsos/doc/AppNote3-Installation-from-Linux.pdf
  24. http://git.munts.com/muntsos/doc/AppNote15-Installation-from-Windows.pdf
  25. http://repo.munts.com/muntsos/thinservers
  26. http://www.raspberrypi.com/
  27. https://www.raspberrypi.com/products/raspberry-pi-2-model-b
  28. https://www.raspberrypi.com/products/raspberry-pi-3-model-b
  29. https://www.raspberrypi.com/products/raspberry-pi-3-model-a-plus
  30. https://www.raspberrypi.com/products/raspberry-pi-3-model-b-plus
  31. https://www.raspberrypi.com/products/raspberry-pi-zero-2-w
  32. https://www.raspberrypi.com/products/raspberry-pi-4-model-b
  33. https://www.raspberrypi.com/products/compute-module-4
  34. https://www.raspberrypi.com/products/raspberry-pi-5
  35. http://git.munts.com/muntsos/doc/AppNote11-link-gpiochip.pdf
  36. http://www.linux-usb.org/gadget
  37. https://www.freepascal.org/
  38. https://www.debian.org/
  39. http://repo.munts.com/debian12
  40. http://repo.munts.com/muntsos/rpms
  41. https://github.com/pmunts/muntsos
  42. http://repo.munts.com/muntsos
  43. https://www.makewithada.org/
  44. https://www.makewithada.org/entry/ada_linux_sensor_framework
  45. https://www.hackster.io/philip-munts/modbus-rtu-framework-for-ada-f33cc6
  46. mailto:phil@munts.net
