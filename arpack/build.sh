#!/bin/sh


if [[ $target_platform == osx-64 ]];then
    # building on MacOSX
    #export CC=${c_compiler}
    #export CXX=${cxx_compiler}
    #export FC=${fortran_compiler}
    export LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib -headerpad_max_install_names $LDFLAGS"
    export LIBRARY_SEARCH_VAR=DYLD_FALLBACK_LIBRARY_PATH
    export CMAKE_LIBRARY_PATH=${CONDA_PREFIX}/lib:${CONDA_PREFIX}/lib64:
else 
    # building on linux
    export CMAKE_LIBRARY_PATH=${CONDA_PREFIX}/lib:${CONDA_PREFIX}/lib64:${CONDA_PREFIX}/x86_64-conda_cos6-linux-gnu/sysroot/lib
fi
unset CC CXX FC
mkdir build && cd build

for shared_libs in OFF ON
do
  cmake \
    -DCMAKE_PREFIX_PATH=${PREFIX} \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DBUILD_SHARED_LIBS=${shared_libs} \
    -DLAPACK_LIBRARIES="-lopenblas" \
    -DBLAS_LIBRARIES="-lopenblas" \
    ..

  make install -j${CPU_COUNT}
done
ctest --output-on-failure -j${CPU_COUNT}
