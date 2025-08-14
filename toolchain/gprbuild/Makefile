# Makefile for Alire gprbuild package

DISTDIR		:= $(HOME)/.local/share/alire/toolchains/gprbuild_22.0.1_24dfc1b5
DISTVERSION	:= 22.0.1

BUILDNUM	?= 1
PKGNAME		:= muntsos-gprbuild
PKGVERSION	:= $(DISTVERSION)
PKGARCH		:= $(shell dpkg --print-architecture)
PKGDIR		:= $(PKGNAME)-$(PKGVERSION)-$(PKGARCH)
PKGFILE		:= $(PKGDIR).deb

GAINROOT	?= fakeroot

default: $(PKGFILE)

# Populate the Debian package file system

$(PKGDIR): $(DISTFILE)
	mkdir -p $(PKGDIR)/DEBIAN
	install -cm 0444 control		$@/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g		$@/DEBIAN/control
	sed -i s/@@ARCH@@/$(PKGARCH)/g		$@/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g	$@/DEBIAN/control
	mkdir -p				$@/usr/local/muntsos-gprbuild
	cp -R -P -p $(DISTDIR)/*		$@/usr/local/muntsos-gprbuild

# Build the Debian package

$(PKGFILE): $(PKGDIR)
	chmod -R ugo-w $(PKGDIR)/usr
	$(GAINROOT) dpkg-deb --build $(PKGDIR)
	chmod -R u+w $(PKGDIR)/usr

# Upload to the Debian package repository

upload: $(PKGFILE)
	scp *.deb root@munts.net:.

# Remove working files

clean:
	rm -rf $(PKGDIR) $(PKGFILE)

reallyclean: clean

distclean: reallyclean
	rm -f $(DISTFILE)
