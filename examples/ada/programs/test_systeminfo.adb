-- System info services test client

-- Copyright (C)2017-2024, Philip Munts dba Munts Technologies.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- * Redistributions of source code must retain the above copyright notice,
--   this list of conditions and the following disclaimer.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH ClickBoard.Shields;
WITH SystemInfo;

PROCEDURE test_systeminfo IS

BEGIN
  Put_Line("System Info Test");
  New_Line;

  -- Display system information

  Put_Line("Compiler:     " & Standard'Compiler_Version);
  Put_Line("Platform:     " & SystemInfo.ModelName);
  Put_Line("OS name:      " & SystemInfo.OSName);
  Put_Line("Board family: " & SystemInfo.BoardFamily);
  Put_Line("Board name:   " & SystemInfo.BoardName);
  Put_Line("Shield name:  " & SystemInfo.ShieldName);
  Put_Line("Shield kind:  " & ClickBoard.Shields.Kind'Image(ClickBoard.Shields.Detect));
END test_systeminfo;
