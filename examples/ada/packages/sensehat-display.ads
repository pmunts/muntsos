-- Raspberry Pi Sense Hat LED matrix display services

-- Copyright (C)2016-2024, Philip Munts dba Munts Technologies.
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

-- 8 by 8 LED Display layout:

-- Top left LED     is row 0 column 0
-- Bottom right LED is row 7 column 7

WITH TrueColor;

PACKAGE SenseHAT.Display IS

  SUBTYPE Screen IS TrueColor.Screen(0 .. 7, 0 .. 7);

  -- Display instance

  Display : CONSTANT TrueColor.Display;

PRIVATE

  -- Display device class definition

  TYPE DisplaySubclass IS NEW TrueColor.DisplayInterface WITH NULL RECORD;

  -- Write a single pixel

  PROCEDURE Put
   (self  : DisplaySubclass;
    row   : Natural;
    col   : Natural;
    value : TrueColor.Pixel);

  -- Write a pixel buffer to the display

  PROCEDURE Put(self : DisplaySubclass; buf : TrueColor.Screen);

  -- Clear the display

  PROCEDURE Clear(self : DisplaySubclass);

  -- Display instance

  Display : CONSTANT TrueColor.Display := NEW DisplaySubclass'(NULL RECORD);

END SenseHAT.Display;
