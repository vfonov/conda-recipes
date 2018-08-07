#!/bin/sh

set -e

mkdir -p build && cd build
# assume correct compilers will be setup by environment
# don't build visual tools though

# use external cache directory (?)
if [[ ! -e $RECIPE_DIR/cache ]];then
mkdir -p $RECIPE_DIR/cache
fi


if [ -z ${MACOSX_DEPLOYMENT_TARGET} ];then # building on linux
ln -sf ${CONDA_PREFIX}/x86_64-conda_cos6-linux-gnu/sysroot/lib/libm.so.6 ${CONDA_PREFIX}/lib/libm.so

export CMAKE_PREFIX_PATH=${CONDA_PREFIX}
export CMAKE_LIBRARY_PATH=${CONDA_PREFIX}/lib:${CONDA_PREFIX}/lib64:${CONDA_PREFIX}/x86_64-conda_cos6-linux-gnu/sysroot/lib

cmake .. \
      -DCMAKE_INSTALL_PREFIX=${PREFIX} \
      -DCMAKE_BUILD_TYPE=Release \
      -DMT_BUILD_ITK_TOOLS:BOOL=OFF \
      -DMT_BUILD_SHARED_LIBS:BOOL=ON \
      -DMT_BUILD_VISUAL_TOOLS:BOOL=OFF \
      -DUSE_SYSTEM_OPENJPEG:BOOL=ON \
      -DUSE_SYSTEM_FFTW3D:BOOL=ON \
      -DUSE_SYSTEM_FFTW3F:BOOL=ON \
      -DUSE_SYSTEM_GLUT:BOOL=ON \
      -DUSE_SYSTEM_GSL:BOOL=ON \
      -DUSE_SYSTEM_HDF5:BOOL=ON \
      -DUSE_SYSTEM_ITK:BOOL=OFF \
      -DUSE_SYSTEM_JPEG:BOOL=ON \
      -DUSE_SYSTEM_NETCDF:BOOL=ON \
      -DUSE_SYSTEM_OPENJPEG:BOOL=ON \
      -DUSE_SYSTEM_PCRE:BOOL=ON \
      -DUSE_SYSTEM_ZLIB:BOOL=ON \
      -DMT_BUILD_ANTS:BOOL=ON \
      -DMT_BUILD_C3D:BOOL=ON \
      -DMT_BUILD_ELASTIX:BOOL=ON \
      -DMT_BUILD_OPENBLAS:BOOL=OFF \
      -DMT_BUILD_SHARED_LIBS:BOOL=ON \
      -DCMAKE_Fortran_FLAGS:STRING="" \
      -DCMAKE_CXX_FLAGS:STRING="" \
      -DCMAKE_C_FLAGS:STRING="" \
      -DMT_USE_OPENMP:BOOL=ON \
      -DOpenBLAS_DIR:PATH=${CONDA_PREFIX}/lib/cmake/openblas \
      -DMT_PACKAGES_PATH:PATH=${RECIPE_DIR}/cache \
      -DBISON_EXECUTABLE:FILEPATH=${CONDA_PREFIX}/bin/bison \
      -DFFTW3F_INCLUDE_DIR:PATH=${CONDA_PREFIX}/include \
      -DFFTW3F_LIBRARY:FILEPATH=${CONDA_PREFIX}/lib/libfftw3f.so \
      -DFFTW3F_OMP_LIBRARY:FILEPATH=${CONDA_PREFIX}/lib/libfftw3f_omp.so \
      -DFFTW3F_THREADS_LIBRARY:FILEPATH=${CONDA_PREFIX}/lib/libfftw3f_threads.so \
      -DFFTW3_INCLUDE_DIR:PATH=${CONDA_PREFIX}/include \
      -DFFTW3_LIBRARY:FILEPATH=${CONDA_PREFIX}/lib/libfftw3.so \
      -DFFTW3_OMP_LIBRARY:FILEPATH=${CONDA_PREFIX}/lib/libfftw3_omp.so \
      -DFFTW3_THREADS_LIBRARY:FILEPATH=${CONDA_PREFIX}/lib/libfftw3_threads.so \
      -DFLEX_EXECUTABLE:FILEPATH=${CONDA_PREFIX}/bin/flex \
      -DFLEX_INCLUDE_DIR:PATH=${CONDA_PREFIX}/include \
      -DFL_LIBRARY:FILEPATH=${CONDA_PREFIX}/lib/libfl.so \
      -DGSL_CBLAS_LIBRARY:FILEPATH=${CONDA_PREFIX}/lib/libgslcblas.so \
      -DGSL_INCLUDE_DIR:PATH=${CONDA_PREFIX}/include \
      -DGSL_LIBRARY:FILEPATH=${CONDA_PREFIX}/lib/libgsl.so \
      -DHDF5_INCLUDE_DIR:PATH=${CONDA_PREFIX}/include \
      -DHDF5_LIBRARY:FILEPATH=${CONDA_PREFIX}/lib/libhdf5.so \
      -DJPEG_INCLUDE_DIR:PATH=${CONDA_PREFIX}/include \
      -DJPEG_LIBRARY:FILEPATH=${CONDA_PREFIX}/lib/libjpeg.so \
      -DNETCDF_INCLUDE_DIR:PATH=${CONDA_PREFIX}/include \
      -DNETCDF_LIBRARY:FILEPATH=${CONDA_PREFIX}/lib/libnetcdf.so \
      -DOPENGL_EGL_INCLUDE_DIR:PATH=${CONDA_PREFIX}/include \
      -DOPENGL_GLX_INCLUDE_DIR:PATH=${CONDA_PREFIX}/include \
      -DOPENGL_INCLUDE_DIR:PATH=${CONDA_PREFIX}/include \
      -DOPENGL_glu_LIBRARY:FILEPATH=${CONDA_PREFIX}/lib/libGLU.so \
      -DOPENJPEG_INCLUDE_DIR:PATH=${CONDA_PREFIX}/include/openjpeg-2.3 \
      -DOPENJPEG_LIBRARY:FILEPATH=${CONDA_PREFIX}/lib/libopenjp2.so \
      -DPCRECPP_LIBRARY:FILEPATH=${CONDA_PREFIX}/lib/libpcrecpp.so \
      -DPCRE_INCLUDE_DIR:PATH=${CONDA_PREFIX}/include \
      -DPCRE_LIBRARY:FILEPATH=${CONDA_PREFIX}/lib/libpcre.so \
      -DPERL_EXECUTABLE:FILEPATH=${CONDA_PREFIX}/bin/perl \
      -DZLIB_INCLUDE_DIR:PATH=${CONDA_PREFIX}/include \
      -DZLIB_LIBRARY_RELEASE:FILEPATH=${CONDA_PREFIX}/lib/libz.so

