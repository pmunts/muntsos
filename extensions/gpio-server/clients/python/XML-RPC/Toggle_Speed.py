#!/usr/bin/python3

# MuntsOS GPIO Thin Server Toggle Speed Test

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

LED = 26
ITERATIONS = 10000

# Display startup banner

print('\nMuntsOS GPIO Thin Server Toggle Speed Test\n')

if len(sys.argv) != 2:
  print('Usage: Toggle_Speed.py <servername>\n')
  exit(1)

# Build XML-RPC server URL

URL = 'http://' + sys.argv[1] + ':8084/RPC2'

# Build XML-RPC client proxy object

s = xmlrpc.client.ServerProxy(URL)

# Configure GPIO pins

result = s.gpio.open(LED, 1, 0)
if (result < 0):
  print('gpio.open failed, err=' + str(-result))
  exit(1)

# Conduct speed test

print('Performing %d GPIO writes...\n' % ITERATIONS);

start = time.time()

for i in range(ITERATIONS//2):
  s.gpio.write(LED, 0)
  s.gpio.write(LED, 1)

stop = time.time()

# Display results

deltat = stop - start

print('Performed %d GPIO writes in %1.1f seconds' % (ITERATIONS, deltat))
print('  %1.1f iterations per second' % (ITERATIONS/deltat,))
print('  %1.1f microseconds per iteration\n' % (1000000/ITERATIONS*deltat,))
