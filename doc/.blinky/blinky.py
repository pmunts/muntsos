#! /usr/bin/python3

from libsimpleio.gpio        import Pin, Direction
from libsimpleio.raspberrypi import GPIO26

import time

print("\nMuntsOS Python3 LED Test\n")

LED = Pin(GPIO26, Direction.Output)

while True:
  LED.state = not LED.state
  time.sleep(0.5)
