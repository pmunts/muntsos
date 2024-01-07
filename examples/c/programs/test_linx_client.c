// LabView LINX Test Client

// Copyright (C)2016-2024, Philip Munts dba Munts Technologies.
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

#include <errno.h>
#include <libsimpleio/liblinx.h>
#include <libsimpleio/libipv4.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define SERVICENAME	"gpio-linx"
#define HOSTNAME	argv[1]
#define PORTNUMBER	argv[2]

int main(int argc, char *argv[])
{
  int server;
  int port;
  int fd;
  LINX_command_t cmd;
  int count = 0;
  LINX_response_t resp;
  uint16_t packetcounter = 0;
  int error;
  int i;

  puts("\nLabView LINX Remote I/O Test Client\n");

  if (argc != 3)
  {
    fprintf(stderr, "Usage: test_linx_client <host> <port>\n");
    exit(1);
  }

  // Look up the LINX TCP server IP address

  IPV4_resolve(HOSTNAME, &server, &error);
  if (error)
  {
    fprintf(stderr, "ERROR: IPV4_resolve() failed, %s\n", strerror(error));
    exit(1);
  }

  port = atoi(PORTNUMBER);

  // Open connection to the LINX TCP server

  TCP4_connect(server, port, &fd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR: TCP4_connect() failed, %s\n", strerror(error));
    exit(1);
  }

  // Issue SYNC command

  puts("SYNC command");

  cmd.SoF = 0xFF;
  cmd.PacketSize = 7;
  cmd.PacketNum = ++packetcounter;
  cmd.Command = CMD_SYNC;

  LINX_transmit_command(fd, &cmd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_transmit_command() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  memset(&resp, 0, sizeof(resp));

  do
  {
    LINX_receive_response(fd, &resp, &count, &error);
  }
  while (error == EAGAIN);

  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_receive_response() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  printf("Response status is  0x%02X\n", resp.Status);
  printf("Packet number is    %d\n\n", resp.PacketNum);

  // Issue FLUSH command

  puts("FLUSH command");

  cmd.SoF = 0xFF;
  cmd.PacketSize = 7;
  cmd.PacketNum = ++packetcounter;
  cmd.Command = CMD_FLUSH;

  LINX_transmit_command(fd, &cmd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_transmit_command() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  memset(&resp, 0, sizeof(resp));

  do
  {
    LINX_receive_response(fd, &resp, &count, &error);
  }
  while (error == EAGAIN);

  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_receive_response() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  printf("Response status is  0x%02X\n", resp.Status);
  printf("Packet number is    %d\n\n", resp.PacketNum);

  // Issue SYSTEM RESET command

  puts("SYSTEM RESET");

  cmd.SoF = 0xFF;
  cmd.PacketSize = 7;
  cmd.PacketNum = ++packetcounter;
  cmd.Command = CMD_SYSTEM_RESET;

  LINX_transmit_command(fd, &cmd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_transmit_command() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  memset(&resp, 0, sizeof(resp));

  do
  {
    LINX_receive_response(fd, &resp, &count, &error);
  }
  while (error == EAGAIN);

  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_receive_response() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  printf("Response status is  0x%02X\n", resp.Status);
  printf("Packet number is    %d\n\n", resp.PacketNum);

  usleep(100000);

  // Issue GET DEVICE ID command

  puts("GET DEVICE ID");

  cmd.SoF = 0xFF;
  cmd.PacketSize = 7;
  cmd.PacketNum = ++packetcounter;
  cmd.Command = CMD_GET_DEVICE_ID;

  LINX_transmit_command(fd, &cmd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_transmit_command() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  memset(&resp, 0, sizeof(resp));

  do
  {
    LINX_receive_response(fd, &resp, &count, &error);
  }
  while (error == EAGAIN);

  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_receive_response() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  printf("Response status is  0x%02X\n", resp.Status);
  printf("Packet number is    %d\n", resp.PacketNum);
  printf("Device Family is    %d\n", resp.Data[0]);
  printf("Device ID is        %d\n\n", resp.Data[1]);

  // Issue GET LINX API VERSION command

  puts("GET LINX API VERSION");

  cmd.SoF = 0xFF;
  cmd.PacketSize = 7;
  cmd.PacketNum = ++packetcounter;
  cmd.Command = CMD_GET_LINX_API_VERSION;

  LINX_transmit_command(fd, &cmd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_transmit_command() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  memset(&resp, 0, sizeof(resp));

  do
  {
    LINX_receive_response(fd, &resp, &count, &error);
  }
  while (error == EAGAIN);

  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_receive_response() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  printf("Response status is  0x%02X\n", resp.Status);
  printf("Packet number is    %d\n", resp.PacketNum);
  printf("API version is      %02X %02X %02X %02X\n\n",
    resp.Data[0], resp.Data[1], resp.Data[2], resp.Data[3]);

  // Issue SET DEVICE USER ID command

  puts("SET DEVICE USER ID");

  cmd.SoF = 0xFF;
  cmd.PacketSize = 9;
  cmd.PacketNum = ++packetcounter;
  cmd.Command = CMD_SET_DEVICE_USER_ID;
  cmd.Args[0] = 0xDE;
  cmd.Args[1] = 0xAD;

  LINX_transmit_command(fd, &cmd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_transmit_command() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  memset(&resp, 0, sizeof(resp));

  do
  {
    LINX_receive_response(fd, &resp, &count, &error);
  }
  while (error == EAGAIN);

  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_receive_response() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  printf("Response status is  0x%02X\n", resp.Status);
  printf("Packet number is    %d\n\n", resp.PacketNum);

  // Issue GET DEVICE USER ID command

  puts("GET DEVICE USER ID");

  cmd.SoF = 0xFF;
  cmd.PacketSize = 7;
  cmd.PacketNum = ++packetcounter;
  cmd.Command = CMD_GET_DEVICE_USER_ID;

  LINX_transmit_command(fd, &cmd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_transmit_command() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  memset(&resp, 0, sizeof(resp));

  do
  {
    LINX_receive_response(fd, &resp, &count, &error);
  }
  while (error == EAGAIN);

  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_receive_response() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  printf("Response status is  0x%02X\n", resp.Status);
  printf("Packet number is    %d\n", resp.PacketNum);
  printf("Device user ID is   0x%04X\n\n", (resp.Data[0] << 8) + resp.Data[1]);

  // Issue GET DEVICE NAME command

  puts("GET DEVICE NAME");

  cmd.SoF = 0xFF;
  cmd.PacketSize = 7;
  cmd.PacketNum = ++packetcounter;
  cmd.Command = CMD_GET_DEVICE_NAME;

  LINX_transmit_command(fd, &cmd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_transmit_command() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  memset(&resp, 0, sizeof(resp));

  do
  {
    LINX_receive_response(fd, &resp, &count, &error);
  }
  while (error == EAGAIN);

  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_receive_response() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  printf("Response status is  0x%02X\n", resp.Status);
  printf("Packet number is    %d\n", resp.PacketNum);
  printf("Device name is      %s\n\n", (char *) resp.Data);

  // Issue GET GPIO CHANNELS command

  puts("GET GPIO CHANNELS");

  cmd.SoF = 0xFF;
  cmd.PacketSize = 7;
  cmd.PacketNum = ++packetcounter;
  cmd.Command = CMD_GET_GPIO_CHANNELS;

  LINX_transmit_command(fd, &cmd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_transmit_command() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  memset(&resp, 0, sizeof(resp));

  do
  {
    LINX_receive_response(fd, &resp, &count, &error);
  }
  while (error == EAGAIN);

  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_receive_response() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  printf("Response status is  0x%02X\n", resp.Status);
  printf("Packet number is    %d\n", resp.PacketNum);

  printf("GPIO channels are:");

  for (i = 0; i < resp.PacketSize - 6; i++)
    printf(" %d", resp.Data[i]);

  printf("\n\n");

  // Issue GET ANALOG INPUT CHANNELS command

  puts("GET ANALOG INPUT CHANNELS");

  cmd.SoF = 0xFF;
  cmd.PacketSize = 7;
  cmd.PacketNum = ++packetcounter;
  cmd.Command = CMD_GET_ANALOG_IN_CHANNELS;

  LINX_transmit_command(fd, &cmd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_transmit_command() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  memset(&resp, 0, sizeof(resp));

  do
  {
    LINX_receive_response(fd, &resp, &count, &error);
  }
  while (error == EAGAIN);

  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_receive_response() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  printf("Response status is  0x%02X\n", resp.Status);
  printf("Packet number is    %d\n", resp.PacketNum);

  printf("Analog input channels are:");

  for (i = 0; i < resp.PacketSize - 6; i++)
    printf(" %d", resp.Data[i]);

  printf("\n\n");

  // Issue GET ANALOG OUTPUT CHANNELS command

  puts("GET ANALOG OUTPUT CHANNELS");

  cmd.SoF = 0xFF;
  cmd.PacketSize = 7;
  cmd.PacketNum = ++packetcounter;
  cmd.Command = CMD_GET_ANALOG_OUT_CHANNELS;

  LINX_transmit_command(fd, &cmd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_transmit_command() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  memset(&resp, 0, sizeof(resp));

  do
  {
    LINX_receive_response(fd, &resp, &count, &error);
  }
  while (error == EAGAIN);

  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_receive_response() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  printf("Response status is  0x%02X\n", resp.Status);
  printf("Packet number is    %d\n", resp.PacketNum);

  printf("Analog output channels are:");

  for (i = 0; i < resp.PacketSize - 6; i++)
    printf(" %d", resp.Data[i]);

  printf("\n\n");

  // Issue GET PWM CHANNELS command

  puts("GET PWM CHANNELS");

  cmd.SoF = 0xFF;
  cmd.PacketSize = 7;
  cmd.PacketNum = ++packetcounter;
  cmd.Command = CMD_GET_PWM_CHANNELS;

  LINX_transmit_command(fd, &cmd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_transmit_command() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  memset(&resp, 0, sizeof(resp));

  do
  {
    LINX_receive_response(fd, &resp, &count, &error);
  }
  while (error == EAGAIN);

  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_receive_response() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  printf("Response status is  0x%02X\n", resp.Status);
  printf("Packet number is    %d\n", resp.PacketNum);

  printf("PWM output channels are:");

  for (i = 0; i < resp.PacketSize - 6; i++)
    printf(" %d", resp.Data[i]);

  printf("\n\n");

  // Issue GET QE CHANNELS command

  puts("GET QE CHANNELS");

  cmd.SoF = 0xFF;
  cmd.PacketSize = 7;
  cmd.PacketNum = ++packetcounter;
  cmd.Command = CMD_GET_QE_CHANNELS;

  LINX_transmit_command(fd, &cmd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_transmit_command() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  memset(&resp, 0, sizeof(resp));

  do
  {
    LINX_receive_response(fd, &resp, &count, &error);
  }
  while (error == EAGAIN);

  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_receive_response() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  printf("Response status is  0x%02X\n", resp.Status);
  printf("Packet number is    %d\n", resp.PacketNum);

  printf("QE channels are:");

  for (i = 0; i < resp.PacketSize - 6; i++)
    printf(" %d", resp.Data[i]);

  printf("\n\n");

  // Issue GET UART CHANNELS command

  puts("GET UART CHANNELS");

  cmd.SoF = 0xFF;
  cmd.PacketSize = 7;
  cmd.PacketNum = ++packetcounter;
  cmd.Command = CMD_GET_UART_CHANNELS;

  LINX_transmit_command(fd, &cmd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_transmit_command() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  memset(&resp, 0, sizeof(resp));

  do
  {
    LINX_receive_response(fd, &resp, &count, &error);
  }
  while (error == EAGAIN);

  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_receive_response() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  printf("Response status is  0x%02X\n", resp.Status);
  printf("Packet number is    %d\n", resp.PacketNum);

  printf("UART channels are:");

  for (i = 0; i < resp.PacketSize - 6; i++)
    printf(" %d", resp.Data[i]);

  printf("\n\n");

  // Issue GET I2C CHANNELS command

  puts("GET I2C CHANNELS");

  cmd.SoF = 0xFF;
  cmd.PacketSize = 7;
  cmd.PacketNum = ++packetcounter;
  cmd.Command = CMD_GET_I2C_CHANNELS;

  LINX_transmit_command(fd, &cmd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_transmit_command() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  memset(&resp, 0, sizeof(resp));

  do
  {
    LINX_receive_response(fd, &resp, &count, &error);
  }
  while (error == EAGAIN);

  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_receive_response() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  printf("Response status is  0x%02X\n", resp.Status);
  printf("Packet number is    %d\n", resp.PacketNum);

  printf("I2C channels are:");

  for (i = 0; i < resp.PacketSize - 6; i++)
    printf(" %d", resp.Data[i]);

  printf("\n\n");

  // Issue GET SPI CHANNELS command

  puts("GET SPI CHANNELS");

  cmd.SoF = 0xFF;
  cmd.PacketSize = 7;
  cmd.PacketNum = ++packetcounter;
  cmd.Command = CMD_GET_SPI_CHANNELS;

  LINX_transmit_command(fd, &cmd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_transmit_command() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  memset(&resp, 0, sizeof(resp));

  do
  {
    LINX_receive_response(fd, &resp, &count, &error);
  }
  while (error == EAGAIN);

  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_receive_response() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  printf("Response status is  0x%02X\n", resp.Status);
  printf("Packet number is    %d\n", resp.PacketNum);

  printf("SPI channels are:");

  for (i = 0; i < resp.PacketSize - 6; i++)
    printf(" %d", resp.Data[i]);

  printf("\n\n");

  // Issue GET CAN CHANNELS command

  puts("GET CAN CHANNELS");

  cmd.SoF = 0xFF;
  cmd.PacketSize = 7;
  cmd.PacketNum = ++packetcounter;
  cmd.Command = CMD_GET_CAN_CHANNELS;

  LINX_transmit_command(fd, &cmd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_transmit_command() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  memset(&resp, 0, sizeof(resp));

  do
  {
    LINX_receive_response(fd, &resp, &count, &error);
  }
  while (error == EAGAIN);

  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_receive_response() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  printf("Response status is  0x%02X\n", resp.Status);
  printf("Packet number is    %d\n", resp.PacketNum);

  printf("CAN channels are:");

  for (i = 0; i < resp.PacketSize - 6; i++)
    printf(" %d", resp.Data[i]);

  printf("\n\n");

  // Issue GET SERVO CHANNELS command

  puts("GET SERVO CHANNELS");

  cmd.SoF = 0xFF;
  cmd.PacketSize = 7;
  cmd.PacketNum = ++packetcounter;
  cmd.Command = CMD_GET_SERVO_CHANNELS;

  LINX_transmit_command(fd, &cmd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_transmit_command() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  memset(&resp, 0, sizeof(resp));

  do
  {
    LINX_receive_response(fd, &resp, &count, &error);
  }
  while (error == EAGAIN);

  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_receive_response() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  printf("Response status is  0x%02X\n", resp.Status);
  printf("Packet number is    %d\n", resp.PacketNum);

  printf("Servo output channels are:");

  for (i = 0; i < resp.PacketSize - 6; i++)
    printf(" %d", resp.Data[i]);

  printf("\n\n");

  // Unknown command

  puts("UNKNOWN command");

  cmd.SoF = 0xFF;
  cmd.PacketSize = 7;
  cmd.PacketNum = 1234;
  cmd.Command = 0x5678;

  LINX_transmit_command(fd, &cmd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_transmit_command() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  memset(&resp, 0, sizeof(resp));

  do
  {
    LINX_receive_response(fd, &resp, &count, &error);
  }
  while (error == EAGAIN);

  if (error)
  {
    fprintf(stderr, "ERROR at line %d: LINX_receive_response() failed, %s\n", __LINE__, strerror(error));
    exit(1);
  }

  printf("Response status is  0x%02X\n", resp.Status);
  printf("Packet number is    %d\n\n", resp.PacketNum);

  exit(0);
}
