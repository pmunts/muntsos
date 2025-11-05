# Makefile for building a MuntsOS Embedded Linux cross-toolchain using
# GNU Dev Tools for ARM

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

# See also: https://gitlab.arm.com/tooling/gnu-devtools-for-arm

MUNTSOS		?= ../..

include $(MUNTSOS)/include/$(BOARDNAME).mk

default: packages.done

##############################################################################

# Download all of the source distributions for an ARM GNU cross-toolchain and
# then create a single reusable distribution tarball

DEVTOOLSURL	:= https://gitlab.arm.com/tooling/gnu-devtools-for-arm.git
DEVTOOLSDIR	:= src/gnu-devtools-for-arm

GITFLAGS	:= -c advice.detachedHead=false
GCCVER		:= 15.2.0
GCCTAG		:= releases/gcc-$(GCCVER)
GLIBCTAG	:= glibc-2.41
LINUXTAG	:= v6.12

SRCDIST		:= arm-gnu-sources.tar

$(SRCDIST):
	mkdir -p src
	cd src && git clone $(DEVTOOLSURL)
	cd $(DEVTOOLSDIR) && python3 extras/source-fetch.py checkout --src-dir=.. spc/trunk.spc
	cd src/gcc   && git $(GITFLAGS) checkout $(GCCTAG)
	cd src/glibc && git $(GITFLAGS) checkout $(GLIBCTAG)
	cd src/linux && git $(GITFLAGS) checkout $(LINUXTAG)
	tar cf $@ --exclude='.git*' src
ifneq ($(wildcard $(BOARDNAME).patch),)
	patch -b -p0 <$(BOARDNAME).patch
endif
	touch source.done

##############################################################################

# Unpack source distribution tarball

source.done: $(SRCDIST)
	tar xf $^
ifneq ($(wildcard $(BOARDNAME).patch),)
	patch -b -p0 <$(BOARDNAME).patch
endif
	touch $@

##############################################################################

# Build an ARM GNU cross-toolchain

BUILDDIR	:= $(shell pwd)/build-$(CONFIGURE_NAME)

BUILDOPTIONS	:= --target=$(CONFIGURE_NAME)
BUILDOPTIONS	:= $(BUILDOPTIONS) --builddir=$(BUILDDIR)
BUILDOPTIONS	:= $(BUILDOPTIONS) --srcdir=$(shell pwd)/src
BUILDOPTIONS	:= $(BUILDOPTIONS) --disable-multiarch
BUILDOPTIONS	:= $(BUILDOPTIONS) --with-language=ada
BUILDOPTIONS	:= $(BUILDOPTIONS) --with-language=fortran
BUILDOPTIONS	:= $(BUILDOPTIONS) --with-language=go
BUILDOPTIONS	:= $(BUILDOPTIONS) --with-language=m2
BUILDOPTIONS	:= $(BUILDOPTIONS) --release

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

BUILDSCRIPT	:= build-cross-linux-toolchain.sh

build.done: source.done
	PATH=$(BUILDPATH) $(BUILDSCRIPT) $(BUILDOPTIONS)
	touch $@

##############################################################################

# Copy the cross-toolchain to a staging directory and rearrange the sysroot
# directory tree into a more sane layout.

STAGEDIR1	:= $(shell pwd)/gcc-$(TOOLCHAIN_NAME)
STAGEDIR2	:= $(STAGEDIR1)/$(CONFIGURE_NAME)

stage.done: build.done
	cp -R -P -p $(BUILDDIR)/install $(STAGEDIR1)
ifeq ($(WORDSIZE), 64)
	# Merge lib64/ into lib/
	rsync -avcq $(STAGEDIR2)/lib64/			$(STAGEDIR2)/lib
	rm -rf						$(STAGEDIR2)/lib64
	ln -s -f lib					$(STAGEDIR2)/lib64
	rsync -avcq $(STAGEDIR2)/libc/lib64/		$(STAGEDIR2)/libc/lib
	rm -rf						$(STAGEDIR2)/libc/lib64
	ln -s -f lib					$(STAGEDIR2)/libc/lib64
	rsync -avcq $(STAGEDIR2)/libc/usr/lib64/	$(STAGEDIR2)/libc/usr/lib
	rm -rf						$(STAGEDIR2)/libc/usr/lib64
	ln -s -f lib					$(STAGEDIR2)/libc/usr/lib64
endif
	rsync -avcq $(STAGEDIR2)/libc/etc/		$(STAGEDIR2)/libc/usr/etc
	rm -rf						$(STAGEDIR2)/libc/etc
	rsync -avcq $(STAGEDIR2)/libc/sbin/		$(STAGEDIR2)/libc/usr/bin
	rm -rf						$(STAGEDIR2)/libc/sbin
	rsync -avcq $(STAGEDIR2)/libc/usr/sbin/		$(STAGEDIR2)/libc/usr/bin
	rm -rf						$(STAGEDIR2)/libc/usr/sbin
	rm -rf						$(STAGEDIR2)/libc/var
	# Symlink all library files in libc/usr/lib/
	cd $(STAGEDIR2)/libc/usr/lib && for F in ../../../lib/* ; do ln -s -f $$F ; done
	cd $(STAGEDIR2)/libc/usr/lib && for F in ../../lib/*    ; do ln -s -f $$F ; done
	ln -s ../../../../lib/gcc/$(CONFIGURE_NAME)/$(GCCVER)/adalib/libgnat.so  $(STAGEDIR2)/libc/usr/lib/libgnat.so
	ln -s ../../../../lib/gcc/$(CONFIGURE_NAME)/$(GCCVER)/adalib/libgnarl.so $(STAGEDIR2)/libc/usr/lib/libgnarl.so
	touch $@

##############################################################################

# Create ARM GNU cross-toolchain packages

packages.done: stage.done
	$(MAKE) -f Makefile.dpkg
	$(MAKE) -f Makefile.rpm
ifneq ($(SERVERDIR),)
	scp gcc*.deb gcc*.rpm $(SERVERDIR)
endif
	touch $@

##############################################################################

# Remove working files

clean:
	$(MAKE) -f Makefile.dpkg clean
	$(MAKE) -f Makefile.rpm  clean
	rm -rf packages.done stage.done gcc*

reallyclean: clean
	rm -rf build* src *.done

distclean: reallyclean
	rm -f $(SRCDIST)
