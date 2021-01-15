/* ONC-RPC interface definition for the Dream Cheeky USB missile launcher */

/* Copyright (C)2013-2018, Philip Munts, President, Munts AM Corp.             */
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

/* Command definitions */

const CMD_NOP	= 0x00;
const CMD_DOWN	= 0x01;
const CMD_UP	= 0x02;
const CMD_CCW	= 0x04;
const CMD_CW	= 0x08;
const CMD_FIRE	= 0x10;
const CMD_STOP	= 0x20;

/* RPC definitions */

program MISSILE
{
  version MISSILE_VERS
  {
    int missile_command(unsigned cmd) = 1;
  } = 1;
} = 20000;
