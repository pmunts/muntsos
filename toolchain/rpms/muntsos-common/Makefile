# Makefile to build the MuntsOS Embedded Linux Common Files package

# Copyright (C)2023-2024, Philip Munts dba Munts Technologies.
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

MUNTSOS		:= /usr/local/share/muntsos
BUILDNUM	?= 1
RPMDIR		:= muntsos-common
RPMVER		:= $(shell date +%Y.%j)
RPMFILE		:= $(RPMDIR)-$(RPMVER)-$(BUILDNUM).noarch.rpm

DSTDIR		:= $(RPMDIR)/usr/local/share/muntsos

# Create RPM package file

package.rpm:
	cp specfile.template			specfile
	sed -i 's/@@BUILDNUM@@/$(BUILDNUM)/g'	specfile
	sed -i 's/@@VERSION@@/$(RPMVER)/g'	specfile
	mkdir -p				$(DSTDIR)
	cp -R -P -p $(MUNTSOS)/doc		$(DSTDIR)
	cp -R -P -p $(MUNTSOS)/examples		$(DSTDIR)
	cp -R -P -p $(MUNTSOS)/include		$(DSTDIR)
	rm -rf					$(DSTDIR)/doc/.blinky
	rm -rf					$(DSTDIR)/doc/.rawhid
	rm -rf					$(DSTDIR)/examples/README.*
	rm -rf					$(DSTDIR)/examples/firmware
	rm -rf					$(DSTDIR)/examples/ada/freemodbus
	chmod -R u+w				$(DSTDIR)
	sed -i 's@$$(HOME)/muntsos@/usr/local/share/muntsos@g' $(DSTDIR)/examples/*/*/Makefile
	cd $(RPMDIR) && find usr/local/share -type d -exec echo "%dir /{}" ";" >>../specfile
	cd $(RPMDIR) && find usr/local/share -type f -exec echo "/{}" ";"      >>../specfile
	rpmbuild --buildroot=`pwd`/$(RPMDIR) --define="_topdir `pwd`/rpmbuild" -bb specfile
	cp rpmbuild/RPMS/*/*.rpm .
	rm -rf rpmbuild specfile

###############################################################################

# Remove working files

clean:
	-rm -rf $(RPMDIR) $(RPMFILE) rpmbuild specfile

reallyclean: clean

distclean: reallyclean
