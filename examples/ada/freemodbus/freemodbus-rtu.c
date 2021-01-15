/*
 * FreeModbus Libary: Linux Demo Application
 * Copyright (C) 2006 Christian Walter <wolti@sil.at>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 *
 * File: $Id$
 */

#define _GNU_SOURCE

/* ----------------------- Standard includes --------------------------------*/
#include <errno.h>
#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <syslog.h>
#include <unistd.h>

/* ----------------------- Modbus includes ----------------------------------*/
#include "mb.h"
#include "mbport.h"

/* ----------------------- Defines ------------------------------------------*/
#define PROG            "freemodbus"

static enum ThreadState
{
    STOPPED,
    RUNNING,
    SHUTDOWN
} ePollThreadState;

static pthread_mutex_t xLock = PTHREAD_MUTEX_INITIALIZER;
static BOOL     bDoExit;

/* ----------------------- Static functions ---------------------------------*/
static BOOL     bCreatePollingThread( void );
static enum ThreadState eGetPollingThreadState( void );
static void     vSetPollingThreadState( enum ThreadState eNewState );
static void    *pvPollingThread( void *pvParameter );

/* ----------------------- Start implementation -----------------------------*/

#define PROGNAME "FreeMODBUS RTU for MuntsOS"

extern void adainit(void);
extern void adafinal(void);

BOOL
bSetSignal( int iSignalNr, void ( *pSigHandler ) ( int ) )
{
    BOOL            bResult;
    struct sigaction xNewSig, xOldSig;

    xNewSig.sa_handler = pSigHandler;
    sigemptyset( &xNewSig.sa_mask );
    xNewSig.sa_flags = 0;
    if( sigaction( iSignalNr, &xNewSig, &xOldSig ) != 0 )
    {
        bResult = FALSE;
    }
    else
    {
        bResult = TRUE;
    }
    return bResult;
}

void
vSigShutdown( int xSigNr )
{
    switch ( xSigNr )
    {
    case SIGQUIT:
    case SIGINT:
    case SIGTERM:
        vSetPollingThreadState( SHUTDOWN );
        bDoExit = TRUE;
    }
}

int
main( int argc, char *argv[] )
{
    openlog(PROGNAME, LOG_PERROR|LOG_PID, LOG_LOCAL0);
    syslog(LOG_INFO, "Starting");

    adainit();

    if( !bSetSignal( SIGQUIT, vSigShutdown ) ||
        !bSetSignal( SIGINT, vSigShutdown ) || !bSetSignal( SIGTERM, vSigShutdown ) )
    {
        syslog(LOG_ERR, "%s: can't install signal handlers: %s!\n", PROG, strerror( errno ) );
        return EXIT_FAILURE;
    }

    if( eMBInit( MB_RTU, 0x0A, 0, 115200, MB_PAR_NONE ) != MB_ENOERR )
    {
        syslog(LOG_ERR, "%s: can't initialize modbus stack!\n", PROG );
        return EXIT_FAILURE;
    }

    daemon(0, 0);

    vSetPollingThreadState(STOPPED);
    bCreatePollingThread();

    syslog(LOG_INFO, "Ready");

    for (;;)
    {
      sleep(1);
      pthread_yield();
    }
}

BOOL
bCreatePollingThread( void )
{
    BOOL            bResult;
    pthread_t       xThread;

    if( eGetPollingThreadState(  ) == STOPPED )
    {
        if( pthread_create( &xThread, NULL, pvPollingThread, NULL ) != 0 )
        {
            bResult = FALSE;
        }
        else
        {
            bResult = TRUE;
        }
    }
    else
    {
        bResult = FALSE;
    }

    return bResult;
}

void           *
pvPollingThread( void *pvParameter )
{
    vSetPollingThreadState( RUNNING );

    if( eMBEnable(  ) == MB_ENOERR )
    {
        do
        {
            if( eMBPoll(  ) != MB_ENOERR )
                break;
        }
        while( eGetPollingThreadState(  ) != SHUTDOWN );
    }

    ( void )eMBDisable(  );

    vSetPollingThreadState( STOPPED );

    return 0;
}

enum ThreadState
eGetPollingThreadState(  )
{
    enum ThreadState eCurState;

    ( void )pthread_mutex_lock( &xLock );
    eCurState = ePollThreadState;
    ( void )pthread_mutex_unlock( &xLock );

    return eCurState;
}

void
vSetPollingThreadState( enum ThreadState eNewState )
{
    ( void )pthread_mutex_lock( &xLock );
    ePollThreadState = eNewState;
    ( void )pthread_mutex_unlock( &xLock );
}
