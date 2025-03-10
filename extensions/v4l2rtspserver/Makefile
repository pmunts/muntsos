# Makefile for building the v4l2rtspserver extension package for MuntsOS

# Copyright (C)2021-2024, Philip Munts dba Munts Technologies.
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

BOARDNAME	?= UNDEFINED
MUNTSOS		?= /usr/local/share/muntsos

include $(MUNTSOS)/include/$(BOARDNAME).mk
include $(LIBSIMPLEIO)/include/dpkg.mk

SRCURL		= https://github.com/mpromonet/v4l2rtspserver.git
SRCDIR		= v4l2rtspserver.src
SRCDIST		= /tmp/v4l2rtspserver.tgz

PKGNAME		= v4l2rtspserver
PKGVERSION	= $(shell date +%Y.%j)
PKGARCH		= $(DEBARCH)
PKGDIR		= $(PKGNAME)-muntsos-$(BOARDARCH)
PKGFILE		= $(PKGDIR).deb

CMAKEFLAGS	+= -DCMAKE_SYSTEM_NAME=Linux
CMAKEFLAGS	+= -DCMAKE_C_COMPILER=$(CROSS_COMPILE)gcc
CMAKEFLAGS	+= -DCMAKE_C_FLAGS=-I$(LIBSINCDIR)
CMAKEFLAGS	+= -DCMAKE_CXX_COMPILER=$(CROSS_COMPILE)g++
CMAKEFLAGS	+= -DCMAKE_CXX_FLAGS=-I$(LIBSINCDIR)

default: package.deb

# Clone source repo and create source tarball

$(SRCDIST):
	git clone --recurse-submodules $(SRCURL) $(SRCDIR)
	tar czf $@ --exclude='.*' $(SRCDIR)
	rm -rf $(SRCDIR)

# Unpack source tarball

source.done: $(SRCDIST)
	tar xzf $^
	touch $@

# Compile sources

build.done: source.done
	cd $(SRCDIR) && cmake $(CMAKEFLAGS)
	# Workaround for a cmake bug
	sed -i 's@/usr/lib/x86_64-linux-gnu@$(LIBSLIBDIR)@g' v4l2rtspserver.src/CMakeFiles/v4l2rtspserver.dir/link.txt
	$(MAKE) -C $(SRCDIR)
	touch $@

# Build the Debian package file

$(PKGDIR): build.done
	mkdir -p				$(PKGDIR)/DEBIAN
	mkdir -p				$(PKGDIR)/etc/rc.d
	mkdir -p				$(PKGDIR)/usr/local/etc
	mkdir -p				$(PKGDIR)/usr/local/libexec
	mkdir -p				$(PKGDIR)/usr/local/share/v4l2rtspserver/examples
	install -cm 0644 control		$(PKGDIR)/DEBIAN
	sed -i s/@@ARCH@@/$(PKGARCH)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g	$(PKGDIR)/DEBIAN/control
	install -cm 0755 postinst		$(PKGDIR)/DEBIAN
	install -cm 0755 startup		$(PKGDIR)/etc/rc.d/S99-v4l2rtspserver
	install -cm 0755 $(SRCDIR)/v4l2rtspserver $(PKGDIR)/usr/local/libexec
	$(CROSS_COMPILE)strip			$(PKGDIR)/usr/local/libexec/*
	install -cm 0644 v4l2rtspserver.conf	$(PKGDIR)/usr/local/share/v4l2rtspserver/examples
	touch $@

package.deb: $(PKGFILE)

# Upload package to repository

upload: $(PKGFILE)
	scp $^ $(REPOSITORY)

# Download prebuilt package

download_prebuilt: $(PKGFILE).downloaded

$(PKGFILE).downloaded:
	wget -q -nc $(DOWNLOADPREFIX)/extensions/$(PKGFILE)
	touch $(PKGFILE).downloaded

# Remove working files

clean:
	rm -rf $(PKGDIR)
	if [ ! -f $(PKGFILE).downloaded ]; then rm -f $(PKGFILE) ; fi

reallyclean: clean
	rm -rf build.done source.done $(SRCDIR) $(PKGFILE) $(PKGFILE).downloaded

distclean: reallyclean
