#! /bin/bash

set -e -x

mkdir -p build && cd build
# assume correct compilers will be setup by environment
# don't build visual tools though
# use external cache directory

export CMAKE_PREFIX_PATH=${CONDA_PREFIX}

# default configuration , trying to use as many prebuilt packages as possible

if [[ -z ${MACOSX_DEPLOYMENT_TARGET} ]];then
    # building on linux

    # HACK to make cmake be able to find libm
    ln -sf ${CONDA_PREFIX}/x86_64-conda_cos6-linux-gnu/sysroot/lib/libm.so.6 ${CONDA_PREFIX}/lib/libm.so

    export CMAKE_LIBRARY_PATH=${CONDA_PREFIX}/lib:${CONDA_PREFIX}/lib64:${CONDA_PREFIX}/x86_64-conda_cos6-linux-gnu/sysroot/lib

else # building on MacOSX
    export CMAKE_LIBRARY_PATH=${CONDA_PREFIX}/lib:${CONDA_PREFIX}/lib64:
fi

cmake .. \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DLIBMINC_MINC1_SUPPORT:BOOL=ON \
    -DLIBMINC_BUILD_SHARED_LIBS:BOOL=ON \
    -DBUILD_TESTING:BOOL=ON \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DNETCDF_INCLUDE_DIR:PATH=${CONDA_PREFIX}/include \
    -DNETCDF_LIBRARY:FILEPATH=${CONDA_PREFIX}/lib/libnetcdf${SHLIB_EXT} \
    -DHDF5_C_COMPILER_EXECUTABLE:FILEPATH=${CONDA_PREFIX}/bin/h5cc \
    -DHDF5_INCLUDE_DIR:PATH=${CONDA_PREFIX}/include \
    -DHDF5_LIBRARY:FILEPATH=${CONDA_PREFIX}/lib/libhdf5${SHLIB_EXT} \
    -DHDF5_C_LIBRARY_z:FILEPATH=${CONDA_PREFIX}/lib/libz${SHLIB_EXT} \
    -DZLIB_INCLUDE_DIR:PATH=${CONDA_PREFIX}/include \
    -DZLIB_LIBRARY_RELEASE:FILEPATH=${CONDA_PREFIX}/lib/libz${SHLIB_EXT} \
    -DUSE_SYSTEM_ZLIB:BOOL=ON \
    -DUSE_SYSTEM_NIFTI:BOOL=ON \
    -DNIFTI_INCLUDE_DIR:PATH=NIFTI_INCLUDE_DIR-NOTFOUND \
    -DNIFTI_LIBRARY:FILEPATH=NIFTI_LIBRARY-NOTFOUND \
    -DUSE_SYSTEM_HDF5:BOOL=ON \
    -DUSE_SYSTEM_NETCDF:BOOL=ON \
    -DLIBMINC_USE_SYSTEM_NIFTI:BOOL=ON \



# build and install
make -j${CPU_COUNT} && make install #
