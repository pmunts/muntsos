-- Remote I/O Resources available from a Pimoroni Enviro pHAT

-- Copyright (C)2019-2024, Philip Munts dba Munts Technologies.
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

PACKAGE RemoteIO.Enviro_pHAT IS

  -- Analog inputs

  AIN0 : CONSTANT RemoteIO.ChannelNumber := 0;
  AIN1 : CONSTANT RemoteIO.ChannelNumber := 1;
  AIN2 : CONSTANT RemoteIO.ChannelNumber := 2;
  AIN3 : CONSTANT RemoteIO.ChannelNumber := 3;

  -- GPIO pins

  LED  : CONSTANT RemoteIO.ChannelNumber := 0;  -- Raspberry Pi user LED
  LEDS : CONSTANT RemoteIO.ChannelNumber := 1;  -- White LED's on Enviro pHAT

  -- I2C bus

  I2C0 : CONSTANT RemoteIO.ChannelNumber := 0;

END RemoteIO.Enviro_pHAT;
