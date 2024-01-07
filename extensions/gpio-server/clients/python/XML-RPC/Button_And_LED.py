#!/usr/bin/python3

# MuntsOS GPIO Thin Server Button and LED Test

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

import sys
import time
import xmlrpc.client

BUTTON = 19
LED = 26

# Display startup banner

print('\nMuntsOS GPIO Thin Server Button and LED Test\n')

if len(sys.argv) != 2:
  print('Usage: Button_And_LED.py <servername>\n')
  exit(1)

# Build XML-RPC server URL

URL = 'http://' + sys.argv[1] + ':8084/RPC2'

# Build XML-RPC client proxy object

s = xmlrpc.client.ServerProxy(URL)

# Configure GPIO pins

result = s.gpio.open(BUTTON, 0, 0)
if (result < 0):
  print("gpio.open failed, err=" + str(-result))
  exit(1)

result = s.gpio.open(LED, 1, 0)
if (result < 0):
  print("gpio.open failed, err=" + str(-result))
  exit(1)

# Force initial state change

result = s.gpio.read(BUTTON)
if (result < 0):
  print("gpio.read failed, err=" + str(-result))
  exit(1)

ButtonOld = not result

# Sense button and update LED

try:
  while True:
    result = s.gpio.read(BUTTON)
    if (result < 0):
      print("gpio.read failed, err=" + str(-result))
      exit(1)

    ButtonNew = result

    if ButtonNew != ButtonOld:
      if ButtonNew:
        print("PRESSED")
      else:
        print("RELEASED")

      result = s.gpio.write(LED, ButtonNew)
      if (result < 0):
        print("gpio.write failed, err=" + str(-result))
        exit(1)

      ButtonOld = ButtonNew

      time.sleep(0.1)
except:
  exit(0)
