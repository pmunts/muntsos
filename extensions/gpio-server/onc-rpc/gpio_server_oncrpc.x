/* ONC/RPC Interface Declarations for a dedicated GPIO server                  */

/* Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.             */
/*                                                                             */
/* Redistribution and use in source and binary forms, with or without          */
/* modification, are permitted provided that the following conditions are met: */
/*                                                                             */
/* * Redistributions of source code must retain the above copyright notice,    */
/*   this list of conditions and the following disclaimer.                     */
/*                                                                             */
/* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" */
/* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE   */
/* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE  */
/* ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE   */
/* LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR         */
/* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF        */
/* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS    */
/* INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN     */
/* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)     */
/* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE  */
/* POSSIBILITY OF SUCH DAMAGE.                                                 */

enum GPIO_DIRECTION
{
  GPIO_DIRECTION_INPUT  = 0,
  GPIO_DIRECTION_OUTPUT = 1
};

program GPIO_SERVER_ONCRPC
{
  version GPIO_SERVER_ONCRPC_VERS
  {
    int gpio_open(int pin, int direction, int state) = 1;
    int gpio_close(int pin) = 2;
    int gpio_read(int pin) = 3;
    int gpio_write(int pin, int state) = 4;
  } = 1;
} = 30000;
