#! /bin/bash

set -e -x

ls -l

#chmod +x configure

if [[ $(uname) == Darwin ]]; then
echo "Building for macosX"
#export CC=clang
#export CXX=clang++
export LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib -headerpad_max_install_names $LDFLAGS"
export LIBRARY_SEARCH_VAR=DYLD_FALLBACK_LIBRARY_PATH
#export MACOSX_DEPLOYMENT_TARGET="10.9"
export CXXFLAGS="-stdlib=libc++ $CXXFLAGS"

./configure --prefix=$PREFIX   --with-png=$CONDA_PREFIX
else
# linux
./configure --prefix=$PREFIX  --with-png=$CONDA_PREFIX 
fi

# builtin
# build and install
make -j${CPU_COUNT} && make check && make install #
