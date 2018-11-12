#! /bin/bash

set -e -x

ls -l

chmod +x configure

./configure --with-oniguruma=$PREFIX --prefix=$PREFIX
# builtin
# build and install
make -j${CPU_COUNT} && make check && make install #

