# LoRa Thermometer Example using Mikroelektronica Thermo Click thermocouple
# interface

# Copyright (C)2025, Philip Munts dba Munts Technologies.
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

# Installation:
#
# mkdir -p              /usr/local/etc/therm
# install -cm 0644 *.py /usr/local/etc/therm
# chmod -R ugo-w        /usr/local/etc/therm
# mount -orw /boot
# install -cm 0644 *.sh /boot/autoexec.d
# umount /boot
# sysconfig --save

# Reference Hardware Stack:
#
# Raspberry Pi 2 v1.2 (64-bit)
# Mikroelektronika Pi 3 Click Shield MIKROE-2756
# Mikroelektronika LoRa 10 Click MIKROE-5986 in mikrobus socket 1
# Mikroelektronika Thermo Click  MIKROE-5767 in mikroBUS socket 2
# 
# Add the following device tree overlay commands to /boot/config.txt:
#
# dtoverlay=Pi3ClickShield
# dtoverlay=anyspi:spi0-1,dev="maxim,max31855k",speed=5000000

__author__	= 'Philip Munts <phil@munts.net>'

import ctypes
import os
import time

# Initialize the Wio-E5 LoRa Transceiver Module

LoRa      = ctypes.cdll.LoadLibrary('libwioe5ham1.so')

portname  = bytes(os.environ['WIOE5_PORT'], encoding='ascii')
baudrate  = int(os.environ['WIOE5_BAUD'])
network   = bytes(os.environ['WIOE5_NETWORK'], encoding='ascii')
node      = int(os.environ['WIOE5_NODE'])
freq      = ctypes.c_float(float(os.environ['WIOE5_FREQ']))
handle    = ctypes.c_int()
error     = ctypes.c_int()
cmd       = ctypes.create_string_buffer(241)
cmdlen    = ctypes.c_int()
src       = ctypes.c_int()
dst       = ctypes.c_int()
RSS       = ctypes.c_int()
SNR       = ctypes.c_int()

LoRa.wioe5ham1_init(portname, baudrate, network, node, freq, 7, 500, 12, 15,
  22, ctypes.byref(handle), ctypes.byref(error))

if error.value != 0:
  print('ERROR: LoRa.wioe5ham1_init() failed')
  exit(1)

# Open temperature sensor files

rawfile   = open('/sys/bus/iio/devices/iio:device0/in_temp_raw', 'r')
scalefile = open('/sys/bus/iio/devices/iio:device0/in_temp_scale', 'r')

while True:

# Wait for measurement command

  LoRa.wioe5ham1_receive(handle.value, cmd, ctypes.byref(cmdlen),
    ctypes.byref(src), ctypes.byref(dst), ctypes.byref(RSS),
    ctypes.byref(SNR), ctypes.byref(error))

  if cmdlen.value != 7:
    continue
  
  cmd[cmdlen.value] = b'\x00'

  if cmd.value.decode('ascii') != 'MEASURE':
    continue

# Measure the thermocouple temperature

  rawfile.seek(0)
  scalefile.seek(0)

  temp = float(rawfile.read())*float(scalefile.read())/1000.0

# Build response string

  resp = 'TEMP:' + str(temp) + ' RSS:' + str(RSS.value) + ' SNR:' + str(SNR.value)

# Transmit response string

  LoRa.wioe5ham1_send(handle.value, bytes(resp, encoding='ascii'), len(resp),
    src.value, ctypes.byref(error))

  if error.value != 0:
    print('ERROR: wioe5ham1_send() failed, error=' + str(error.value))
