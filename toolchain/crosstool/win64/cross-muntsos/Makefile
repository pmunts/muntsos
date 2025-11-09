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
include $(LIBSIMPLEIO)/include/rpm.mk

GCCVER		:= 15.2.0
GCCSRC		:= gcc-$(GCCVER)
GCCSERVER	:= https://ftp.gnu.org/gnu/gcc/$(GCCSRC)
GCCTARBALL	:= $(GCCSRC).tar.gz
GCCURL		:= $(GCCSERVER)/$(GCCTARBALL)
GCCDIST		:= $(TEMP)/$(GCCTARBALL)

BUILDDIR	:= build.d

BUILDPATH       := $(BUILDPATH):$(shell pwd)/gcc-x86_64-w64-mingw32/bin
BUILDPATH	:= $(BUILDPATH):/usr/local/gcc-aarch64-muntsos-linux-gnu-ctng/bin
BUILDPATH	:= $(BUILDPATH):/bin

CONFIGOPTS	:= --prefix=$(TOOLCHAIN_DIR)
CONFIGOPTS	:= $(CONFIGOPTS) --host=x86_64-w64-mingw32
CONFIGOPTS	:= $(CONFIGOPTS) --target=$(CONFIGURE_NAME)
CONFIGOPTS	:= $(CONFIGOPTS) --disable-libgomp
CONFIGOPTS	:= $(CONFIGOPTS) --disable-libmpx
CONFIGOPTS	:= $(CONFIGOPTS) --disable-libmudflap
CONFIGOPTS	:= $(CONFIGOPTS) --disable-libquadmath
CONFIGOPTS	:= $(CONFIGOPTS) --disable-libquadmath-support
CONFIGOPTS	:= $(CONFIGOPTS) --disable-libsanitizer
CONFIGOPTS	:= $(CONFIGOPTS) --disable-libssp
CONFIGOPTS	:= $(CONFIGOPTS) --disable-libstdcxx-verbose
CONFIGOPTS	:= $(CONFIGOPTS) --disable-lto
CONFIGOPTS	:= $(CONFIGOPTS) --disable-multilib
CONFIGOPTS	:= $(CONFIGOPTS) --disable-multilib
CONFIGOPTS	:= $(CONFIGOPTS) --disable-nls
CONFIGOPTS	:= $(CONFIGOPTS) --disable-plugin
CONFIGOPTS	:= $(CONFIGOPTS) --disable-sjlj-exceptions
CONFIGOPTS	:= $(CONFIGOPTS) --disable-tm-clone-registry
CONFIGOPTS	:= $(CONFIGOPTS) --enable-__cxa_atexit
CONFIGOPTS	:= $(CONFIGOPTS) --enable-languages=c,c++,ada,fortran,go
CONFIGOPTS	:= $(CONFIGOPTS) --enable-libstdcxx 
CONFIGOPTS	:= $(CONFIGOPTS) --enable-long-long
CONFIGOPTS	:= $(CONFIGOPTS) --enable-target-optspace
CONFIGOPTS	:= $(CONFIGOPTS) --enable-threads
CONFIGOPTS	:= $(CONFIGOPTS) --enable-threads=posix
CONFIGOPTS	:= $(CONFIGOPTS) --enable-tls
CONFIGOPTS	:= $(CONFIGOPTS) --enable-tls
CONFIGOPTS	:= $(CONFIGOPTS) --with-arch=armv8-a
CONFIGOPTS	:= $(CONFIGOPTS) --with-sysroot=$(GCCSYSROOT)
CONFIGOPTS	:= $(CONFIGOPTS) --without-system-zlib
CONFIGOPTS	:= $(CONFIGOPTS) --without-long-double-128
CONFIGOPTS	:= $(CONFIGOPTS) --without-zstd

BUILDNUM	?= 1
RPMNAME		:= gcc-$(TOOLCHAIN_NAME)
RPMVERSION	:= $(GCCVER)_$(shell date +%Y.%j)
RPMARCH		:= x86_64
RPMDIR		:= $(RPMNAME)-$(RPMVERSION)-$(BUILDNUM)-win64
RPMFILE		:= $(RPMDIR).rpm
RPMGROUP	:= Programming
RPMLICENSE	:= Mixed

default: build.done

##############################################################################

# Download source distribution

$(GCCDIST):
	wget -O $(GCCDIST) $(GCCURL)
	touch $@

##############################################################################

# Unpack GCC source distribution

source.done: $(GCCDIST)
	tar xzf $(GCCDIST)
	cd $(GCCSRC) && contrib/download_prerequisites
	touch $@

##############################################################################

# Configure GCC cross-toolchain

config.done: source.done
	rm -rf $(BUILDDIR)
	mkdir $(BUILDDIR)
	cd $(BUILDDIR) && PATH=$(BUILDPATH) ../$(GCCSRC)/configure $(CONFIGOPTS)
	touch $@

##############################################################################

# Build GCC cross-toolchain

build.done: config.done
	#cd $(BUILDDIR) && PATH=$(BUILDPATH) $(MAKE)
	#cd $(BUILDDIR) && PATH=$(BUILDPATH) $(MAKE) install DESTDIR=$(shell pwd)/$(RPMDIR)
	cp -R -P -p $(GCCSYSROOT) $(RPMDIR)$(TOOLCHAIN_DIR)/$(CONFIGURE_NAME)
	touch $@

##############################################################################

# Package GCC cross-toolchain

package.done: $(RPMFILE)
	touch $@

##############################################################################

# Remove working files

clean:
	rm -rf gcc*win64 package.done rpmbuild specfile

reallyclean: clean
	rm -rf $(GCCSRC) $(BUILDDIR) *.done

distclean: reallclean
