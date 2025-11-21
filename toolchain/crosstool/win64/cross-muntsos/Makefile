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
BINDIST		:= $(TEMP)/muntsos/$(BINTARBALL)

GCCVER		:= 15.2.0
GCCSRC		:= gcc-$(GCCVER)
GCCSERVER	:= https://ftp.gnu.org/gnu/gcc/$(GCCSRC)
GCCTARBALL	:= $(GCCSRC).tar.gz
GCCURL		:= $(GCCSERVER)/$(GCCTARBALL)
GCCDIST		:= $(TEMP)/muntsos/$(GCCTARBALL)
GCCBUILD	:= $(shell pwd)/build.d
GCCINSTALL	:= $(shell pwd)/install.d
GCCSTAGE	:= gcc-$(TOOLCHAIN_NAME)

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
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --disable-werror
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
ifeq ($(BOARDNAME), AArch64)
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --with-arch=armv8-a
endif
ifeq ($(BOARDNAME), RaspberryPi1)
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --with-cpu=arm1176jzf-s --with-fpu=vfpv2 --with-float=hard
endif
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --with-sysroot=$(GCCSYSROOT)
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --without-system-zlib
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --without-long-double-128
GCCCONFIGOPTS	:= $(GCCCONFIGOPTS) --without-zstd

GPRBUILDDIST	?= gprbuild-win64.tgz
GPRBUILDDEST	:= $(GCCSTAGE)/libexec/gprbuild

BUILDNUM	?= 1
RELEASEID	:= $(GCCVER).$(shell date +%Y.%j)-$(BUILDNUM)
RELEASETAR	:= gcc-$(TOOLCHAIN_NAME)-$(RELEASEID)-win64.tar.xz
RELEASEMD5	:= gcc-$(TOOLCHAIN_NAME)-$(RELEASEID)-win64.md5
SAVETAR		:= gcc-$(TOOLCHAIN_NAME)-$(RELEASEID)-win64-reconstitute.tgz
SAVEMD5		:= gcc-$(TOOLCHAIN_NAME)-$(RELEASEID)-win64-reconstitute.md5

default: tarball.done

##############################################################################

# Build GNAT cross-toolchain targeting Windows 64

prepare.done:
	$(MAKE) -C ../cross-win64
	touch prepare.done

##############################################################################

# Download source distributions

$(BINDIST):
	wget -O $(BINDIST) $(BINURL)
	touch $@

$(GCCDIST):
	wget -O $(GCCDIST) $(GCCURL)
	touch $@

# Unpack source distributions

source.done : $(BINDIST) $(GCCDIST)
	tar xzf $(GCCDIST)
	patch -b -p 0 <gcc.patch
	cd $(GCCSRC) && contrib/download_prerequisites
	tar xzf $(BINDIST)
	-cd $(GCCSRC) && for ITEM in ../$(BINSRC)/* ; do ln -s $$ITEM ; done
	touch $@

# Configure GCC cross-toolchain

config.done: source.done
	rm -rf $(GCCBUILD)
	mkdir $(GCCBUILD)
	cd $(GCCBUILD) && PATH=$(BUILDPATH) ../$(GCCSRC)/configure $(GCCCONFIGOPTS)
	touch $@

# Build GCC cross-toolchain

build.done: config.done
	cd $(GCCBUILD) && PATH=$(BUILDPATH) $(MAKE)
	cd $(GCCBUILD) && PATH=$(BUILDPATH) $(MAKE) install DESTDIR=$(GCCINSTALL)
	touch $@
	# Create reconstitute tarball
	tar czf $(SAVETAR) build.done $(shell basename $(GCCINSTALL))
	md5sum -b $(SAVETAR) > $(SAVEMD5)
ifneq ($(SAVEDIR),)
	# Save reconstitute tarball
	scp $(SAVETAR) $(SAVEMD5) $(SAVEDIR)
endif

##############################################################################

# Create GCC cross-toolchain installation tree, with sysroot merged, gprbuild
# merged, and all symbolic links replaced with their targets

stage.done: build.done
	rm -rf $(GCCSTAGE)
	rsync -avcqL --delete $(GCCINSTALL)$(TOOLCHAIN_DIR)/ $(GCCSTAGE)
	rsync -avcqL --delete $(TOOLCHAIN_DIR)/$(CONFIGURE_NAME)/ $(GCCSTAGE)/$(CONFIGURE_NAME)
	rsync -avcqL --delete $(GCCINSTALL)$(TOOLCHAIN_DIR)/$(CONFIGURE_NAME)/bin/ $(GCCSTAGE)/$(CONFIGURE_NAME)/bin
	rsync -avcqL --delete $(TOOLCHAIN_DIR)/share/gpr/ $(GCCSTAGE)/share/gpr
	rmdir $(GCCSTAGE)/include
	chmod -R u+w $(GCCSTAGE)
	sed -i 's#& ("-shared-libgcc")#\& ("-shared-libgcc", "-Wl,-rpath-link=$(LIBSLIBDIR)")#g' $(GCCSTAGE)/share/gpr/*.cgpr
	sed -i 's#/usr/local#C:/PROGRA~1/MuntsOS#g' $(GCCSTAGE)/share/gpr/*
	mkdir -p			$(GPRBUILDDEST)
	tar xzf $(GPRBUILDDIST) -C	$(GPRBUILDDEST)
	chmod -R u+w $(GCCSTAGE)
	rm -rf				$(GPRBUILDDEST)/alire*
	rm -rf				$(GPRBUILDDEST)/doinstall
	rm -rf				$(GPRBUILDDEST)/share
	cd $(GCCSTAGE)/bin && for P in ../libexec/gprbuild/bin/*.exe ; do cp $$P . ; done
	mkdir -p $(GCCSTAGE)/share/stuff
	install -cm 0755 fixperms.sh $(GCCSTAGE)/share/stuff
	cd $(GCCSTAGE) && find * -type f -exec md5sum -b {} ";" | grep -v checksums.md5 > share/stuff/checksums.md5
	touch $@

##############################################################################

# Create GCC cross-toolchain release tarball

tarball.done: stage.done
	tar cJf $(RELEASETAR) $(GCCSTAGE) --mode=ugo-w
	md5sum -b $(RELEASETAR) > $(RELEASEMD5)
ifneq ($(SERVERDIR),)
	scp $(RELEASETAR) $(RELEASEMD5) $(SERVERDIR)
endif
	touch $@

##############################################################################

# Remove working files

clean:
	rm -rf gcc*ctng* stage.done tarball.done

reallyclean: clean
	rm -rf $(BINSRC) $(GCCSRC) $(GCCBUILD) $(GCCINSTALL) *.done

distclean: reallyclean
