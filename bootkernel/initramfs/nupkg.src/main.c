// NuGet Application Package Installer for MuntSOS

// Copyright (C)2020-2022, Philip Munts, President, Munts AM Corp.
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
#include <fcntl.h>
#include <libgen.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>

#include "unzip.h"

// Extract application program name from the NuGet package name

static void ExtractAppName(char *src, char *dst, int dstsize)
{
  char srcbuf[256];
  char *p;
  int i;

  memset(srcbuf, 0, sizeof(srcbuf));
  strncpy(srcbuf, src, sizeof(srcbuf) - 1);
  p = basename(srcbuf);

  memset(dst, 0, dstsize);

  for (i = 0; (i < strlen(src)) && (i < dstsize - 1); i++)
    if (p[i] == '.')
      break;
    else
      dst[i] = p[i];
}

// Create the destination directory /usr/local/lib/<appname>

static void CreateDestinationDirectory(char *appname)
{
  char dirname[256];
  memset(dirname, 0, sizeof(dirname));
  snprintf(dirname, sizeof(dirname), "/usr/local/lib/%s", appname);

  // Remove existing directory just in case
  char cmdbuf[512];
  memset(cmdbuf, 0, sizeof(cmdbuf));
  snprintf(cmdbuf, sizeof(cmdbuf), "rm -rf %s", dirname);
  system(cmdbuf);

  if (mkdir(dirname, 0555))
  {
    fprintf(stderr, "ERROR: Cannot create %s, %s\n", dirname,
      strerror(errno));
    exit(1);
  }
}

// Copy a file from the NuGet package to /usr/local/lib/<appname>

static void CopyFile(unzFile zf, char *appname, char *srcname)
{
  char dstname[256];
  int fd;
  int rlen;
  uint8_t buf[65536];
  ssize_t wlen;

  if (unzOpenCurrentFile(zf) != UNZ_OK)
  {
    fprintf(stderr, "ERROR: Cannot open %s\n", srcname);
    return;
  }

  memset(dstname, 0, sizeof(dstname));
  snprintf(dstname, sizeof(dstname), "/usr/local/lib/%s/%s", appname, srcname);

  fd = creat(dstname, 0444);

  if (fd < 0)
    fprintf(stderr, "ERROR: Cannot create %s, %s\n", dstname, strerror(errno));
  else
  {
    while ((rlen = unzReadCurrentFile(zf, buf, sizeof(buf))) > 0)
    {
      wlen = write(fd, buf, rlen);

      if (wlen != rlen)
      {
        fprintf(stderr, "ERROR: Cannot write to %s\n", dstname);
        break;
      }
    }

    close(fd);
  }

  if (unzCloseCurrentFile(zf) != UNZ_OK)
  {
    fprintf(stderr, "ERROR: Error on closing %s\n", srcname);
  }
}

// Copy the optional startup script to /etc/rc.d

static void CopyStartupScript(unzFile zf, char *appname, char *srcname)
{
  char dstname[256];
  int fd;
  int rlen;
  uint8_t buf[65536];
  ssize_t wlen;

  if (unzOpenCurrentFile(zf) != UNZ_OK)
  {
    fprintf(stderr, "ERROR: Cannot open %s\n", srcname);
    return;
  }

  mkdir("/etc/rc.d", 0555);

  memset(dstname, 0, sizeof(dstname));
  snprintf(dstname, sizeof(dstname), "/etc/rc.d/%s", srcname);

  fd = creat(dstname, 0555);

  if (fd < 0)
    fprintf(stderr, "ERROR: Cannot create %s, %s\n", dstname, strerror(errno));
  else
  {
    while ((rlen = unzReadCurrentFile(zf, buf, sizeof(buf))) > 0)
    {
      wlen = write(fd, buf, rlen);

      if (wlen != rlen)
      {
        fprintf(stderr, "ERROR: Cannot write to %s\n", dstname);
        break;
      }
    }

    close(fd);
  }

  if (unzCloseCurrentFile(zf) != UNZ_OK)
  {
    fprintf(stderr, "ERROR: Error on closing %s\n", srcname);
  }
}

// Create the helper script file /usr/local/bin/<appname>

static void CreateHelperScript(char *appname)
{
  char filename[256];
  int fd;
  char outbuf[256];
  ssize_t len;

  // Construct filename

  memset(filename, 0, sizeof(filename));
  snprintf(filename, sizeof(filename), "/usr/local/bin/%s", appname);

  // Open helper script file

  fd = creat(filename, 0555);

  if (fd < 0)
  {
    fprintf(stderr, "ERROR: Cannot create %s\n", filename);
    exit(1);
  }

  // Write to helper script file

  snprintf(outbuf, sizeof(outbuf),
    "exec dotnet /usr/local/lib/%s/%s.dll \"$@\"\n", appname, appname);

  len = write(fd, outbuf, strlen(outbuf));

  if (len < strlen(outbuf))
  {
    fprintf(stderr, "ERROR: Cannot write to %s\n", filename);
    exit(1);
  }

  // Close helper script file

  close(fd);
}

int main(int argc, char *argv[])
{
  unzFile zf;
  char appname[64];
  char filename[256];
  int status;

  // Validate parameters

  if (argc != 2)
  {
    fprintf(stderr, "\nNuGet Application Package Installer for MuntSOS "
      "Embedded Linux\n\nUsage: install-nupkg <filename>\n\n");
    exit(1);
  }

  // Open the NuGet package file

  zf = unzOpen64(argv[1]);

  if (zf == NULL)
  {
    fprintf(stderr, "ERROR: Cannot open file %s\n", argv[1]);
    exit(1);
  }

  // Seek to the first file in the NuGet package

  if (unzGoToFirstFile(zf) != UNZ_OK)
  {
    fprintf(stderr, "ERROR: Cannot find first file in %s\n", argv[1]);
    exit(1);
  }

  ExtractAppName(argv[1], appname, sizeof(appname));

  CreateDestinationDirectory(appname);

  // Extract application files from the NuGet package

  for (;;)
  {
    memset(filename, 0, sizeof(filename));

    // Get the name of the current file in the NuGet package

    unzGetCurrentFileInfo64(zf, NULL, filename, sizeof(filename), NULL, 0,
      NULL, 0);

    // Extract what we want from the NuGet package

    if (!strncmp(filename, "lib/netcoreapp", 14))
      CopyFile(zf, appname, basename(filename));

    if (!strncmp(filename, "lib/net5.0", 10))
      CopyFile(zf, appname, basename(filename));

    if (!strncmp(filename, "lib/net6.0", 10))
      CopyFile(zf, appname, basename(filename));

    if (!strncmp(filename, "lib/net7.0", 10))
      CopyFile(zf, appname, basename(filename));

    if (!strncmp(filename, "rc.d/", 5))
      CopyStartupScript(zf, appname, basename(filename));

    // Seek to the next file in the NuGet package

    status = unzGoToNextFile(zf);

    if (status == UNZ_END_OF_LIST_OF_FILE) break;

    if (status != UNZ_OK)
    {
      fprintf(stderr, "ERROR: Cannot find next file in %s\n", argv[1]);
      exit(1);
    }
  }

  unzClose(zf);

  CreateHelperScript(appname);

  exit(0);
}
