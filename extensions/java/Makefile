# Makefile for building the Java runtime package for MuntsOS

# Copyright (C)2026, Philip Munts dba Munts Technologies.
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

JDKVERSION	= 25.0.2
ifeq ($(ARCH), arm64)
JDKARCH		= linux-aarch64
endif
JDKTARBALL	= openjdk-$(JDKVERSION)_$(JDKARCH)_bin.tar.gz
JDKDIST		= /tmp/$(JDKTARBALL)
JDKDIR		= jdk-$(JDKVERSION)

JREDIR		= openjdk-$(JDKVERSION)

JLINK		?= jlink
JLINKOPTIONS	+= --compress zip-9
JLINKOPTIONS	+= --no-header-files
JLINKOPTIONS	+= --no-man-pages
JLINKOPTIONS	+= --module-path ./$(JDKDIR)/jmods
JLINKOPTIONS	+= --add-modules ALL-MODULE-PATH
JLINKOPTIONS	+= --output $(JREDIR)

PKGNAME		= java
PKGVERSION	= $(shell date +%Y.%j)
PKGARCH		= $(DEBARCH)
PKGDIR		= $(PKGNAME)-muntsos-$(BOARDARCH)
PKGFILE		= $(PKGDIR).deb

default: package.deb

# Unpack JDK release tarball

$(JDKDIR): $(JDKDIST)
	tar xzf $(JDKDIST)

# Build JRE with jlink

$(JREDIR): $(JDKDIR)
	$(JLINK) $(JLINKOPTIONS)

# Build the Debian package file

$(PKGDIR): $(JREDIR)
	mkdir -p				$@/DEBIAN
	install -cm 0644 control		$@/DEBIAN
	sed -i s/@@ARCH@@/$(PKGARCH)/g		$@/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g		$@/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g	$@/DEBIAN/control
	mkdir -p				$@/usr/local/bin
	ln -s ../lib/$(JREDIR)/bin/java		$@/usr/local/bin/java
	mkdir -p				$@/usr/local/lib
	cp -R -P -p $(JREDIR)			$@/usr/local/lib
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/jar
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/jarsigner
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/javac
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/javadoc
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/javap
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/jcmd
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/jconsole
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/jdb
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/jdeprscan
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/jdeps
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/jfr
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/jhsdb
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/jimage
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/jinfo
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/jlink
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/jmap
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/jmod
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/jnativescan
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/jpackage
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/jps
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/jrunscript
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/jshell
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/jstack
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/jstat
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/jstatd
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/jwebserver
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/keytool
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/rmiregistry
	rm -f					$@/usr/local/lib/$(JREDIR)/bin/serialver
	$(CROSS_COMPILE)strip			$@/usr/local/lib/$(JREDIR)/bin/*
	$(CROSS_COMPILE)strip			$@/usr/local/lib/$(JREDIR)/lib/*.so
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
	rm -rf $(PKGFILE) $(PKGFILE).downloaded
	rm -rf $(JDKDIR) $(JREDIR)

distclean: reallyclean
