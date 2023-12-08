# Makefile to build an MuntsOS Embedded Linux cross-toolchain RPM package

# Copyright (C)2023, Philip Munts.
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

LIBSIMPLEIO	:= /usr/local/share/libsimpleio
MUNTSOS		:= /usr/local/share/muntsos

BUILDNUM	?= 1
RPMTARGET	?= unknown
RPMSUFFIX	?= unknown
RPMTUPLE	?= unknown
RPMNAME		:= muntsos-$(RPMSUFFIX)
RPMVER		:= $(shell date +%Y.%j).$(BUILDNUM)
RPMDIR		:= $(RPMNAME)
RPMFILE		:= $(RPMNAME)-$(RPMVER)-$(BUILDNUM).x86_64.rpm

default: package.rpm

###############################################################################

# Create RPM package file

package.rpm:
	cp specfile.template			specfile
	sed -i 's/@@TARGET@@/$(RPMTARGET)/g'	specfile
	sed -i 's/@@SUFFIX@@/$(RPMSUFFIX)/g'	specfile
	sed -i 's/@@VERSION@@/$(RPMVER)/g'	specfile
	mkdir -p				$(RPMDIR)/usr/local
	cp -R -P -p /usr/local/fpc-$(RPMTUPLE)	$(RPMDIR)/usr/local
	cp -R -P -p /usr/local/gcc-$(RPMTUPLE)	$(RPMDIR)/usr/local
	chmod -R u+w				$(RPMDIR)/usr/local
	cd $(RPMDIR) && find usr/local/fpc-$(RPMTUPLE) -type d -exec echo "%dir /{}" ";" >>../specfile
	cd $(RPMDIR) && find usr/local/fpc-$(RPMTUPLE) -type f -exec echo "/{}" ";"      >>../specfile
	cd $(RPMDIR) && find usr/local/fpc-$(RPMTUPLE) -type l -exec echo "/{}" ";"      >>../specfile
	cd $(RPMDIR) && find usr/local/gcc-$(RPMTUPLE) -type d -exec echo "%dir /{}" ";" >>../specfile
	cd $(RPMDIR) && find usr/local/gcc-$(RPMTUPLE) -type f -exec echo "/{}" ";"      >>../specfile
	cd $(RPMDIR) && find usr/local/gcc-$(RPMTUPLE) -type l -exec echo "/{}" ";"      >>../specfile
	rpmbuild --buildroot=`pwd`/$(RPMDIR) --define="_topdir `pwd`/rpmbuild" -bb specfile
	cp rpmbuild/RPMS/*/*.rpm .
	rm -rf rpmbuild specfile

###############################################################################

# Remove working files

clean:
	-rm -rf $(RPMDIR) $(RPMFILE) rpmbuild specfile

reallyclean: clean

distclean: reallyclean
