// Unit tests for GPIO pin number validation

// Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#include <check.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include <platform.h>

static void TestBoardPins(const char *boardname, const unsigned *validpins)
{
  char buf[256];
  bool PinMap[MAX_PLATFORM_PINS];
  int i;

  // Register the board name

  memset(buf, 0, sizeof(buf));

  snprintf(buf, sizeof(buf), "BOARDNAME=%s", boardname);

  putenv(buf);

  // Register valid GPIO pins for the board

  memset(PinMap, 0, sizeof(PinMap));

  for (i = 0; i < MAX_PLATFORM_PINS; i++)
    if (validpins[i] > 0)
      PinMap[validpins[i]] = true;

  // Test the validity of each GPIO pin

  GPIO_Platform_Init();

  for (i = 0; i < MAX_PLATFORM_PINS; i++)
    if (PinMap[i])
        ck_assert(GPIO_Platform_Pin_Valid(i));
      else
        ck_assert(!GPIO_Platform_Pin_Valid(i));
}

START_TEST(test_beaglebone_white)
{
  putenv("BOARDNAME=BeagleBone");

  GPIO_Platform_Init();

  // P9 left side invalid pins

  ck_assert(!GPIO_Platform_Pin_Valid(30));	// RXD4
  ck_assert(!GPIO_Platform_Pin_Valid(31));	// TXD4

  ck_assert(!GPIO_Platform_Pin_Valid(13));	// I2C2 SCL
  ck_assert(!GPIO_Platform_Pin_Valid(3));	// TXD2

  ck_assert(!GPIO_Platform_Pin_Valid(111));	// SPI1 MISO
  ck_assert(!GPIO_Platform_Pin_Valid(110));	// SPI1 SCLK

  // P9 right side invalid pins

  ck_assert(!GPIO_Platform_Pin_Valid(12));	// I2C2 SDA
  ck_assert(!GPIO_Platform_Pin_Valid(2));	// RXD2
  ck_assert(!GPIO_Platform_Pin_Valid(15));	// TXD1
  ck_assert(!GPIO_Platform_Pin_Valid(14));	// RXD1
  ck_assert(!GPIO_Platform_Pin_Valid(113));	// SPI1 SS0
  ck_assert(!GPIO_Platform_Pin_Valid(112));	// SPI1 MOSI

  ck_assert(!GPIO_Platform_Pin_Valid(42));	// SPI1 SS1

  // P9 left side valid pins

  ck_assert(GPIO_Platform_Pin_Valid(48));
  ck_assert(GPIO_Platform_Pin_Valid(5));

  ck_assert(GPIO_Platform_Pin_Valid(49));
  ck_assert(GPIO_Platform_Pin_Valid(117));
  ck_assert(GPIO_Platform_Pin_Valid(115));

  ck_assert(GPIO_Platform_Pin_Valid(20));

  // P9 right side valid pins

  ck_assert(GPIO_Platform_Pin_Valid(60));
  ck_assert(GPIO_Platform_Pin_Valid(50));
  ck_assert(GPIO_Platform_Pin_Valid(51));
  ck_assert(GPIO_Platform_Pin_Valid(4));

  // P8 left side invalid pins

  ck_assert(!GPIO_Platform_Pin_Valid(78));	// TXD5

  // P8 right side invalid pins

  ck_assert(!GPIO_Platform_Pin_Valid(79));	// RXD5

  // P8 left side valid pins

  ck_assert(GPIO_Platform_Pin_Valid(38));
  ck_assert(GPIO_Platform_Pin_Valid(34));
  ck_assert(GPIO_Platform_Pin_Valid(66));
  ck_assert(GPIO_Platform_Pin_Valid(69));
  ck_assert(GPIO_Platform_Pin_Valid(45));
  ck_assert(GPIO_Platform_Pin_Valid(23));
  ck_assert(GPIO_Platform_Pin_Valid(47));
  ck_assert(GPIO_Platform_Pin_Valid(27));
  ck_assert(GPIO_Platform_Pin_Valid(22));
  ck_assert(GPIO_Platform_Pin_Valid(62));
  ck_assert(GPIO_Platform_Pin_Valid(36));
  ck_assert(GPIO_Platform_Pin_Valid(32));
  ck_assert(GPIO_Platform_Pin_Valid(86));
  ck_assert(GPIO_Platform_Pin_Valid(87));
  ck_assert(GPIO_Platform_Pin_Valid(10));
  ck_assert(GPIO_Platform_Pin_Valid(9));
  ck_assert(GPIO_Platform_Pin_Valid(8));

  ck_assert(GPIO_Platform_Pin_Valid(76));
  ck_assert(GPIO_Platform_Pin_Valid(74));
  ck_assert(GPIO_Platform_Pin_Valid(72));
  ck_assert(GPIO_Platform_Pin_Valid(70));

  // P8 right side valid pins

  ck_assert(GPIO_Platform_Pin_Valid(39));
  ck_assert(GPIO_Platform_Pin_Valid(35));
  ck_assert(GPIO_Platform_Pin_Valid(67));
  ck_assert(GPIO_Platform_Pin_Valid(68));
  ck_assert(GPIO_Platform_Pin_Valid(44));
  ck_assert(GPIO_Platform_Pin_Valid(26));
  ck_assert(GPIO_Platform_Pin_Valid(46));
  ck_assert(GPIO_Platform_Pin_Valid(65));
  ck_assert(GPIO_Platform_Pin_Valid(63));
  ck_assert(GPIO_Platform_Pin_Valid(37));
  ck_assert(GPIO_Platform_Pin_Valid(33));
  ck_assert(GPIO_Platform_Pin_Valid(61));
  ck_assert(GPIO_Platform_Pin_Valid(88));
  ck_assert(GPIO_Platform_Pin_Valid(89));
  ck_assert(GPIO_Platform_Pin_Valid(11));
  ck_assert(GPIO_Platform_Pin_Valid(81));
  ck_assert(GPIO_Platform_Pin_Valid(80));

  ck_assert(GPIO_Platform_Pin_Valid(77));
  ck_assert(GPIO_Platform_Pin_Valid(75));
  ck_assert(GPIO_Platform_Pin_Valid(73));
  ck_assert(GPIO_Platform_Pin_Valid(71));
}
END_TEST

