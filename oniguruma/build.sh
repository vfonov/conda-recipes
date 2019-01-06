#! /bin/bash

set -e -x

ls -l

chmod +x configure

./configure --disable-maintainer-mode --prefix=$PREFIX

# build and install
make -j${CPU_COUNT} && make check && make install #

