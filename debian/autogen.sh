#!/bin/sh
set -e
cd client/nbd-proxy/
autoreconf --force --install
cd -
set -x
cd server/man/
autoreconf --force --install
cd -