START_TEST(test_beaglebone_black)
{
  putenv("BOARDNAME=BeagleBoneBlack");

  GPIO_Platform_Init();

  // P9 left side invalid pins

  ck_assert(!GPIO_Platform_Pin_Valid(30));	// RXD4
  ck_assert(!GPIO_Platform_Pin_Valid(31));	// TXD4

  ck_assert(!GPIO_Platform_Pin_Valid(13));	// I2C2 SCL
  ck_assert(!GPIO_Platform_Pin_Valid(3));	// TXD2

  ck_assert(!GPIO_Platform_Pin_Valid(111));	// SPI1 MISO
  ck_assert(!GPIO_Platform_Pin_Valid(110));	// SPI1 SCLK

  // P9 right side invalid pins

  ck_assert(!GPIO_Platform_Pin_Valid(12));	// I2C2 SDA
  ck_assert(!GPIO_Platform_Pin_Valid(2));	// RXD2
  ck_assert(!GPIO_Platform_Pin_Valid(15));	// TXD1
  ck_assert(!GPIO_Platform_Pin_Valid(14));	// RXD1
  ck_assert(!GPIO_Platform_Pin_Valid(113));	// SPI1 SS0
  ck_assert(!GPIO_Platform_Pin_Valid(112));	// SPI1 MOSI

  ck_assert(!GPIO_Platform_Pin_Valid(42));	// SPI1 SS1

  // P9 left side valid pins

  ck_assert(GPIO_Platform_Pin_Valid(48));
  ck_assert(GPIO_Platform_Pin_Valid(5));

  ck_assert(GPIO_Platform_Pin_Valid(49));
  ck_assert(GPIO_Platform_Pin_Valid(117));
  ck_assert(GPIO_Platform_Pin_Valid(115));

  ck_assert(GPIO_Platform_Pin_Valid(20));

  // P9 right side valid pins

  ck_assert(GPIO_Platform_Pin_Valid(60));
  ck_assert(GPIO_Platform_Pin_Valid(50));
  ck_assert(GPIO_Platform_Pin_Valid(51));
  ck_assert(GPIO_Platform_Pin_Valid(4));

  // P8 left side invalid pins

  ck_assert(!GPIO_Platform_Pin_Valid(38));	// MMC1_DAT6
  ck_assert(!GPIO_Platform_Pin_Valid(34));	// MMC1_DAT2

  ck_assert(!GPIO_Platform_Pin_Valid(62));	// MMC1_CLK
  ck_assert(!GPIO_Platform_Pin_Valid(36));	// MMC1_DAT4
  ck_assert(!GPIO_Platform_Pin_Valid(32));	// MMC1_DAT0

  ck_assert(!GPIO_Platform_Pin_Valid(78));	// TXD5

  // P8 right side invalid pins

  ck_assert(!GPIO_Platform_Pin_Valid(39));	// MMC1_DAT7
  ck_assert(!GPIO_Platform_Pin_Valid(35));	// MMC1_DAT3

  ck_assert(!GPIO_Platform_Pin_Valid(63));	// MMC1_CMD
  ck_assert(!GPIO_Platform_Pin_Valid(37));	// MMC1_DAT5
  ck_assert(!GPIO_Platform_Pin_Valid(33));	// MMC1_DAT1

  ck_assert(!GPIO_Platform_Pin_Valid(79));	// RXD5

  // P8 left side valid pins

  ck_assert(GPIO_Platform_Pin_Valid(66));
  ck_assert(GPIO_Platform_Pin_Valid(69));
  ck_assert(GPIO_Platform_Pin_Valid(45));
  ck_assert(GPIO_Platform_Pin_Valid(23));
  ck_assert(GPIO_Platform_Pin_Valid(47));
  ck_assert(GPIO_Platform_Pin_Valid(27));
  ck_assert(GPIO_Platform_Pin_Valid(22));

  ck_assert(GPIO_Platform_Pin_Valid(86));
  ck_assert(GPIO_Platform_Pin_Valid(87));
  ck_assert(GPIO_Platform_Pin_Valid(10));
  ck_assert(GPIO_Platform_Pin_Valid(9));
  ck_assert(GPIO_Platform_Pin_Valid(8));

  ck_assert(GPIO_Platform_Pin_Valid(76));
  ck_assert(GPIO_Platform_Pin_Valid(74));
  ck_assert(GPIO_Platform_Pin_Valid(72));
  ck_assert(GPIO_Platform_Pin_Valid(70));

  // P8 right side valid pins

  ck_assert(GPIO_Platform_Pin_Valid(67));
  ck_assert(GPIO_Platform_Pin_Valid(68));
  ck_assert(GPIO_Platform_Pin_Valid(44));
  ck_assert(GPIO_Platform_Pin_Valid(26));
  ck_assert(GPIO_Platform_Pin_Valid(46));
  ck_assert(GPIO_Platform_Pin_Valid(65));

  ck_assert(GPIO_Platform_Pin_Valid(61));
  ck_assert(GPIO_Platform_Pin_Valid(88));
  ck_assert(GPIO_Platform_Pin_Valid(89));
  ck_assert(GPIO_Platform_Pin_Valid(11));
  ck_assert(GPIO_Platform_Pin_Valid(81));
  ck_assert(GPIO_Platform_Pin_Valid(80));

  ck_assert(GPIO_Platform_Pin_Valid(77));
  ck_assert(GPIO_Platform_Pin_Valid(75));
  ck_assert(GPIO_Platform_Pin_Valid(73));
  ck_assert(GPIO_Platform_Pin_Valid(71));
}
END_TEST

