#! /bin/sh

# Fix permissions after installing from tarball with Cygwin tar

find @@TOOLCHAIN_DIR@@ -type f -exec chmod 444 {} ";"
find @@TOOLCHAIN_DIR@@ -type f -name '*.dll' -exec chmod 555 {} ";"
find @@TOOLCHAIN_DIR@@ -type f -name '*.exe' -exec chmod 555 {} ";"
find @@TOOLCHAIN_DIR@@ -type f -name fixperms.sh -exec chmod 555 {} ";"
find @@TOOLCHAIN_DIR@@ -type d -exec chmod 555 {} ";"
