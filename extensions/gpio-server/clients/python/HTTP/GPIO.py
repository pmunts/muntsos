#!/usr/bin/python3

# MuntsOS GPIO Thin Server Client Functions Using HTTP

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

import urllib.request

# Configure GPIO pin direction

def configure(server, pin, direction):
  URL = 'http://' + server + ':8083/GPIO/ddr/' + str(pin) + ',' + str(direction)
  result = urllib.request.urlopen(URL)
  for line in result:
    response = line.decode('latin-1').strip()
    if response != 'DDR' + str(pin) + '=' + str(direction):
      print('ERROR: Invalid response to ddr: ' + response)
      exit(1)

# Read GPIO pin state

def read(server, pin):
  URL = 'http://' + server + ':8083/GPIO/get/' + str(pin)
  result = urllib.request.urlopen(URL)
  for line in result:
    response = line.decode('latin-1').strip()
    if response == 'GPIO' + str(pin) + '=0':
      return 0
    elif response == 'GPIO' + str(pin) + '=1':
      return 1
    else:
      print('ERROR: Invalid response to get: ' + response)
      exit(1)

# Write GPIO pin state

def write(server, pin, value):
  URL = 'http://' + server + ':8083/GPIO/put/' + str(pin) + ',' + str(value)
  result = urllib.request.urlopen(URL)
  for line in result:
    response = line.decode('latin-1').strip()
    if response != 'GPIO' + str(pin) + '=' + str(value):
      print('ERROR: Invalid response to put: ' + response)
      exit(1)
