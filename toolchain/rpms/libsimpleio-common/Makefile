# Makefile to build RPM package libsimpleio-common

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

LIBSIMPLEIO	?= ..
BUILDNUM	?= 1
RPMDIR		:= libsimpleio-common
RPMVER		:= $(shell date +%Y.%j).$(BUILDNUM)
RPMFILE		:= $(RPMDIR)-$(RPMVER)-$(BUILDNUM).noarch.rpm

SRCDIR		:= /usr/local/share/libsimpleio
DSTDIR		:= $(RPMDIR)$(SRCDIR)

default: package.rpm

# Create RPM package file

package.rpm:
	cp specfile.template			specfile
	sed -i 's/@@VERSION@@/$(RPMVER)/g'	specfile
	mkdir -p				$(DSTDIR)
	cp -R -P -p $(SRCDIR)/*			$(DSTDIR)
	chmod -R u+w				$(DSTDIR)
	cp $(SRCDIR)/ada/projects/default.gpr	$(DSTDIR)/ada/programs
	cp $(SRCDIR)/ada/projects/default.gpr	$(DSTDIR)/ada/programs/munts-0018
	rm -rf					$(DSTDIR)/ada/lib
	rm -rf					$(DSTDIR)/ada/projects
	cd $(RPMDIR) && find usr/local/share/libsimpleio -type d -exec echo "%dir /{}" ";" >>../specfile
	cd $(RPMDIR) && find usr/local/share/libsimpleio -type f -exec echo "/{}" ";"      >>../specfile
	rpmbuild --buildroot=`pwd`/$(RPMDIR) --define="_topdir `pwd`/rpmbuild" -bb specfile
	cp rpmbuild/RPMS/*/*.rpm .	
	rm -rf rpmbuild

###############################################################################

# Remove working files

clean:
	-rm -rf $(RPMDIR) $(RPMFILE) rpmbuild specfile

reallyclean: clean

distclean: reallyclean
