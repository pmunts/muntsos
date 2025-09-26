-- MuntsOS Remote I/O Server

-- Copyright (C)2018-2025, Philip Munts dba Munts Technologies.
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

PRAGMA Warnings(Off, "variable ""srv*"" is assigned but never read");

WITH Ada.Directories;
WITH Ada.Strings.Fixed;

WITH ClickBoard.Shields;
WITH CPUInfo;
WITH Device;
WITH GPIO.UserLED;
WITH RemoteIO.ADC;
WITH RemoteIO.Executive;
WITH RemoteIO.GPIO;
WITH RemoteIO.I2C;
WITH RemoteIO.PWM;
WITH RemoteIO.SPI;
WITH RemoteIO.Server.Foundation;
WITH RemoteIO.Server.WioE5_Ham1;
WITH SystemInfo;

-- Board dependent packages

WITH BeagleBone;
WITH BeaglePlay;
WITH PocketBeagle;
WITH RaspberryPi;
WITH RaspberryPi5;
WITH OrangePiZero2W;

USE TYPE ClickBoard.Shields.Kind;
USE TYPE CPUInfo.Kinds;

PROCEDURE wioe5_ham1_remoteio_server IS

  title  : CONSTANT String := "MuntsOS Remote I/O Server";
  caps   : CONSTANT String := "ADC GPIO I2C PWM SPI";
  exec   : RemoteIO.Executive.Executor;
  srvw   : RemoteIO.Server.Instance;
  adc    : RemoteIO.ADC.Dispatcher;
  gpio   : RemoteIO.GPIO.Dispatcher;
  i2c    : RemoteIO.I2C.Dispatcher;
  pwm    : RemoteIO.PWM.Dispatcher;
  spi    : RemoteIO.SPI.Dispatcher;

  -- Raspberry Pi subsystem configuration flags, to be calculated at run time.

  ADC_inputs : CONSTANT ARRAY (Natural RANGE <>) OF Device.Designator :=
   (RaspberryPi.AIN0, RaspberryPi.AIN1, RaspberryPi.AIN2, RaspberryPi.AIN3,
    RaspberryPi.AIN4, RaspberryPi.AIN5, RaspberryPI.AIN6, RaspberryPi.AIN7);

  Pi3Click : CONSTANT Boolean := ClickBoard.Shields.Detect = ClickBoard.Shields.PiClick3;
  Pi4Click : CONSTANT Boolean := ClickBoard.Shields.Detect = ClickBoard.Shields.PiClick4;

  ADC_configured   : ARRAY (0 .. 7) OF Boolean;
  I2C1_configured  : Boolean;
  I2C2_configured  : Boolean;
  SPI00_configured : Boolean;
  SPI01_configured : Boolean;
  SPI10_configured : Boolean;
  SPI11_configured : Boolean;
  SPI12_configured : Boolean;
  SPI0_configured  : Boolean;
  SPI1_configured  : Boolean;

  PROCEDURE system(cmd : String);
    PRAGMA Import(C, system);

  FUNCTION StartsWith(haystack : String; needle : String) RETURN Boolean IS

  BEGIN
    RETURN Ada.Strings.Fixed.Index(haystack, needle) = 1;
  END StartsWith;

