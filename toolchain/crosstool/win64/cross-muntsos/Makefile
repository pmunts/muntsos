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

MUNTSOS		?= ../../../..

include $(MUNTSOS)/include/$(BOARDNAME).mk
include $(LIBSIMPLEIO)/include/rpm.mk

BUILDPATH	:= $(BUILDPATH):$(shell pwd)/../cross-win64/gcc-x86_64-w64-mingw32/bin
BUILDPATH	:= $(BUILDPATH):$(TOOLCHAIN_DIR)/bin
BUILDPATH	:= $(BUILDPATH):/bin

BINVER		:= 2.41
BINSRC		:= binutils-$(BINVER)
BINSERVER	:= https://ftp.gnu.org/gnu/binutils
BINTARBALL	:= $(BINSRC).tar.gz
BINURL		:= $(BINSERVER)/$(BINTARBALL)
BINDIST		:= $(TEMP)/$(BINTARBALL)
BINBUILD	:= $(shell pwd)/binutils.build

BINCONFIGOPTS	:= --prefix=$(TOOLCHAIN_DIR)
BINCONFIGOPTS	:= $(BINCONFIGOPTS) --host=x86_64-w64-mingw32
BINCONFIGOPTS	:= $(BINCONFIGOPTS) --target=$(CONFIGURE_NAME)
BINCONFIGOPTS	:= $(BINCONFIGOPTS) --disable-lto
BINCONFIGOPTS	:= $(BINCONFIGOPTS) --disable-nls

GCCVER		:= 15.2.0
GCCSRC		:= gcc-$(GCCVER)
GCCSERVER	:= https://ftp.gnu.org/gnu/gcc/$(GCCSRC)
GCCTARBALL	:= $(GCCSRC).tar.gz
GCCURL		:= $(GCCSERVER)/$(GCCTARBALL)
GCCDIST		:= $(TEMP)/$(GCCTARBALL)
GCCBUILD	:= $(shell pwd)/gcc.build

GCCCONFIGOPTS	:= --prefix=$(TOOLCHAIN_DIR)
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --host=x86_64-w64-mingw32
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --target=$(CONFIGURE_NAME)
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --disable-libgomp
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --disable-libmpx
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --disable-libmudflap
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --disable-libquadmath
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --disable-libquadmath-support
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --disable-libsanitizer
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --disable-libssp
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --disable-libstdcxx-verbose
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --disable-lto
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --disable-multilib
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --disable-multilib
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --disable-nls
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --disable-plugin
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --disable-sjlj-exceptions
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --disable-tm-clone-registry
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --enable-__cxa_atexit
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --enable-languages=c,c++,ada,fortran,go
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --enable-libstdcxx 
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --enable-long-long
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --enable-target-optspace
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --enable-threads
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --enable-threads=posix
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --enable-tls
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --enable-tls
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --with-arch=armv8-a
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --with-sysroot=$(GCCSYSROOT)
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --without-system-zlib
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --without-long-double-128
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --without-zstd

GPRBUILDVER	:= 25.0.1
GPRBUILDDIST	:= gprbuild-$(GPRBUILDVER)-win64.tgz
GPRBUILDDEST	:= gcc-$(TOOLCHAIN_NAME)/libexec/gprbuild-alire$(GPRBUILDVER)

BUILDNUM	?= 1
INSTALLDIR	:= $(shell pwd)/install.d
RELEASE		:= $(GCCVER).$(shell date +%Y.%j)-$(BUILDNUM)
STAGEDIR	:= gcc-$(TOOLCHAIN_NAME)

default: tarball.done

##############################################################################

# Build GNAT cross-toolchain targeting Windows 64

prepare.done:
	$(MAKE) -C ../cross-win64
	touch prepare.done

##############################################################################

# Download and build binutils, cross-compiled for Windows 64

$(BINDIST):
	wget -O $(BINDIST) $(BINURL)

binutils.source.done : $(BINDIST)
	tar xzf $(BINDIST)
	touch $@

binutils.config.done: prepare.done binutils.source.done
	rm -rf $(BINBUILD)
	mkdir $(BINBUILD)
	cd $(BINBUILD) && PATH=$(BUILDPATH) ../$(BINSRC)/configure $(BINCONFIGOPTS)
	touch $@

