#!/usr/bin/python3

# MuntsOS GPIO Thin Server Button and LED Test

# Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
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

import GPIO
import sys
import time

BUTTON = 19
LED = 26

# Display startup banner

print('\nMuntsOS GPIO Thin Server Button and LED Test\n')

if len(sys.argv) != 2:
  print('Usage: Button_And_LED.py <servername>\n')
  exit(1)

# Configure GPIO pins

GPIO.configure(sys.argv[1], BUTTON, 0)
GPIO.configure(sys.argv[1], LED, 1)

# Force initial state change

ButtonOld = not GPIO.read(sys.argv[1], BUTTON)

# Sense button and update LED

try:
  while True:
    ButtonNew = GPIO.read(sys.argv[1], BUTTON)

    if ButtonNew != ButtonOld:
      if ButtonNew:
        print("PRESSED")
      else:
        print("RELEASED")

      GPIO.write(sys.argv[1], LED, ButtonNew)

      ButtonOld = ButtonNew

      time.sleep(0.1)
except:
  exit(0)
