#! /bin/bash

set -e -x
rm -rf build # remove stale build
mkdir -p build && cd build
export CMAKE_PREFIX_PATH=${CONDA_PREFIX}
# default configuration , trying to use as many prebuilt packages as possible

if [[ -z ${MACOSX_DEPLOYMENT_TARGET} ]];then
    # building on linux
    # HACK to make cmake be able to find libm
    ln -sf ${CONDA_PREFIX}/x86_64-conda_cos6-linux-gnu/sysroot/lib/libm.so.6 ${CONDA_PREFIX}/lib/libm.so
    export CMAKE_LIBRARY_PATH=${CONDA_PREFIX}/lib:${CONDA_PREFIX}/lib64:${CONDA_PREFIX}/x86_64-conda_cos6-linux-gnu/sysroot/lib
else # building on MacOSX
    export CXXFLAGS="-stdlib=libc++ $CXXFLAGS"
    export CC=clang
    export CXX=clang++
    export LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib -headerpad_max_install_names $LDFLAGS"
    export LIBRARY_SEARCH_VAR=DYLD_FALLBACK_LIBRARY_PATH
    #export MACOSX_DEPLOYMENT_TARGET="10.9"
    export CMAKE_LIBRARY_PATH=${CONDA_PREFIX}/lib:${CONDA_PREFIX}/lib64:
fi

cmake .. \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_C_BINDINGS:BOOL=ON \
    -DBUILD_PYTHON_BINDINGS:BOOL=ON \
    -DBUILD_MATLAB_BINDINGS:BOOL=OFF \
    -DBUILD_EXAMPLES:BOOL=OFF \
    -DPYTHON_EXECUTABLE:FILEPATH=${PREFIX}/bin/python

if [[ -z ${MACOSX_DEPLOYMENT_TARGET} ]];then
    cmake ..  -DUSE_OPENMP:BOOL=ON
else
    # OpenMP is not available on MacOSX
    cmake ..  -DUSE_OPENMP:BOOL=OFF
fi

# build and install
make -j${CPU_COUNT} && make install #
