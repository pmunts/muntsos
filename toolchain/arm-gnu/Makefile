# Copyright (C)2025, Philip Munts dba Munts Technologies.
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

MUNTSOS		?= ../..

include $(MUNTSOS)/include/$(BOARDNAME).mk

default: build.done

##############################################################################

# Download all of the source distributions for an ARM GNU cross-toolchain and
# then create a single reusable distribution tarball

SRCDIST		:= arm-gnu-sources.tar

DEVTOOLSURL	:= https://gitlab.arm.com/tooling/gnu-devtools-for-arm.git
DEVTOOLSDIR	:= src/gnu-devtools-for-arm

GITFLAGS	:= -c advice.detachedHead=false
GCCTAG		:= releases/gcc-15.2.0
GLIBCTAG	:= glibc-2.41
LINUXTAG	:= v6.12

$(SRCDIST):
	mkdir -p src
	cd src && git clone $(DEVTOOLSURL)
	cd $(DEVTOOLSDIR) && python3 extras/source-fetch.py checkout --src-dir=.. ../../arm-gnu.spc
	cd src/gcc   && git $(GITFLAGS) checkout $(GCCTAG)
	cd src/glibc && git $(GITFLAGS) checkout $(GLIBCTAG)
	cd src/linux && git $(GITFLAGS) checkout $(LINUXTAG)
	tar cf $@ --exclude='.git*' src
	patch -b -p 0 <arm-gnu.patch
	touch source.done

##############################################################################

# Unpack source distribution tarball

source.done: $(SRCDIST)
	tar xf $^
	patch -b -p 0 <arm-gnu.patch
	touch $@

##############################################################################

# Build an ARM GNU cross-toolchain

ifeq ($(shell uname -m), aarch64)
# Build with Alire GNAT Native 
BUILDPATH	:= $(HOME)/.local/share/alire/toolchains/gnat_native_15.2.1_54b1000a/bin
BUILDPATH	:= $(BUILDPATH):/bin:$(shell pwd)/$(DEVTOOLSDIR)
endif

ifeq ($(shell uname -m), x86_64)
# Build with Alire GNAT Native
BUILDPATH	:= $(HOME)/.local/share/alire/toolchains/gnat_native_15.2.1_4640d4b3/bin
BUILDPATH	:= $(BUILDPATH):/bin:$(shell pwd)/$(DEVTOOLSDIR)
endif

BUILDSCRIPT	:= build-gnu-toolchain.sh

BUILDOPTIONS	:= --target=$(CONFIGURE_NAME)
BUILDOPTIONS	:= $(BUILDOPTIONS) -- --release
BUILDOPTIONS	:= $(BUILDOPTIONS) --with-language=ada
BUILDOPTIONS	:= $(BUILDOPTIONS) --with-language=fortran
BUILDOPTIONS	:= $(BUILDOPTIONS) --with-language=go
BUILDOPTIONS	:= $(BUILDOPTIONS) --with-language=m2

INSTALLDIR	:= build-$(CONFIGURE_NAME)/install

build.done: source.done
	PATH=$(BUILDPATH) $(BUILDSCRIPT) $(BUILDOPTIONS) 2>&1 | tee build.log
	# Rearrange sysroot directory tree
	rsync -avcq $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/etc/		$(INSTALLDIR)/$(CONFIGURE_NAME)/libc/usr/etc
	rm -rf $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/etc
ifneq ($(wildcard $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/lib64),)
	rsync -avcq $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/lib64/		$(INSTALLDIR)/$(CONFIGURE_NAME)/libc/lib
	rm -rf $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/lib64
	ln -s -f lib							$(INSTALLDIR)/$(CONFIGURE_NAME)/libc/lib64
endif
	rsync -avcq $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/sbin/		$(INSTALLDIR)/$(CONFIGURE_NAME)/libc/usr/bin
	rm -rf $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/sbin
ifneq ($(wildcard $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/usr/lib64),)
	rsync -avcq $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/usr/lib64/	$(INSTALLDIR)/$(CONFIGURE_NAME)/libc/usr/lib
	rm -rf $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/usr/lib64
	ln -s -f lib							$(INSTALLDIR)/$(CONFIGURE_NAME)/libc/usr/lib64
endif
	rsync -avcq $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/usr/sbin/	$(INSTALLDIR)/$(CONFIGURE_NAME)/libc/usr/bin
	rm -rf $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/usr/sbin
	rm -rf $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/var
	ln -s ../../../lib/gcc/$(CONFIGURE_NAME)/$(shell awk -F '"' '/CT_GCC_VERSION=/ { print $$2 }' .config)/adalib/libgnat.so  $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/lib/libgnat.so
	ln -s ../../../lib/gcc/$(CONFIGURE_NAME)/$(shell awk -F '"' '/CT_GCC_VERSION=/ { print $$2 }' .config)/adalib/libgnarl.so $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/lib/libgnarl.so
	cd $(INSTALLDIR)/$(CONFIGURE_NAME)/libc/usr/lib && for F in ../../lib/* ; do ln -s -f $$F ; done
	touch $@

##############################################################################

# Remove working files

clean:

reallyclean: clean
	rm -rf *.done src

distclean: reallyclean
	rm -f $(SRCDIST)