START_TEST(test_beaglebone_black_wireless)
{
  putenv("BOARDNAME=BeagleBoneBlackWireless");

  GPIO_Platform_Init();

  // P9 left side invalid pins

  ck_assert(!GPIO_Platform_Pin_Valid(30));	// RXD4
  ck_assert(!GPIO_Platform_Pin_Valid(31));	// TXD4

  ck_assert(!GPIO_Platform_Pin_Valid(13));	// I2C2 SCL
  ck_assert(!GPIO_Platform_Pin_Valid(3));	// TXD2

  ck_assert(!GPIO_Platform_Pin_Valid(111));	// SPI1 MISO
  ck_assert(!GPIO_Platform_Pin_Valid(110));	// SPI1 SCLK

  // P9 right side invalid pins

  ck_assert(!GPIO_Platform_Pin_Valid(12));	// I2C2 SDA
  ck_assert(!GPIO_Platform_Pin_Valid(2));	// RXD2
  ck_assert(!GPIO_Platform_Pin_Valid(15));	// TXD1
  ck_assert(!GPIO_Platform_Pin_Valid(14));	// RXD1
  ck_assert(!GPIO_Platform_Pin_Valid(113));	// SPI1 SS0
  ck_assert(!GPIO_Platform_Pin_Valid(112));	// SPI1 MOSI

  ck_assert(!GPIO_Platform_Pin_Valid(42));	// SPI1 SS1

  // P9 left side valid pins

  ck_assert(GPIO_Platform_Pin_Valid(48));
  ck_assert(GPIO_Platform_Pin_Valid(5));

  ck_assert(GPIO_Platform_Pin_Valid(49));
  ck_assert(GPIO_Platform_Pin_Valid(117));
  ck_assert(GPIO_Platform_Pin_Valid(115));

  ck_assert(GPIO_Platform_Pin_Valid(20));

  // P9 right side valid pins

  ck_assert(GPIO_Platform_Pin_Valid(60));
  ck_assert(GPIO_Platform_Pin_Valid(50));
  ck_assert(GPIO_Platform_Pin_Valid(51));
  ck_assert(GPIO_Platform_Pin_Valid(4));

  // P8 left side invalid pins

  ck_assert(!GPIO_Platform_Pin_Valid(38));	// MMC1_DAT6
  ck_assert(!GPIO_Platform_Pin_Valid(34));	// MMC1_DAT2

  ck_assert(!GPIO_Platform_Pin_Valid(62));	// MMC1_CLK
  ck_assert(!GPIO_Platform_Pin_Valid(36));	// MMC1_DAT4
  ck_assert(!GPIO_Platform_Pin_Valid(32));	// MMC1_DAT0

  ck_assert(!GPIO_Platform_Pin_Valid(78));	// TXD5

  // P8 right side invalid pins

  ck_assert(!GPIO_Platform_Pin_Valid(39));	// MMC1_DAT7
  ck_assert(!GPIO_Platform_Pin_Valid(35));	// MMC1_DAT3

  ck_assert(!GPIO_Platform_Pin_Valid(63));	// MMC1_CMD
  ck_assert(!GPIO_Platform_Pin_Valid(37));	// MMC1_DAT5
  ck_assert(!GPIO_Platform_Pin_Valid(33));	// MMC1_DAT1

  ck_assert(!GPIO_Platform_Pin_Valid(79));	// RXD5

  // P8 left side valid pins

  ck_assert(GPIO_Platform_Pin_Valid(66));
  ck_assert(GPIO_Platform_Pin_Valid(69));
  ck_assert(GPIO_Platform_Pin_Valid(45));
  ck_assert(GPIO_Platform_Pin_Valid(23));
  ck_assert(GPIO_Platform_Pin_Valid(47));
  ck_assert(GPIO_Platform_Pin_Valid(27));
  ck_assert(GPIO_Platform_Pin_Valid(22));

  ck_assert(GPIO_Platform_Pin_Valid(86));
  ck_assert(GPIO_Platform_Pin_Valid(87));
  ck_assert(GPIO_Platform_Pin_Valid(10));
  ck_assert(GPIO_Platform_Pin_Valid(9));
  ck_assert(GPIO_Platform_Pin_Valid(8));

  ck_assert(GPIO_Platform_Pin_Valid(76));
  ck_assert(GPIO_Platform_Pin_Valid(74));
  ck_assert(GPIO_Platform_Pin_Valid(72));
  ck_assert(GPIO_Platform_Pin_Valid(70));

  // P8 right side valid pins

  ck_assert(GPIO_Platform_Pin_Valid(67));
  ck_assert(GPIO_Platform_Pin_Valid(68));
  ck_assert(GPIO_Platform_Pin_Valid(44));
  ck_assert(GPIO_Platform_Pin_Valid(26));
  ck_assert(GPIO_Platform_Pin_Valid(46));
  ck_assert(GPIO_Platform_Pin_Valid(65));

  ck_assert(GPIO_Platform_Pin_Valid(61));
  ck_assert(GPIO_Platform_Pin_Valid(88));
  ck_assert(GPIO_Platform_Pin_Valid(89));
  ck_assert(GPIO_Platform_Pin_Valid(11));
  ck_assert(GPIO_Platform_Pin_Valid(81));
  ck_assert(GPIO_Platform_Pin_Valid(80));

  ck_assert(GPIO_Platform_Pin_Valid(77));
  ck_assert(GPIO_Platform_Pin_Valid(75));
  ck_assert(GPIO_Platform_Pin_Valid(73));
  ck_assert(GPIO_Platform_Pin_Valid(71));
}
END_TEST

