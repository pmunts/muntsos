# Makefile to build a MacOS app bundle from a Mono .exe program

# Copyright (C)2016-2024, Philip Munts dba Munts Technologies.
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

# Build a MacOS app bundle

%.app: %.exe
	echo "DEBUG: stem is $*"
	mkdir -p 					$@/Contents/MacOS
	mkdir -p					$@/Contents/Resources
	cp $(CSHARPSRC)/MacOS/info.plist.template	$@/Contents/info.plist
	sed -i '' 's/@@APPNAME@@/$*/g'			$@/Contents/info.plist
	sed -i '' 's/@@APPVER@@/$*/g'			$@/Contents/info.plist
	install -cm 0755 $(CSHARPSRC)/Macos/run.sh.template $@/Contents/MacOS/$*
	sed -i '' 's/@@APPNAME@@/$*/g'			$@/Contents/MacOS/$*
	install -cm 0755 $*.exe				$@/Contents/MacOS
	cp $*.icns					$@/Contents/Resources
ifneq ($(EXTRAFILES),)
	cp $(EXTRAFILES)				$@/Contents/MacOS
endif
	chmod -R ugo-w $@

# Zip up the MacOS app bundle

%.zip: %.app
	zip -r $@ $^
