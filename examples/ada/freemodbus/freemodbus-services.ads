-- Service callback declarations for the FreeMODBUS library.  Each ModBUS RTU
-- program must implement this package to provide the callback functions.

-- Copyright (C)2019-2020, Philip Munts, President, Munts AM Corp.
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

WITH Interfaces.C;

PACKAGE FreeMODBUS.Services IS

  TYPE byte      IS NEW Interfaces.C.unsigned_char;
  TYPE int       IS NEW Interfaces.C.int;
  TYPE word      IS NEW Interfaces.C.unsigned_short;
  TYPE dword     IS NEW Interfaces.C.unsigned_long;

  TYPE bytearray IS ARRAY (word range <>) OF byte;
  TYPE wordarray IS ARRAY (word range <>) OF word;

  -- Discrete inputs

  FUNCTION eMBRegDiscreteCB
   (buf   : IN OUT bytearray;
    addr  : word;
    count : word) RETURN int;

 -- Coils

  FUNCTION eMBRegCoilsCB
   (buf   : IN OUT bytearray;
    addr  : word;
    count : word;
    mode  : int) RETURN int;

  -- Input registers

  FUNCTION eMBRegInputCB
   (buf   : IN OUT wordarray;
    addr  : word;
    count : word) RETURN int;

  -- Holding registers

  FUNCTION eMBRegHoldingCB
   (buf   : IN OUT wordarray;
    addr  : word;
    count : word;
    mode  : int) RETURN int;

  -- These services will be called from a C main program

  PRAGMA Export(C, eMBRegDiscreteCB,   "eMBRegDiscreteCB");
  PRAGMA Export(C, eMBRegCoilsCB,      "eMBRegCoilsCB");
  PRAGMA Export(C, eMBRegInputCB,      "eMBRegInputCB");
  PRAGMA Export(C, eMBRegHoldingCB,    "eMBRegHoldingCB");
END FreeMODBUS.Services;
