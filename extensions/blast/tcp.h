/******************************************************************************/
/*                                                                            */
/*  Filename:    tcp.h                                                        */
/*                                                                            */
/*  Abstract:    Simple TCP client and server functions.                      */
/*                                                                            */
/*  Author:      Philip Munts                                                 */
/*                                                                            */
/*  History:     27 September 1995 -- PM -- Initial version.                  */
/*                                                                            */
/*  This program defines a simplified interface to Unix BSD sockets.          */
/*                                                                            */
/******************************************************************************/

// Copyright (C)2018-2024, Philip Munts dba Munts Technologies.
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
#include <netdb.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>

/******************************************************************************/
/*                                                                            */
/*            Resolve internet host name to 32-bit IP address.                */
/*                                                                            */
/*            Return 0L if host name cannot be resolved.                      */
/*                                                                            */
/******************************************************************************/

static uint32_t resolve(char *name)

{
  struct hostent *he;

  he = gethostbyname(name);

  if (he == NULL)
    return 0L;
  else
    return htonl(*(uint32_t *)he->h_addr);
}

/******************************************************************************/
/*                                                                            */
/*           Open TCP client connection to specified host and port.           */
/*                                                                            */
/*           Return file descriptor for the bidirectional connection.         */
/*                                                                            */
/*           Return -1 if connection could not be opened.                     */
/*                                                                            */
/******************************************************************************/

static int tcp_call(uint32_t hishost, uint16_t hisport)

{
  int s;
  struct sockaddr_in hisaddr;

/* Attempt to create a socket */

  s = socket(AF_INET, SOCK_STREAM, 0);
  if (s < 0)
  {
#ifdef DEBUG
    fprintf(stderr, "ERROR: socket() failed, errno=%d\n", errno);
#endif
    return -1;
  }

/* Build address structure for the specified server */

  memset(&hisaddr, 0, sizeof(hisaddr));

  hisaddr.sin_family = AF_INET;
  hisaddr.sin_addr.s_addr = htonl(hishost);
  hisaddr.sin_port = htons(hisport);

/* Attempt to open connection to the server */

  if (connect(s, (struct sockaddr *)&hisaddr, sizeof(hisaddr)))
  {
#ifdef DEBUG
    fprintf(stderr, "ERROR: connect() failed, errno=%d\n", errno);
#endif
    return -1;
  }

  return s;
}

/******************************************************************************/
/*                                                                            */
/*       Open TCP server connection to first client on specified port.        */
/*                                                                            */
/*       Block until the client opens the connection.                         */
/*                                                                            */
/*       Return file descriptor for the bidirectional connection.             */
/*                                                                            */
/*       Return -1 if connection could not be opened.                         */
/*                                                                            */
/******************************************************************************/

static int tcp_answer(uint16_t myport)

{
  int s1, s2;
  struct sockaddr_in myaddr;

/* Attempt to create a socket */

  s1 = socket(AF_INET, SOCK_STREAM, 0);
  if (s1 < 0)
  {
#ifdef DEBUG
    fprintf(stderr, "ERROR: socket() failed, errno=%d\n", errno);
#endif
    return -1;
  }

/* Attempt to bind socket */

  memset(&myaddr, 0, sizeof(myaddr));
  myaddr.sin_family = AF_INET;
  myaddr.sin_addr.s_addr = htonl(INADDR_ANY);
  myaddr.sin_port = htons(myport);

  if (bind(s1, (struct sockaddr *)&myaddr, sizeof(myaddr)))
  {
#ifdef DEBUG
    fprintf(stderr, "ERROR: bind() failed, errno=%d\n", errno);
#endif
    return -1;
  }

/* Establish incoming connection queue */

  if (listen(s1, 5))
  {
#ifdef DEBUG
    fprintf(stderr, "ERROR: listen() failed, errno=%d\n", errno);
#endif
    return -1;
  }

  for (;;)
  {

/* Wait for incoming connection */

    s2 = accept(s1, NULL, NULL);
    if (s2 == -1)
    {
#ifdef DEBUG
       fprintf(stderr, "ERROR: accept() failed, errno=%d\n", errno);
#endif
       return -1;
    }

/* Spawn child process for the new connection */

    if (fork() == 0)
    {
       close(s1);
       return s2;
    }

    close(s2);
  }
}

/******************************************************************************/
/*                                                                            */
/*       Open TCP server connection to first client on specified port.        */
/*                                                                            */
/*       Block until the client opens the connection.                         */
/*                                                                            */
/*       Return file descriptor for the bidirectional connection.             */
/*                                                                            */
/*       Return -1 if connection could not be opened.                         */
/*                                                                            */
/******************************************************************************/

static int tcp_answer_once(uint16_t myport)

{
  int s1, s2;
  struct sockaddr_in myaddr;

/* Attempt to create a socket */

  s1 = socket(AF_INET, SOCK_STREAM, 0);
  if (s1 < 0)
  {
#ifdef DEBUG
    fprintf(stderr, "ERROR: socket() failed, errno=%d\n", errno);
#endif
    return -1;
  }

/* Attempt to bind socket */

  memset(&myaddr, 0, sizeof(myaddr));
  myaddr.sin_family = AF_INET;
  myaddr.sin_addr.s_addr = htonl(INADDR_ANY);
  myaddr.sin_port = htons(myport);

  if (bind(s1, (struct sockaddr *)&myaddr, sizeof(myaddr)))
  {
#ifdef DEBUG
    fprintf(stderr, "ERROR: bind() failed, errno=%d\n", errno);
#endif
    return -1;
  }

/* Establish incoming connection queue */

  if (listen(s1, 5))
  {
#ifdef DEBUG
    fprintf(stderr, "ERROR: listen() failed, errno=%d\n", errno);
#endif
    return -1;
  }

/* Wait for incoming connection */

  s2 = accept(s1, NULL, NULL);
  if (s2 == -1)
  {
#ifdef DEBUG
     fprintf(stderr, "ERROR: accept() failed, errno=%d\n", errno);
#endif
     return -1;
  }

  close(s1);
  return s2;
}
