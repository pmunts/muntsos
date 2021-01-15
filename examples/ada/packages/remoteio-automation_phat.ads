-- Remote I/O Resources available from a Pimoroni Automation pHAT

-- Copyright (C)2019, Philip Munts, President, Munts AM Corp.
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

PACKAGE RemoteIO.Automation_pHAT IS

  -- Analog inputs

  ADC1    : CONSTANT RemoteIO.ChannelNumber := 1;
  ADC2    : CONSTANT RemoteIO.ChannelNumber := 2;
  ADC3    : CONSTANT RemoteIO.ChannelNumber := 3;

  -- GPIO pins

  LED     : CONSTANT RemoteIO.ChannelNumber := 0;  -- Raspberry Pi user LED
  INPUT1  : CONSTANT RemoteIO.ChannelNumber := 1;
  INPUT2  : CONSTANT RemoteIO.ChannelNumber := 2;
  INPUT3  : CONSTANT RemoteIO.ChannelNumber := 3;
  OUTPUT1 : CONSTANT RemoteIO.ChannelNumber := 4;
  OUTPUT2 : CONSTANT RemoteIO.ChannelNumber := 5;
  OUTPUT3 : CONSTANT RemoteIO.ChannelNumber := 6;
  RELAY1  : CONSTANT RemoteIO.ChannelNumber := 7;

  -- SPI bus

  SPI0    : CONSTANT RemoteIO.ChannelNumber := 0;

END RemoteIO.Automation_pHAT;