BEGIN
  IF ClickBoard.Shields.Detect = ClickBoard.Shields.Unknown THEN
    RemoteIO.Server.Foundation.Initialize(title, caps);
  ELSE
    RemoteIO.Server.Foundation.Initialize(title, caps & " " &
      ClickBoard.Shields.Detect'Image);
  END IF;

  exec := RemoteIO.Server.Foundation.Executor;

  -- Initialize server subsystem tasks

  srvw := RemoteIO.Server.WioE5_Ham1.Create(exec);

  -- Create I/O subsystem objects

  adc  := RemoteIO.ADC.Create(exec);
  gpio := RemoteIO.GPIO.Create(exec);
  i2c  := RemoteIO.I2C.Create(exec);
  pwm  := RemoteIO.PWM.Create(exec);
  spi  := RemoteIO.SPI.Create(exec);

  -- Register BeagleBone family I/O resources

  IF StartsWith(SystemInfo.BoardName, "beaglebone") THEN
    IF Ada.Directories.Exists("/sys/bus/iio/devices/iio:device0") THEN
      adc.register(0, BeagleBone.AIN0, 12);    -- P9.39 1.8V
      adc.register(1, BeagleBone.AIN1, 12);    -- P9.40 1.8V
      adc.register(2, BeagleBone.AIN2, 12);    -- P9.37 1.8V
      adc.register(3, BeagleBone.AIN3, 12);    -- P9.38 1.8V
      adc.register(4, BeagleBone.AIN4, 12);    -- P9.33 1.8V
      adc.register(5, BeagleBone.AIN5, 12);    -- P9.36 1.8V
      adc.register(6, BeagleBone.AIN6, 12);    -- P9.35 1.8V
    END IF;

    gpio.Register(0, Standard.GPIO.UserLED.Create, RemoteIO.GPIO.OutputOnly);

    gpio.Register(2,   BeagleBone.GPIO2);      -- P9.22  SPI0 SCK  UART2 RXD EHRPWM0B
    gpio.Register(3,   BeagleBone.GPIO3);      -- P9.21  SPI0 MISO UART2 TXD
    gpio.Register(4,   BeagleBone.GPIO4);      -- P9.18  SPI0 MOSI
    gpio.Register(5,   BeagleBone.GPIO5);      -- P9.17  SPI0 SS0
    gpio.Register(7,   BeagleBone.GPIO7);      -- P9.42  SPI1 SS1
    gpio.Register(8,   BeagleBone.GPIO8);      -- P8.35
    gpio.Register(9,   BeagleBone.GPIO9);      -- P8.33
    gpio.Register(10,  BeagleBone.GPIO10);     -- P8.31
    gpio.Register(11,  BeagleBone.GPIO11);     -- P8.32
    gpio.Register(12,  BeagleBone.GPIO12);     -- P9.20  I2C2 SDA
    gpio.Register(13,  BeagleBone.GPIO13);     -- P9.19  I2C2 SCL
    gpio.Register(14,  BeagleBone.GPIO14);     -- P9.26  UART1 RXD
    gpio.Register(15,  BeagleBone.GPIO15);     -- P9.24  UART1 TXD
    gpio.Register(20,  BeagleBone.GPIO20);     -- P9.41
    gpio.Register(22,  BeagleBone.GPIO22);     -- P8.19  EHRPWM2A
    gpio.Register(23,  BeagleBone.GPIO23);     -- P8.13  EHRPWM2B
    gpio.Register(26,  BeagleBone.GPIO26);     -- P8.14
    gpio.Register(27,  BeagleBone.GPIO27);     -- P8.17
    gpio.Register(30,  BeagleBone.GPIO30);     -- P9.11  UART4 RXD
    gpio.Register(31,  BeagleBone.GPIO31);     -- P9.13  UART4 TXD
    IF SystemInfo.BoardName = "beaglebone" THEN
    -- Later models use these pins for the on-board eMMC
    gpio.Register(32,  BeagleBone.GPIO32);     -- P8.25  MMC1 DAT0
    gpio.Register(33,  BeagleBone.GPIO33);     -- P8.24  MMC1 DAT1
    gpio.Register(34,  BeagleBone.GPIO34);     -- P8.5   MMC1 DAT2
    gpio.Register(35,  BeagleBone.GPIO35);     -- P8.6   MMC1 DAT3
    gpio.Register(36,  BeagleBone.GPIO36);     -- P8.23  MMC1 DAT4
    gpio.Register(37,  BeagleBone.GPIO37);     -- P8.22  MMC1 DAT5
    gpio.Register(38,  BeagleBone.GPIO38);     -- P8.3   MMC1 DAT6
    gpio.Register(39,  BeagleBone.GPIO39);     -- P8.4   MMC1 DAT7
    END IF;
    gpio.Register(44,  BeagleBone.GPIO44);     -- P8.12
    gpio.Register(45,  BeagleBone.GPIO45);     -- P8.11
    gpio.Register(46,  BeagleBone.GPIO46);     -- P8.16
    gpio.Register(47,  BeagleBone.GPIO47);     -- P8.15
    gpio.Register(48,  BeagleBone.GPIO48);     -- P9.15
    gpio.Register(49,  BeagleBone.GPIO49);     -- P9.23
    gpio.Register(50,  BeagleBone.GPIO50);     -- P9.14  EHRPWM1A
    gpio.Register(51,  BeagleBone.GPIO51);     -- P9.16  EHRPWM1B
    gpio.Register(60,  BeagleBone.GPIO60);     -- P9.12
    gpio.Register(61,  BeagleBone.GPIO61);     -- P8.26
    IF SystemInfo.BoardName = "beaglebone" THEN
    -- Later models use these pins for the on-board eMMC
    gpio.Register(62,  BeagleBone.GPIO62);     -- P8.21  MMC1 CLK
    gpio.Register(63,  BeagleBone.GPIO63);     -- P8.20  MMC1 CMD
    END IF;
    gpio.Register(65,  BeagleBone.GPIO65);     -- P8.18
    gpio.Register(66,  BeagleBone.GPIO66);     -- P8.7
    gpio.Register(67,  BeagleBone.GPIO67);     -- P8.8
    gpio.Register(68,  BeagleBone.GPIO68);     -- P8.10
    gpio.Register(69,  BeagleBone.GPIO69);     -- P8.9
    gpio.Register(70,  BeagleBone.GPIO70);     -- P8.45  EHRPWM2A
    gpio.Register(71,  BeagleBone.GPIO71);     -- P8.46  EHRPWM2B
    gpio.Register(72,  BeagleBone.GPIO72);     -- P8.43
    gpio.Register(73,  BeagleBone.GPIO73);     -- P8.44
    gpio.Register(74,  BeagleBone.GPIO74);     -- P8.41
    gpio.Register(75,  BeagleBone.GPIO75);     -- P8.42
    gpio.Register(76,  BeagleBone.GPIO76);     -- P8.39
    gpio.Register(77,  BeagleBone.GPIO77);     -- P8.40
    gpio.Register(78,  BeagleBone.GPIO78);     -- P8.37  UART5 TXD
    gpio.Register(79,  BeagleBone.GPIO79);     -- P8.38  UART5 RXD
    gpio.Register(80,  BeagleBone.GPIO80);     -- P8.36  EHRPWM1A
    gpio.Register(81,  BeagleBone.GPIO81);     -- P8.34  EHRPWM1B
    gpio.Register(86,  BeagleBone.GPIO86);     -- P8.27
    gpio.Register(87,  BeagleBone.GPIO87);     -- P8.29
    gpio.Register(88,  BeagleBone.GPIO88);     -- P8.28
    gpio.Register(89,  BeagleBone.GPIO89);     -- P8.30
    gpio.Register(110, BeagleBone.GPIO110);    -- P9.31  SPI1 SCLK EHRPWM0A
    gpio.Register(111, BeagleBone.GPIO111);    -- P9.29  SPI1 MISO
    gpio.Register(112, BeagleBone.GPIO112);    -- P9.30  SPI1 MOSI
    gpio.Register(113, BeagleBone.GPIO113);    -- P9.28  SPI1 SS0
    gpio.Register(115, BeagleBone.GPIO115);    -- P9.27
    gpio.Register(117, BeagleBone.GPIO117);    -- P9.25

    i2c.Register(2, BeagleBone.I2C2);

    pwm.Register(0, BeagleBone.EHRPWM1A);
    pwm.Register(1, BeagleBone.EHRPWM1B);
    pwm.Register(2, BeagleBone.EHRPWM2A);
    pwm.Register(3, BeagleBone.EHRPWM2B);

    spi.Register(0, BeagleBone.SPI1_0);
    spi.Register(1, BeagleBone.SPI1_1);
    spi.Register(2, BeagleBone.SPI0_0);

  -- Register BeaglePlay I/O Resources

  ELSIF SystemInfo.BoardName = "beagleplay" THEN

    -- BeaglePlay has 5 user LEDs

    gpio.Register(0,  Standard.GPIO.UserLED.Create(BeaglePlay.LED_USR0), RemoteIO.GPIO.OutputOnly);
    gpio.Register(1,  Standard.GPIO.UserLED.Create(BeaglePlay.LED_USR1), RemoteIO.GPIO.OutputOnly);
    gpio.Register(2,  Standard.GPIO.UserLED.Create(BeaglePlay.LED_USR2), RemoteIO.GPIO.OutputOnly);
    gpio.Register(3,  Standard.GPIO.UserLED.Create(BeaglePlay.LED_USR3), RemoteIO.GPIO.OutputOnly);
    gpio.Register(4,  Standard.GPIO.UserLED.Create(BeaglePlay.LED_USR4), RemoteIO.GPIO.OutputOnly);

    -- User button

    gpio.Register(5,  Standard.BeaglePlay.USER_BUTTON, RemoteIO.GPIO.InputOnly, RemoteIO.GPIO.ActiveLow);

    -- mikroBUS GPIOs

    gpio.Register(6,  BeaglePlay.AN);
    gpio.Register(7,  BeaglePlay.RST);
    gpio.Register(8,  BeaglePlay.CS);   -- Conflicts with SPI
    gpio.Register(9,  BeaglePlay.SCK);  -- Conflicts with SPI
    gpio.Register(10, BeaglePlay.MISO); -- Conflicts with SPI
    gpio.Register(11, BeaglePlay.MOSI); -- Conflicts with SPI

    gpio.Register(12, BeaglePlay.PWM);  -- Conflicts with PWM
    gpio.Register(13, BeaglePlay.INT);
    gpio.Register(14, BeaglePlay.RX);   -- Conflicts with UART
    gpio.Register(15, BeaglePlay.TX);   -- Conflicts with UART
    gpio.Register(16, BeaglePlay.SCL);  -- Conflicts with I2C
    gpio.Register(17, BeaglePlay.SDA);  -- Conflicts with I2C

    -- Grove GPIOs

    gpio.Register(18, BeaglePlay.D0);
    gpio.Register(19, BeaglePlay.D1);

    -- I2C buses

    i2c.Register(0, BeaglePlay.I2C_GROVE);
    i2c.Register(1, BeaglePlay.I2C_MIKROBUS);
    i2c.Register(2, BeaglePlay.I2C_QWIIC);

    -- PWM outputs

    pwm.Register(0, BeaglePlay.PWM_MIKROBUS);
    pwm.Register(1, BeaglePlay.PWM_GROVE_D0);
    pwm.Register(2, BeaglePlay.PWM_GROVE_D1);

    -- SPI devices

    spi.Register(0, BeaglePlay.SPI_MIKROBUS);

  -- Register PocketBeagle I/O Resources

  ELSIF SystemInfo.BoardName = "pocketbeagle" THEN
    IF Ada.Directories.Exists("/sys/bus/iio/devices/iio:device0") THEN
      adc.register(0, PocketBeagle.AIN0, 12);  -- P1.19 1.8V
      adc.register(1, PocketBeagle.AIN1, 12);  -- P1.21 1.8V
      adc.register(2, PocketBeagle.AIN2, 12);  -- P1.23 1.8V
      adc.register(3, PocketBeagle.AIN3, 12);  -- P1.25 1.8V
      adc.register(4, PocketBeagle.AIN4, 12);  -- P1.27 1.8V
      adc.register(5, PocketBeagle.AIN5, 12);  -- P2.35 3.6V
      adc.register(6, PocketBeagle.AIN6, 12);  -- P1.2  3.6V
      adc.register(7, PocketBeagle.AIN7, 12);  -- P2.36 1.8V
    END IF;

    gpio.Register(0, Standard.GPIO.UserLED.Create, RemoteIO.GPIO.OutputOnly);

    gpio.Register(2,   PocketBeagle.GPIO2);    -- P1.8   SPI0 SCLK
    gpio.Register(3,   PocketBeagle.GPIO3);    -- P1.10  SPI0 MISO
    gpio.Register(4,   PocketBeagle.GPIO4);    -- P1.12  SPI0 MOSI
    gpio.Register(5,   PocketBeagle.GPIO5);    -- P1.6   SPI0 CS
    gpio.Register(7,   PocketBeagle.GPIO7);    -- P2.29  SPI1 SCLK
    gpio.Register(12,  PocketBeagle.GPIO12);   -- P1.26  I2C2 SDA
    gpio.Register(13,  PocketBeagle.GPIO13);   -- P1.28  I2C2 SCL
    gpio.Register(14,  PocketBeagle.GPIO14);   -- P2.11  I2C1 SDA
    gpio.Register(15,  PocketBeagle.GPIO15);   -- P2.9   I2C1 SCL
    gpio.Register(19,  PocketBeagle.GPIO19);   -- P2.31  SPI1 CS
    gpio.Register(20,  PocketBeagle.GPIO20);   -- P1.20
    gpio.Register(23,  PocketBeagle.GPIO23);   -- P2.3
    gpio.Register(26,  PocketBeagle.GPIO26);   -- P1.34
    gpio.Register(27,  PocketBeagle.GPIO27);   -- P2.19
    gpio.Register(30,  PocketBeagle.GPIO30);   -- P2.5   RXD4
    gpio.Register(31,  PocketBeagle.GPIO31);   -- P2.7   TXD4
    gpio.Register(40,  PocketBeagle.GPIO40);   -- P2.27  SPI1 MISO
    gpio.Register(41,  PocketBeagle.GPIO41);   -- P2.25  SPI1 MOSI
    gpio.Register(42,  PocketBeagle.GPIO42);   -- P1.32  RXD0
    gpio.Register(43,  PocketBeagle.GPIO43);   -- P1.30  TXD0
    gpio.Register(44,  PocketBeagle.GPIO44);   -- P2.24
    gpio.Register(45,  PocketBeagle.GPIO45);   -- P2.33
    gpio.Register(46,  PocketBeagle.GPIO46);   -- P2.22
    gpio.Register(47,  PocketBeagle.GPIO47);   -- P2.18
    gpio.Register(50,  PocketBeagle.GPIO50);   -- P2.1
    gpio.Register(52,  PocketBeagle.GPIO52);   -- P2.10
    gpio.Register(57,  PocketBeagle.GPIO57);   -- P2.6
    gpio.Register(58,  PocketBeagle.GPIO58);   -- P2.4
    gpio.Register(59,  PocketBeagle.GPIO59);   -- P2.2
    gpio.Register(60,  PocketBeagle.GPIO60);   -- P2.8
    gpio.Register(64,  PocketBeagle.GPIO64);   -- P2.20
    gpio.Register(65,  PocketBeagle.GPIO65);   -- P2.17
    gpio.Register(86,  PocketBeagle.GPIO86);   -- P2.35  AIN5 3.3V
    gpio.Register(87,  PocketBeagle.GPIO87);   -- P1.2   AIN6 3.3V
    gpio.Register(88,  PocketBeagle.GPIO88);   -- P1.35
    gpio.Register(89,  PocketBeagle.GPIO89);   -- P1.4
    gpio.Register(110, PocketBeagle.GPIO110);  -- P1.36
    gpio.Register(111, PocketBeagle.GPIO111);  -- P1.33
    gpio.Register(112, PocketBeagle.GPIO112);  -- P2.32
    gpio.Register(113, PocketBeagle.GPIO113);  -- P2.30
    gpio.Register(114, PocketBeagle.GPIO114);  -- P1.31
    gpio.Register(115, PocketBeagle.GPIO115);  -- P2.34
    gpio.Register(116, PocketBeagle.GPIO116);  -- P2.28
    gpio.Register(117, PocketBeagle.GPIO117);  -- P1.29

    i2c.Register(1, PocketBeagle.I2C1);
    i2c.Register(2, PocketBeagle.I2C2);

    IF Ada.Directories.Exists("/sys/class/pwm/pwmchip0") THEN
      system("echo 0 >/sys/class/pwm/pwmchip0/export" & ASCII.NUL);
    END IF;

    IF Ada.Directories.Exists("/sys/class/pwm/pwmchip2") THEN
      system("echo 0 >/sys/class/pwm/pwmchip2/export" & ASCII.NUL);
    END IF;

    DELAY 1.0;

    IF Ada.Directories.Exists("/sys/class/pwm/pwmchip0/pwm0") THEN
      pwm.Register(0, PocketBeagle.PWM0_0);
    END IF;

    IF Ada.Directories.Exists("/sys/class/pwm/pwmchip2/pwm0") THEN
      pwm.Register(1, PocketBeagle.PWM2_0);
    END IF;

    spi.Register(0, PocketBeagle.SPI0_0);
    spi.Register(1, PocketBeagle.SPI1_1);

  ELSIF StartsWith(SystemInfo.BoardName, "raspberrypi") OR
        SystemInfo.ModelName = OrangePiZero2W.ModelName THEN

    -- See if ADC inputs are configured
    ADC_configured(0) := Ada.Directories.Exists("/sys/bus/iio/devices/iio:device0/in_voltage0_raw");
    ADC_configured(1) := Ada.Directories.Exists("/sys/bus/iio/devices/iio:device0/in_voltage1_raw");
    ADC_configured(2) := Ada.Directories.Exists("/sys/bus/iio/devices/iio:device0/in_voltage2_raw");
    ADC_configured(3) := Ada.Directories.Exists("/sys/bus/iio/devices/iio:device0/in_voltage3_raw");
    ADC_configured(4) := Ada.Directories.Exists("/sys/bus/iio/devices/iio:device0/in_voltage4_raw");
    ADC_configured(5) := Ada.Directories.Exists("/sys/bus/iio/devices/iio:device0/in_voltage5_raw");
    ADC_configured(6) := Ada.Directories.Exists("/sys/bus/iio/devices/iio:device0/in_voltage6_raw");
    ADC_configured(7) := Ada.Directories.Exists("/sys/bus/iio/devices/iio:device0/in_voltage7_raw");

    -- See if I2C buses configured
    I2C1_configured  := Ada.Directories.Exists("/dev/i2c-1");
    I2C2_configured  := SystemInfo.ModelName = OrangePiZero2W.ModelName AND
                          Ada.Directories.Exists("/dev/i2c-2");

    -- See if SPI devices are configured
    SPI00_configured := Ada.Directories.Exists("/dev/spidev0.0");
    SPI01_configured := Ada.Directories.Exists("/dev/spidev0.1");
    SPI10_configured := Ada.Directories.Exists("/dev/spidev1.0");
    SPI11_configured := Ada.Directories.Exists("/dev/spidev1.1");
    SPI12_configured := Ada.Directories.Exists("/dev/spidev1.2");

    SPI0_configured  := SPI00_configured OR SPI01_configured;
    SPI1_configured  := SPI10_configured OR SPI11_configured OR SPI12_configured;

    -- Register Pi 3 Click Shield analog inputs

    IF Pi3Click THEN
      FOR n IN 0 .. 1 LOOP
        IF ADC_configured(n) THEN
          adc.Register(n, ADC_inputs(n), 12); -- 12 bits, 4.096V Vref
        END IF;
      END LOOP;

    -- Register P 4 Click Shield analog inputs

    ELSIF Pi4Click THEN
      FOR n IN 0 .. 2 LOOP
        IF ADC_configured(n) THEN
          adc.Register(n, ADC_inputs(n), 15); -- 15 bits, 4.096V Vref
        END IF;
      END LOOP;

    -- Register MUNTS-0018 analog inputs

    ELSIF SystemInfo.ShieldName = "munts-0018" THEN
      FOR n IN 0 .. 3 LOOP
        IF ADC_configured(n) THEN
          adc.Register(n, ADC_inputs(n), 12); -- 12 bits, 3.3V Vref
        END IF;
      END LOOP;
    END IF;

    gpio.Register(0, Standard.GPIO.UserLED.Create, RemoteIO.GPIO.OutputOnly);

    IF NOT I2C1_configured THEN
      gpio.Register(2,  RaspberryPi.GPIO2);    -- aka I2C1 SDA
      gpio.Register(3,  RaspberryPi.GPIO3);    -- aka I2C1 SCL
    END IF;

    gpio.Register(4,  RaspberryPi.GPIO4);
    gpio.Register(5,  RaspberryPi.GPIO5);
    gpio.Register(6,  RaspberryPi.GPIO6);

    IF NOT SPI01_configured THEN
      gpio.Register(7,  RaspberryPi.GPIO7);    -- aka SPI0 SS1
    END IF;

    IF NOT SPI00_configured THEN
      gpio.Register(8,  RaspberryPi.GPIO8);    -- aka SPI0 SS0
    END IF;

    IF NOT SPI0_configured THEN
      gpio.Register(9,  RaspberryPi.GPIO9);    -- aka SPI0 MISO
      gpio.Register(10, RaspberryPi.GPIO10);   -- aka SPI0 MOSI
      gpio.Register(11, RaspberryPi.GPIO11);   -- aka SPI0 SCLK
    END IF;

    gpio.Register(12, RaspberryPi.GPIO12);     -- aka PWM0
    gpio.Register(13, RaspberryPi.GPIO13);     -- aka PWM1

    IF NOT SPI12_configured AND NOT Pi3Click THEN
      -- The Mikroelektronika Pi 3 Click Shield MIKROE-2756 uses SPI1_2
      -- for its MCP3204 A/D converter
      gpio.Register(16, RaspberryPi.GPIO16);   -- aka SPI1 SS2
    END IF;

    IF NOT SPI11_configured THEN
      gpio.Register(17, RaspberryPi.GPIO17);   -- aka SPI1 SS1
    END IF;

    IF NOT SPI10_configured THEN
      gpio.Register(18, RaspberryPi.GPIO18);   -- aka SPI1 SS0 aka PWM0
    END IF;

    IF NOT SPI1_configured AND NOT Pi3Click THEN
      -- The Mikroelektronika Pi 3 Click Shield MIKROE-2756 uses SPI1
      -- for its MCP3204 A/D converter
      gpio.Register(19, RaspberryPi.GPIO19);   -- aka SPI1 MISO aka PWM1

      IF NOT Pi4Click THEN
        -- Mikroelektronika Pi 4 Click Shield MIKROE-4122 uses GPIO20 for the
        -- The Pi 4 Click Shield uses GPIO20 for fan control
        gpio.Register(20, RaspberryPi.GPIO20); -- aka SPI1 MOSI
      END IF;

      gpio.Register(21, RaspberryPi.GPIO21);   -- aka SPI1 SCLK
    END IF;

    gpio.Register(22, RaspberryPi.GPIO22);
    gpio.Register(23, RaspberryPi.GPIO23);
    gpio.Register(24, RaspberryPi.GPIO24);

    IF NOT Pi4Click THEN
      -- Mikroelektronika Pi 4 Click Shield MIKROE-4122 uses GPIO25 for the
      -- ADS1115 A/D converter ALERT/RDY signal
      gpio.Register(25, RaspberryPi.GPIO25);
    END IF;

    gpio.Register(26, RaspberryPi.GPIO26);
    gpio.Register(27, RaspberryPi.GPIO27);

    IF I2C1_configured THEN
      i2c.Register(1, RaspberryPi.I2C1);
    END IF;

    IF I2C2_configured THEN
      i2c.Register(2, OrangePiZero2W.I2C2);
    END IF;

    IF CPUInfo.Kind >= CPUInfo.BCM2708 AND CPUInfo.Kind <= CPUInfo.BCM2711 THEN
      -- Raspberry Pi 1 to 4 all have two hardware PWM outputs from pwmchip0
      IF Ada.Directories.Exists("/sys/class/pwm/pwmchip0") THEN
        pwm.Register(0, RaspberryPi.PWM0);    -- GPIO12 or GPIO18
        pwm.Register(1, RaspberryPi.PWM1);    -- GPIO13 or GPIO19
        -- Emulate Raspberry Pi 5 PWM outputs:
        -- PWM0 on GPIO12
        -- PWM1 on GPIO13
        -- PWM2 on GPIO18
        -- PWM3 on GPIO19.
        pwm.Register(2, RaspberryPi.PWM0);    -- GPIO12 or GPIO18
        pwm.Register(3, RaspberryPi.PWM1);    -- GPIO13 or GPIO19
      END IF;
    ELSIF CPUInfo.Kind = CPUInfo.BCM2712 THEN
      -- Raspberry Pi 5 has four hardware PWM outputs from pwmchip2
      IF Ada.Directories.Exists("/sys/class/pwm/pwmchip2") THEN
        pwm.Register(0, RaspberryPi5.PWM0);   -- GPIO12
        pwm.Register(1, RaspberryPi5.PWM1);   -- GPIO13
        pwm.Register(2, RaspberryPi5.PWM2);   -- GPIO14 or GPIO18
        pwm.Register(3, RaspberryPi5.PWM3);   -- GPIO15 or GPIO19
      END IF;
    ELSIF SystemInfo.ModelName = OrangePiZero2W.ModelName THEN
      -- Orange Pi Zero 2W has four hardware PWM outputs from pwmchip0
      IF Ada.Directories.Exists("/sys/class/pwm/pwmchip0") THEN
        pwm.Register(0, OrangePiZero2W.PWM1); -- GPIO12
        pwm.Register(1, OrangePiZero2W.PWM2); -- GPIO13
        pwm.Register(2, OrangePiZero2W.PWM3); -- GPIO4
        pwm.Register(3, OrangePiZero2W.PWM4); -- GPIO23
      END IF;
    END IF;

    IF SPI00_configured THEN
      spi.Register(0, RaspberryPi.SPI0_0);
    END IF;

    IF SPI01_configured THEN
      spi.Register(1, RaspberryPi.SPI0_1);
    END IF;

    IF SPI10_configured THEN
      spi.Register(2, RaspberryPi.SPI1_0);
    END IF;

    IF SPI11_configured THEN
      spi.Register(3, RaspberryPi.SPI1_1);
    END IF;

    IF SPI12_configured THEN
      spi.Register(4, RaspberryPi.SPI1_2);
    END IF;

  END IF;

END wioe5_ham1_remoteio_server;