START_TEST(test_beaglebone_green)
{
  putenv("BOARDNAME=BeagleBoneGreen");

  GPIO_Platform_Init();

  // P9 left side invalid pins

  ck_assert(!GPIO_Platform_Pin_Valid(30));	// RXD4
  ck_assert(!GPIO_Platform_Pin_Valid(31));	// TXD4

  ck_assert(!GPIO_Platform_Pin_Valid(13));	// I2C2 SCL
  ck_assert(!GPIO_Platform_Pin_Valid(3));	// TXD2

  ck_assert(!GPIO_Platform_Pin_Valid(111));	// SPI1 MISO
  ck_assert(!GPIO_Platform_Pin_Valid(110));	// SPI1 SCLK

  // P9 right side invalid pins

  ck_assert(!GPIO_Platform_Pin_Valid(12));	// I2C2 SDA
  ck_assert(!GPIO_Platform_Pin_Valid(2));	// RXD2
  ck_assert(!GPIO_Platform_Pin_Valid(15));	// TXD1
  ck_assert(!GPIO_Platform_Pin_Valid(14));	// RXD1
  ck_assert(!GPIO_Platform_Pin_Valid(113));	// SPI1 SS0
  ck_assert(!GPIO_Platform_Pin_Valid(112));	// SPI1 MOSI

  ck_assert(!GPIO_Platform_Pin_Valid(42));	// SPI1 SS1

  // P9 left side valid pins

  ck_assert(GPIO_Platform_Pin_Valid(48));
  ck_assert(GPIO_Platform_Pin_Valid(5));

  ck_assert(GPIO_Platform_Pin_Valid(49));
  ck_assert(GPIO_Platform_Pin_Valid(117));
  ck_assert(GPIO_Platform_Pin_Valid(115));

  ck_assert(GPIO_Platform_Pin_Valid(20));

  // P9 right side valid pins

  ck_assert(GPIO_Platform_Pin_Valid(60));
  ck_assert(GPIO_Platform_Pin_Valid(50));
  ck_assert(GPIO_Platform_Pin_Valid(51));
  ck_assert(GPIO_Platform_Pin_Valid(4));

  // P8 left side invalid pins

  ck_assert(!GPIO_Platform_Pin_Valid(38));	// MMC1_DAT6
  ck_assert(!GPIO_Platform_Pin_Valid(34));	// MMC1_DAT2

  ck_assert(!GPIO_Platform_Pin_Valid(62));	// MMC1_CLK
  ck_assert(!GPIO_Platform_Pin_Valid(36));	// MMC1_DAT4
  ck_assert(!GPIO_Platform_Pin_Valid(32));	// MMC1_DAT0

  ck_assert(!GPIO_Platform_Pin_Valid(78));	// TXD5

  // P8 right side invalid pins

  ck_assert(!GPIO_Platform_Pin_Valid(39));	// MMC1_DAT7
  ck_assert(!GPIO_Platform_Pin_Valid(35));	// MMC1_DAT3

  ck_assert(!GPIO_Platform_Pin_Valid(63));	// MMC1_CMD
  ck_assert(!GPIO_Platform_Pin_Valid(37));	// MMC1_DAT5
  ck_assert(!GPIO_Platform_Pin_Valid(33));	// MMC1_DAT1

  ck_assert(!GPIO_Platform_Pin_Valid(79));	// RXD5

  // P8 left side valid pins

  ck_assert(GPIO_Platform_Pin_Valid(66));
  ck_assert(GPIO_Platform_Pin_Valid(69));
  ck_assert(GPIO_Platform_Pin_Valid(45));
  ck_assert(GPIO_Platform_Pin_Valid(23));
  ck_assert(GPIO_Platform_Pin_Valid(47));
  ck_assert(GPIO_Platform_Pin_Valid(27));
  ck_assert(GPIO_Platform_Pin_Valid(22));

  ck_assert(GPIO_Platform_Pin_Valid(86));
  ck_assert(GPIO_Platform_Pin_Valid(87));
  ck_assert(GPIO_Platform_Pin_Valid(10));
  ck_assert(GPIO_Platform_Pin_Valid(9));
  ck_assert(GPIO_Platform_Pin_Valid(8));

  ck_assert(GPIO_Platform_Pin_Valid(76));
  ck_assert(GPIO_Platform_Pin_Valid(74));
  ck_assert(GPIO_Platform_Pin_Valid(72));
  ck_assert(GPIO_Platform_Pin_Valid(70));

  // P8 right side valid pins

  ck_assert(GPIO_Platform_Pin_Valid(67));
  ck_assert(GPIO_Platform_Pin_Valid(68));
  ck_assert(GPIO_Platform_Pin_Valid(44));
  ck_assert(GPIO_Platform_Pin_Valid(26));
  ck_assert(GPIO_Platform_Pin_Valid(46));
  ck_assert(GPIO_Platform_Pin_Valid(65));

  ck_assert(GPIO_Platform_Pin_Valid(61));
  ck_assert(GPIO_Platform_Pin_Valid(88));
  ck_assert(GPIO_Platform_Pin_Valid(89));
  ck_assert(GPIO_Platform_Pin_Valid(11));
  ck_assert(GPIO_Platform_Pin_Valid(81));
  ck_assert(GPIO_Platform_Pin_Valid(80));

  ck_assert(GPIO_Platform_Pin_Valid(77));
  ck_assert(GPIO_Platform_Pin_Valid(75));
  ck_assert(GPIO_Platform_Pin_Valid(73));
  ck_assert(GPIO_Platform_Pin_Valid(71));
}
END_TEST

START_TEST(test_pocketbeagle)
{
  static const unsigned pins[MAX_PLATFORM_PINS] =
  {
    117, 114, 111, 88, 87, 89, 20, 26, 110, 50, 23, 65, 27, 45, 86,
    59, 58, 57, 60, 52, 47, 64, 46, 44, 116, 113, 112, 115
  };

  TestBoardPins("PocketBeagle", pins);
}
END_TEST

int main(void)
{
  TCase   *tests;
  Suite   *suite;
  SRunner *runner;

  tests = tcase_create("Test validate.c");
  tcase_add_test(tests, test_beaglebone_white);
  tcase_add_test(tests, test_beaglebone_black);
  tcase_add_test(tests, test_beaglebone_black_wireless);
  tcase_add_test(tests, test_beaglebone_green);
  tcase_add_test(tests, test_pocketbeagle);

  suite = suite_create("Testing validate.c");
  suite_add_tcase(suite, tests);

  runner = srunner_create(suite);
  srunner_run_all(runner, CK_NORMAL);
}