else # building on MacOSX
  echo "Not Ready yet!"

  export CMAKE_PREFIX_PATH=${CONDA_PREFIX}
  export CMAKE_LIBRARY_PATH=${CONDA_PREFIX}/lib:${CONDA_PREFIX}/lib64:${CONDA_PREFIX}/x86_64-conda_cos6-linux-gnu/sysroot/lib

  cmake .. \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DCMAKE_BUILD_TYPE=Release \
        -DMT_BUILD_ITK_TOOLS:BOOL=ON \
        -DMT_BUILD_SHARED_LIBS:BOOL=ON \
        -DMT_BUILD_VISUAL_TOOLS:BOOL=OFF \
        -DUSE_SYSTEM_OPENJPEG:BOOL=OFF \
        -DMT_BUILD_ANTS:BOOL=ON \
        -DMT_BUILD_C3D:BOOL=ON \
        -DMT_BUILD_ELASTIX:BOOL=ON \
        -DMT_BUILD_OPENBLAS:BOOL=OFF \
        -DMT_BUILD_SHARED_LIBS:BOOL=ON \
        -DCMAKE_Fortran_FLAGS:STRING="" \
        -DCMAKE_CXX_FLAGS:STRING="" \
        -DCMAKE_C_FLAGS:STRING="" \
        -DMT_USE_OPENMP:BOOL=OFF \
        -DMT_PACKAGES_PATH:PATH=${RECIPE_DIR}/cache \
        -DOpenBLAS_DIR:PATH=${CONDA_PREFIX}/lib/cmake/openblas 
fi

make -j${CPU_COUNT} && make install

#create environment activation & deactivation
ACTIVATE_DIR=$PREFIX/etc/conda/activate.d
DEACTIVATE_DIR=$PREFIX/etc/conda/deactivate.d
mkdir -p $ACTIVATE_DIR
mkdir -p $DEACTIVATE_DIR

cp $RECIPE_DIR/scripts/activate.sh $ACTIVATE_DIR/minc-toolkit-v2-activate.sh
cp $RECIPE_DIR/scripts/deactivate.sh $DEACTIVATE_DIR/minc-toolkit-v2-deactivate.sh
