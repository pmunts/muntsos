; InnoSetup installer script for the Small Basic GPIO Client Extension

; Copyright (C)2016-2024, Philip Munts dba Munts Technologies.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; * Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
;
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
; POSSIBILITY OF SUCH DAMAGE.

[Setup]
AppName=LabView GPIO Tests using LINX
AppVersion={#APPVERSION}
AppPublisher=Munts Technologies
AppPublisherURL=http://tech.munts.com
DefaultDirName={pf}\Labview-GPIO-Tests-LINX
DefaultGroupName={#SetupSetting("AppName")}
DirExistsWarning=no
Compression=lzma2
SolidCompression=yes
OutputBaseFilename=LabView-GPIO-Tests-LINX-{#APPVERSION}-setup
OutputDir=.
UninstallFilesDir={app}/LabView-GPIO-Tests-LINX-uninstall

[Files]
Source: "*.exe"; DestDir: "{app}"
Source: "*.pdf"; DestDir: "{app}"

[Icons]
Name: "{group}\Button And LED Test";		Filename: "{app}\Button_And_LED.exe";		WorkingDir: "{app}"
Name: "{group}\Button And LED Test.pdf";	Filename: "{app}\Button_And_LED.pdf";		WorkingDir: "{app}"
