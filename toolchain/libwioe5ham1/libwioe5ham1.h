// Copyright (C)2025, Philip Munts dba Munts Technologies.
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

#ifndef LIBWIOE5HAM1_H
#define LIBWIOE5HAM1_H

#include <stdint.h>

extern void wioe5ham1_init(char *portname, int32_t baudrate, float freqmhz,
  int32_t spreading, int32_t bandwidth, int32_t txpreamble, int32_t rxpreamble,
  int32_t txpower, char *network, int32_t node, int32_t *handle, int32_t *error);

extern void wioe5ham1_receive(int32_t handle, void *msg, int32_t *len,
  int32_t *src, int32_t *dst, int32_t *rss, int32_t *snr, int32_t *error);

extern void wioe5ham1_send(int32_t handle, void *msg, int32_t len,
  int32_t dst, int32_t *error);

extern void wioe5ham1_send_string(int32_t handle, char *s, int32_t dst,
  int32_t *error);

#endif
