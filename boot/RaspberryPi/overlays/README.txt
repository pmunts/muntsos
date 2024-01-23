         MuntsOS Embedded Linux Extra Raspberry Pi Device Tree Overlays

   Here are some collected device tree overlays for the Raspberry Pi,
   customized for MuntsOS.

Configuration Examples

   Following are the entries that must be added to /boot/config.txt for
   the device tree overlays that support some [1]HATS and [2]Click Boards.

  [3]Adafruit Motor HAT:

dtoverlay=PCA9685,addr=0x60

  [4]Adafruit Servo HAT:

dtoverlay=PCA9685,addr=0x40

  [5]Mikroelektronika Pi 3 Click Shield MCP3204 A/D Converter:

dtoverlay=Pi3ClickShield

  [6]Mikroelektronika Expand 2 Click:

    Plugged into [7]Pi 2 Click Shield Socket 1:

dtoverlay=MCP23017,addr=0x20,gpiopin=6

  [8]Mikroelektronika Expand 2 Click:

    Plugged into [9]Pi 2 Click Shield Socket 2:

dtoverlay=MCP23017,addr=0x20,gpiopin=26

  [10]Mikroelektronika PWM Click:

dtoverlay=PCA9685,addr=0x40

  [11]ARPI600 Arduino Shield Adapter:

dtoverlay=PCF8563,addr=0x51

  [12]Pimoroni Automation pHAT Analog to Digital Converter

    Single ended inputs with 8V full scale range:

dtoverlay=ADS1015,addr=0x48
dtparam=cha_enable
dtparam=chb_enable
dtparam=chc_enable
dtparam=cha_cfg=4
dtparam=chb_cfg=5
dtparam=chc_cfg=6
dtparam=cha_gain=3
dtparam=chb_gain=3
dtparam=chc_gain=3

  [13]Pimoroni Enviro pHAT Analog to Digital Converter

    Single ended inputs with 6.144V full scale range:

dtoverlay=ADS1015,addr=0x49
dtparam=cha_enable
dtparam=chb_enable
dtparam=chc_enable
dtparam=chd_enable
dtparam=cha_cfg=4
dtparam=chb_cfg=5
dtparam=chc_cfg=6
dtparam=chd_cfg=7
dtparam=cha_gain=0
dtparam=chb_gain=0
dtparam=chc_gain=0
dtparam=chd_gain=0

  [14]GeeekPi ENC28J60 Hat

dtoverlay=ENC28J60

Copyright:

   Original works herein are copyrighted as follows:

Copyright (C)2017-2024, Philip Munts dba Munts Technologies.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

   Redistributed works herein are copyrighted and/or licensed by their
   respective authors.
   _______________________________________________________________________

   Questions or comments to Philip Munts [15]phil@munts.net

References

   1. https://www.raspberrypi.org/blog/introducing-raspberry-pi-hats
   2. https://shop.mikroe.com/click
   3. https://www.adafruit.com/product/2348
   4. https://www.adafruit.com/product/2327
   5. https://www.mikroe.com/pi-3-click-shield
   6. https://www.mikroe.com/expand-2-click
   7. https://www.mikroe.com/pi-2-click-shield
   8. https://www.mikroe.com/expand-2-click
   9. https://www.mikroe.com/pi-2-click-shield
  10. https://shop.mikroe.com/click/interface/pwm
  11. https://www.waveshare.com/arpi600.htm
  12. https://shop.pimoroni.com/products/automation-phat
  13. https://shop.pimoroni.com/products/enviro-phat
  14. https://wiki.52pi.com/index.php/Pi_Zero_Enc28j60_Network_Adapter_Module_SKU:_EP-0088
  15. mailto:phil@munts.net
