#! /bin/bash

set -e -x
#rm -rf build # remove stale build
#mkdir -p build && cd build
# assume correct compilers will be setup by environment
# don't build visual tools though
# use external cache directory
#export CMAKE_PREFIX_PATH=${CONDA_PREFIX}
# default configuration , trying to use as many prebuilt packages as possible

export CFLAGS="-I$PREFIX/include $CFLAGS"
export CPPFLAGS="-I$PREFIX/include $CPPFLAGS"
export CXXFLAGS="-I$PREFIX/include $CXXFLAGS"


if [[ -z ${MACOSX_DEPLOYMENT_TARGET} ]];then
    # building on linux
    # HACK to make cmake be able to find libm
    ln -sf ${CONDA_PREFIX}/x86_64-conda_cos6-linux-gnu/sysroot/lib/libm.so.6 ${CONDA_PREFIX}/lib/libm.so
    #export CMAKE_LIBRARY_PATH=${CONDA_PREFIX}/lib:${CONDA_PREFIX}/lib64:${CONDA_PREFIX}/x86_64-conda_cos6-linux-gnu/sysroot/lib
    # HACK
else # building on MacOSX
    export CXXFLAGS="-stdlib=libc++ $CXXFLAGS"
    export CC=clang
    export CXX=clang++
    export LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib -headerpad_max_install_names $LDFLAGS"
    export LIBRARY_SEARCH_VAR=DYLD_FALLBACK_LIBRARY_PATH
    #export MACOSX_DEPLOYMENT_TARGET="10.9"
    #export CMAKE_LIBRARY_PATH=${CONDA_PREFIX}/lib:${CONDA_PREFIX}/lib64:
fi


export LD=$CXX

export ZLIB_CFLAGS="-I$BUILD_PREFIX/include"
export EIGEN_CFLAGS="-I$BUILD_PREFIX/include/eigen3"
export TIFF_CFLAGS="-I$BUILD_PREFIX/include"
export FFTW_CFLAGS="-I$BUILD_PREFIX/include"

export ZLIB_LDFLAGS="-L$BUILD_PREFIX/lib -lz"
#export EIGEN_LDFLAGS="-L$BUILD_PREFIX/lib"
export TIFF_LDFLAGS="-L$BUILD_PREFIX/lib -ltiff"
export FFTW_LDFLAGS="-L$BUILD_PREFIX/lib -lfftw3"

./configure

# build and install
#make -j${CPU_COUNT}
./build

# fake install
cp -r bin lib share $PREFIX/

