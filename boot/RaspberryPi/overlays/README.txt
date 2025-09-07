MuntsOS Embedded Linux Extra Device Tree Overlays

Here are some collected device tree overlays for Raspberry Pi boards
that have been written from scratch or customized from the kernel source
distribution for MuntsOS.

For I²C devices, the easiest way to determine the correct slave address
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

Mode Values

    0 Unused
    1 ADC
    2 DAC
    3 ADC and DAC
    8 GPIO

Off State Values

    0 Pulldown resistor
    1 Output low (sinking)
    2 Output high (sourcing)
    3 Tri-State (high impedance)

ADC121C021 Analog to Digital Converter

    dtoverlay=ADC121C021
    dtparam=addr=0xNN
    dtparam=min=VVVVVVV
    dtparam=max=VVVVVVV

The I²C slave address may be 0x50 (default if not specified), 0x51,
0x52, 0x54, 0x55, 0x56, 0x58, 0x59, or 0x5A.

For the Grove I²C ADC module, the default address is 0x50 and the values
for min and max should be 6000000 or 2 times the measured voltage, in
microvolts, at pad VA.

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

The I²C slave address may be 0x48 (default if not specified) or 0x49.

ENC28J60 Ethernet Adapter

    dtoverlay=ENC28J60
    dtparam=cs=N
    dtparam=irq=N

The value for the SPI slave select parameter cs is 0 for spidev0.0 or 1
for spidev0.1. Default is 0.
The value for GPIO interrupt signal parameter irq must be a GPIO number.
Default is 25.

The default values are correct for the GeeekPi EN28J60 HAT so both
dtparam lines may be omitted. Other ENC28J60 boards such as the
Mikroelektronika ETH Click will likely require cs or irq or both.

MCP23017 GPIO Expander

    dtoverlay=MCP23017
    dtparam=addr=0xNN
    dtparam=gpiopin=N

The I²C slave address may be 0x20 (default if not specified) to 0x27.

MCP3428 Analog to Digital Converter

    dtoverlay=MCP3428
    dtparam=addr=0xNN

The I²C slave address may be 0x68 (default if not specified) to 0x6F.

MUNTS-0018 Raspberry Pi Tutorial I/O Board

    dtoverlay=MUNTS-0018
    dtparam=min=VVVVVVV
    dtparam=max=VVVVVVV

You can improve the accuracy of the on-board MCP3204 ADC by setting min
and max to the measured voltage, in microvolts, of the 3v3 power rail.

PCA8574 GPIO Expander

    dtoverlay=PCA8574
    dtparam=addr=0xNN

The I²C slave address may be 0x20 (default if not specified) to 0x27
(PCA8574, PCF8574) or 0x38 to 0x3F (PCA8574A, PCF8574A).

PCA9685 PWM Expander

    dtoverlay=PCA9685
    dtparam=addr=0xNN

Possible I²C slave addresses range from 0x40 (default if not specified)
to 0x7F, though some of these will conflict with other devices and
reserved addresses. 0x40 and 0x70 are common. This overlay does not
support GPIO mode.

Pi 3 Click Shield

    dtoverlay=Pi3ClickShield

Pi 4 Click Shield

    dtoverlay=Pi4ClickShield

W5500 Ethernet Adapter

    dtoverlay=W5500
    dtparam=cs=N
    dtparam=irq=N

The value for the SPI slave select parameter cs is 0 for spidev0.0 or 1
for spidev0.1. Default is 0.
The value for GPIO interrupt signal parameter irq must be a GPIO number.
Default is 25.

------------------------------------------------------------------------

Questions or comments to Philip Munts phil@munts.net
