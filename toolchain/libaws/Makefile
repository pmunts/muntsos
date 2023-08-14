# Makefile definitions for building GNAT Ada application programs

# Copyright (C)2017-2023, Philip Munts dba Munts Technologies.
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

LIBSIMPLEIO	?= /usr/local/share/libsimpleio
MUNTSOS		?= ../..

include $(MUNTSOS)/include/$(BOARDNAME).mk

INSTALLDIR	:= gcc-$(TOOLCHAIN_NAME)
INCDIR		:= $(GCCSYSROOT)/usr/include
LIBDIR		:= $(GCCSYSROOT)/usr/lib
GPRDIR		:= $(PKGDIR)$(GCCSYSROOT)/../../share/gpr

BUILDNUM	?= 1
OSNAME		?= unknown
PKGNAME		:= $(INSTALLDIR)-libaws
PKGVER		:= $(GCCVER)-$(shell date +%Y.%j).$(BUILDNUM)
PKGARCH		:= all
PKGDIR		:= $(PKGNAME)-$(PKGVER)-$(OSNAME)-$(PKGARCH)
PKGFILE		:= $(PKGDIR).deb

GAINROOT	?= fakeroot

include $(LIBSIMPLEIO)/ada/include/ada.mk
include $(LIBSIMPLEIO)/include/dpkg.mk

default: package.deb

###############################################################################

# Compile the Ada Web Server packages

libaws.a:
	rm -rf obj
	mkdir -p obj
ifeq ($(BOARDNAME), RaspberryPi1)
	cd src && ln -s aws-net-std.adb-8.3.0 aws-net-std.adb
else
	cd src && ln -s aws-net-std.adb-10.3.0 aws-net-std.adb
endif
	cd src && ln -s aws-os_lib.ads-$(BOARDBASE) aws-os_lib.ads
	$(CROSS_COMPILE)gcc -Wall -I$(INCDIR) -c -o obj/wrappers.o src/wrappers.c
	$(CROSS_COMPILE)gnatmake -Wall -D obj -gnat2012 -c src/with_everything.adb
	$(CROSS_COMPILE)gcc -I$(LIBDIR)/../include -Wall -c -o obj/wrappers.o src/wrappers.c
	$(CROSS_COMPILE)gnatmake -Wall -D obj -gnat2012 -c src/with_everything.adb
	rm obj/with_everything.ali obj/with_everything.o
	$(CROSS_COMPILE)ar cr $@ obj/*.o

###############################################################################

# Create Debian package

$(PKGDIR): libaws.a
	mkdir -p					$(PKGDIR)/DEBIAN
	install -cm 0644 control			$(PKGDIR)/DEBIAN
	sed -i s/@@NAME@@/$(PKGNAME)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@ARCH@@/$(PKGARCH)/g			$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVER)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@BOARDNAME@@/$(BOARDBASE)/g		$(PKGDIR)/DEBIAN/control
	mkdir -p					$(PKGDIR)$(LIBDIR)
	install -cm 0644 src/COPYING			$(PKGDIR)$(LIBDIR)/aws.COPYING
	install -cm 0644 aws.gpr			$(PKGDIR)$(LIBDIR)
	sed -i 's@LIBDIR@$(LIBDIR)@g'			$(PKGDIR)$(LIBDIR)/aws.gpr
	mkdir -p					$(PKGDIR)$(LIBDIR)/aws.src
	install -cm 0644 src/*.ads src/*.adb		$(PKGDIR)$(LIBDIR)/aws.src
	rm						$(PKGDIR)$(LIBDIR)/aws.src/with_everything.adb
	mkdir -p					$(PKGDIR)$(LIBDIR)/aws.lib
	install -cm 0644 *.a obj/*.ali			$(PKGDIR)$(LIBDIR)/aws.lib
	mkdir -p					$(PKGDIR)$(GPRDIR)
	ln -s $(LIBDIR)/aws.gpr				$(PKGDIR)$(GPRDIR)/aws.gpr

package.deb: $(PKGFILE)

###############################################################################

# Remove working files

clean:
	rm -rf $(PKGDIR) $(PKGFILE)

reallyclean: clean
	rm -rf *.a obj src/aws-os_lib.ads src/aws-net-std.adb

distclean: reallyclean
