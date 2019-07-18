#!/bin/bash

set -ex

./configure --prefix="$PREFIX"

if [[ $(uname) == Linux ]]; then
    # Remove test broken in sed 4.4
    sed -i.bak -e 's|testsuite/panic-tests.sh||' Makefile
fi

make $VERBOSE_AT

# These tests fail under emulation, still run them but ignore their result
if [[ ${target_platform} == linux-aarch64 ]]; then
    make check -j${NUM_CPUS} || true
elif [[ ${target_platform} == linux-ppc64le ]]; then
    make check -j${NUM_CPUS} || true
else
    make check -j${NUM_CPUS}
fi
cat ./test-suite.log

make install
