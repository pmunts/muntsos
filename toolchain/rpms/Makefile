# Makefile for building MuntsOS Embedded Linux development RPM packages

# Copyright (C)2023-2024, Philip Munts dba Munts Technologies.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

BUILDNUM	?= 1
FLAVOR		?= ctng
SERVERDIR	?= $(HOME)

default: build upload clean

# Build RPM packages

build:
	$(MAKE) -C libsimpleio-common BUILDNUM=$(BUILDNUM)
	$(MAKE) -C muntsos-common BUILDNUM=$(BUILDNUM)
	#$(MAKE) -C muntsos-dev BUILDNUM=$(BUILDNUM) RPMTARGET=AArch64 RPMSUFFIX=aarch64 RPMTUPLE=aarch64-muntsos-linux-gnu-$(FLAVOR)
	#$(MAKE) -C muntsos-dev BUILDNUM=$(BUILDNUM) RPMTARGET=BeagleBone RPMSUFFIX=beaglebone RPMTUPLE=arm-muntsos-linux-gnueabihf-$(FLAVOR)-beaglebone
	#$(MAKE) -C muntsos-dev BUILDNUM=$(BUILDNUM) RPMTARGET=RaspberryPi1 RPMSUFFIX=raspberrypi1 RPMTUPLE=arm-muntsos-linux-gnueabihf-$(FLAVOR)-raspberrypi1
	#$(MAKE) -C muntsos-dev BUILDNUM=$(BUILDNUM) RPMTARGET=RaspberryPi2 RPMSUFFIX=raspberrypi2 RPMTUPLE=arm-muntsos-linux-gnueabihf-$(FLAVOR)-raspberrypi2

# Upload RPM packages to repository

upload:
	scp */*.rpm $(SERVERDIR)

# Remove artifacts

clean:
	$(MAKE) -C libsimpleio-common clean BUILDNUM=$(BUILDNUM)
	$(MAKE) -C muntsos-common clean BUILDNUM=$(BUILDNUM)
	#$(MAKE) -C muntsos-dev clean BUILDNUM=$(BUILDNUM) RPMTARGET=AArch64 RPMSUFFIX=aarch64 RPMTUPLE=aarch64-muntsos-linux-gnu-$(FLAVOR)
	#$(MAKE) -C muntsos-dev clean BUILDNUM=$(BUILDNUM) RPMTARGET=BeagleBone RPMSUFFIX=beaglebone RPMTUPLE=arm-muntsos-linux-gnueabihf-$(FLAVOR)-beaglebone
	#$(MAKE) -C muntsos-dev clean BUILDNUM=$(BUILDNUM) RPMTARGET=RaspberryPi1 RPMSUFFIX=raspberrypi1 RPMTUPLE=arm-muntsos-linux-gnueabihf-$(FLAVOR)-raspberrypi1
	#$(MAKE) -C muntsos-dev clean BUILDNUM=$(BUILDNUM) RPMTARGET=RaspberryPi2 RPMSUFFIX=raspberrypi2 RPMTUPLE=arm-muntsos-linux-gnueabihf-$(FLAVOR)-raspberrypi2
