MuntsOS Embedded Linux Extra Device Tree Overlays

Here are some collected device tree overlays for Raspberry Pi boards
that have been written from scratch or customized from the kernel source
distribution for MuntsOS.

For I² devices, the easiest way to determine the correct slave address
is to run i2cdetect -y 1 before and after attaching the device and see
what changes. Then you can add the proper dtoverlay command to
/boot/config.txt

AD5593R Analog/Digital I/O Expander

    dtoverlay=AD5593R
    dtparam=mode0=1
    dtparam=mode1=1
    dtparam=mode2=1
    dtparam=mode3=1
    dtparam=mode4=1
    dtparam=mode5=1
    dtparam=mode6=1
    dtparam=mode7=1
    dtparam=offstate0=0
    dtparam=offstate1=0
    dtparam=offstate2=0
    dtparam=offstate3=0
    dtparam=offstate4=0
    dtparam=offstate5=0
    dtparam=offstate6=0
    dtparam=offstate7=0

  ----------------------------------- -----------------------------------
  Mode Values                         Off State Values

  0 Unused                            0 Pulldown resistor

  1 ADC                               1 Output low (sinking)

  2 DAC                               2 Output high (sourcing)

  3 ADC and DAC                       3 Tri-State (high impedance)

  8 GPIO                              
  ----------------------------------- -----------------------------------

ADS1015 Analog to Digital Converter

    dtoverlay=ADS1015
    dtparam=addr=0xNN
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

The I²C slave address may be 0x48 or 0x49.

MCP23017 GPIO Expander

    dtoverlay=MCP23017
    dtparam=addr=0xNN
    dtparam=gpiopin=N

The I²C slave address may be 0x20 to 0x27.

PCA8574 GPIO Expander

    dtoverlay=PCA8574
    dtparam=addr=0xNN

The I²C slave address may be 0x20 to 0x27 (PCA8574, PCF8574) or 0x38 to
0x3F (PCA8574A, PCF8574A).

PCA9685 PWM Expander

    dtoverlay=PCA9685
    dtparam=addr=0xNN

Possible I²C slave addresses range from 0x40 to 0x7F, though some of
these will conflict with other devices and reserved addresses. 0x40 and
0x70 are common. This overlay does not support GPIO mode.

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

------------------------------------------------------------------------

Questions or comments to Philip Munts phil@munts.net
