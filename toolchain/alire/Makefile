# Makefile for packaging the Ada Library Repository

ALRNAME		= alire
ALRVERSION	= 2.1.0
ALRSRC		= $(ALRNAME).src

BUILDNUM	?= 1

PKGNAME		:= $(ALRNAME)
PKGARCH		:= $(shell dpkg --print-architecture)
PKGVERSION	:= $(ALRVERSION)-$(BUILDNUM)
PKGDIR		:= $(PKGNAME)-$(PKGVERSION)-$(PKGARCH)
PKGFILE		:= $(PKGDIR).deb

RPMNAME		:= $(ALRNAME)
RPMVER		:= $(ALRVERSION)
RPMARCH		?= x86_64
RPMDIR		:= $(RPMNAME)
RPMFILE		:= $(RPMNAME)-$(RPMVER)-$(BUILDNUM).$(RPMARCH).rpm

GAINROOT	?= fakeroot

default: $(PKGFILE)

# Download source distribution

source.done: $(ALRDIST)
	git clone --branch v$(ALRVERSION) --recurse-submodules https://github.com/alire-project/alire.git alire.src
	cd $(ALRSRC) && patch -b -p0 <../alire.patch
	touch $@

# Build alr

build.done: source.done
	cd $(ALRSRC) && ALIRE_OS=linux gprbuild -j0 -P alr_env
	strip $(ALRSRC)/bin/alr
	touch $@

# Build Debian package

$(PKGFILE): build.done
	mkdir -p				$(PKGDIR)/DEBIAN
	install -cm 0444 control		$(PKGDIR)/DEBIAN
	sed -i s/@@ARCH@@/$(PKGARCH)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@NAME@@/$(PKGNAME)/g		$(PKGDIR)/DEBIAN/control
	sed -i s/@@VERSION@@/$(PKGVERSION)/g	$(PKGDIR)/DEBIAN/control
	mkdir -p				$(PKGDIR)/usr/local/bin
	install -csm 0755 $(ALRSRC)/bin/alr	$(PKGDIR)/usr/local/bin
	mkdir -p				$(PKGDIR)/usr/local/share/alire
	install -cm 0644 $(ALRSRC)/LICENSE.txt	$(PKGDIR)/usr/local/share/alire
	chmod -R ugo-w				$(PKGDIR)/usr
	$(GAINROOT) chown -R root.root		$(PKGDIR)
	$(GAINROOT) dpkg-deb --build		$(PKGDIR)
	$(GAINROOT) chown -R $(shell id -nu).$(shell id -ng) $(PKGDIR) $(PKGFILE)
	chmod -R u+w				$(PKGDIR)/usr

dpkg: $(PKGFILE)

# Build RPM package

$(RPMFILE): build.done
	cp specfile.template			specfile
	sed -i 's/@@VERSION@@/$(RPMVER)/g'	specfile
	sed -i 's/@@BUILDNUM@@/$(BUILDNUM)/g'	specfile
	sed -i 's/@@ARCH@@/$(RPMARCH)/g'	specfile
	mkdir -p				$(RPMDIR)/usr/local/bin
	install -csm 0755 $(ALRSRC)/bin/alr	$(RPMDIR)/usr/local/bin
	mkdir -p				$(RPMDIR)/usr/local/share/alire
	install -cm 0644 $(ALRSRC)/LICENSE.txt	$(RPMDIR)/usr/local/share/alire
	cd $(RPMDIR) && find usr/local/bin         -type f -exec echo "/{}" ";"      >>../specfile
	cd $(RPMDIR) && find usr/local/share/alire -type d -exec echo "%dir /{}" ";" >>../specfile
	cd $(RPMDIR) && find usr/local/share/alire -type f -exec echo "/{}" ";"      >>../specfile
	rpmbuild --buildroot=`pwd`/$(RPMDIR) --define="_topdir `pwd`/rpmbuild" -bb specfile
	cp rpmbuild/RPMS/*/*.rpm .
	rm -rf rpmbuild specfile

rpm: $(RPMFILE)

# Remove working files

clean:
	-rm -rf build.done rpmbuild specfile *.deb *.rpm $(ALRSRC)/obj $(PKGDIR) $(RPMDIR)

reallyclean: clean
	-rm -rf source.done $(ALRSRC)

distclean: reallyclean