binutils.build.done: prepare.done binutils.config.done
	cd $(BINBUILD) && PATH=$(BUILDPATH) $(MAKE)
	cd $(BINBUILD) && PATH=$(BUILDPATH) $(MAKE) install DESTDIR=$(INSTALLDIR)
	touch $@

##############################################################################

# Download and build GCC, cross compiled for Windows 64

$(GCCDIST):
	wget -O $(GCCDIST) $(GCCURL)
	touch $@

# Unpack GCC source distribution

gcc.source.done : $(GCCDIST)
	tar xzf $(GCCDIST)
	cd $(GCCSRC) && contrib/download_prerequisites
	touch $@

# Configure GCC cross-toolchain

gcc.config.done: binutils.build.done gcc.source.done
	rm -rf $(GCCBUILD)
	mkdir $(GCCBUILD)
	cd $(GCCBUILD) && PATH=$(BUILDPATH) ../$(GCCSRC)/configure $(GCCCONFIGOPTS)
	touch $@

# Build GCC cross-toolchain

gcc.build.done: gcc.config.done
	cd $(GCCBUILD) && PATH=$(BUILDPATH) $(MAKE)
	cd $(GCCBUILD) && PATH=$(BUILDPATH) $(MAKE) install DESTDIR=$(INSTALLDIR)
	touch $@

##############################################################################

# Create GCC cross-toolchain installation tree, with sysroot merged, gprbuild
# merged, and all symbolic links replaced with their targets

stage.done: gcc.build.done
	rm -rf gcc-$(TOOLCHAIN_NAME)
	cp -R -L -p $(INSTALLDIR)$(TOOLCHAIN_DIR) .
	rsync -avcqL --delete $(TOOLCHAIN_DIR)/$(CONFIGURE_NAME)/ gcc-$(TOOLCHAIN_NAME)/$(CONFIGURE_NAME)
	rsync -avcqL --delete $(INSTALLDIR)$(TOOLCHAIN_DIR)/$(CONFIGURE_NAME)/bin/ gcc-$(TOOLCHAIN_NAME)/$(CONFIGURE_NAME)/bin
	rsync -avcqL --delete $(TOOLCHAIN_DIR)/share/gpr/ gcc-$(TOOLCHAIN_NAME)/share/gpr
	chmod -R u+w gcc-$(TOOLCHAIN_NAME)
	sed -i 's#/usr/local#C:/PROGRA~1/MuntsOS#g' gcc-$(TOOLCHAIN_NAME)/share/gpr/*
	sed -i 's#("-shared-libgcc")#("-shared-libgcc", "-Wl,-rpath-link=$(LIBSLIBDIR)")#g' gcc-$(TOOLCHAIN_NAME)/share/gpr/*.cgpr
	mkdir -p			$(GPRBUILDDEST)
	tar xzf $(GPRBUILDDIST) -C	$(GPRBUILDDEST)
	chmod -R u+w gcc-$(TOOLCHAIN_NAME)
	rm -rf				$(GPRBUILDDEST)/alire*
	rm -rf				$(GPRBUILDDEST)/doinstall
	rm -rf				$(GPRBUILDDEST)/share
	cd gcc-$(TOOLCHAIN_NAME)/bin && for P in ../libexec/gprbuild-alire$(GPRBUILDVER)/bin/*.exe ; do cp $$P . ; done
	cd gcc-$(TOOLCHAIN_NAME) && find * -type f -exec md5sum -b {} ";" | grep -v checksums.md5 >checksums.md5
	touch $@

##############################################################################

# Create GCC cross-toolchain release tarball

tarball.done: stage.done
	tar cJf gcc-$(TOOLCHAIN_NAME)-$(RELEASE)-win64.tar.xz gcc-$(TOOLCHAIN_NAME) --mode=ugo-w
	md5sum -b gcc-$(TOOLCHAIN_NAME)-$(RELEASE)-win64.tar.xz >gcc-$(TOOLCHAIN_NAME)-$(RELEASE)-win64.md5
	touch $@

##############################################################################

# Remove working files

clean:
	rm -rf gcc*ctng* stage.done tarball.done

reallyclean: clean
	rm -rf $(BINSRC) $(BINBUILD) $(GCCSRC) $(GCCBUILD) $(INSTALLDIR) *.done

distclean: reallyclean
