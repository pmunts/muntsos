REM This script sets up an x86-64 Windows 10/11 machine for
REM developing applications for MuntsOS Embedded Linux

REM Copyright (C)2025, Philip Munts dba Munts Technologies.
REM
REM Redistribution and use in source and binary forms, with or without
REM modification, are permitted provided that the following conditions are met:
REM
REM * Redistributions of source code must retain the above copyright notice,
REM   this list of conditions and the following disclaimer.
REM
REM THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
REM AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
REM IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
REM ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
REM LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
REM CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
REM SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
REM INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
REM CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
REM ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
REM POSSIBILITY OF SUCH DAMAGE.

REM Create MuntsOS/ and make it filename case sensitive

cd C:\PROGRA~1
mkdir MuntsOS
fsutil.exe file setCaseSensitiveInfo MuntsOS enable
cd MuntsOS

REM Clone git repositories

git clone https://git.munts.com/gcc-aarch64-muntsos-linux-gnu-ctng.git
git clone https://git.munts.com/gcc-arm-muntsos-linux-gnueabihf-ctng-raspberrypi1.git
git clone https://github.com/pmunts/libsimpleio.git
git clone https://github.com/pmunts/muntsos.git

cd C:\PROGRA~1
chown -R Administrators.None MuntsOS
