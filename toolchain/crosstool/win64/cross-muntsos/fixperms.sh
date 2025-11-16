#! /bin/sh

# Fix permissions after installing from tarball with Cygwin tar

/bin/find * -type f                   -print -exec chmod 444 {} ";"
/bin/find * -type f -name '*.dll'     -print -exec chmod 555 {} ";"
/bin/find * -type f -name '*.exe'     -print -exec chmod 555 {} ";"
/bin/find * -type f -name fixperms.sh -print -exec chmod 555 {} ";"
/bin/find * -type d                   -print -exec chmod 555 {} ";"
