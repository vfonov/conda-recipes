#!/bin/sh

set -e

mkdir -p build && cd build
# assume correct compilers will be setup by environment
# don't build visual tools though

# use external cache directory (?)
if [ ! -e $RECIPE_DIR/cache ];then
mkdir -p $RECIPE_DIR/cache
fi

# FIX for NETCDF cmake builder unable to locate libm
env
#exit 1
ln -sf ${CONDA_PREFIX}/x86_64-conda_cos6-linux-gnu/sysroot/lib/libm.so.6 ${CONDA_PREFIX}/lib/libm.so

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
      -DMT_BUILD_OPENBLAS:BOOL=ON \
      -DMT_BUILD_SHARED_LIBS:BOOL=ON \
      -DCMAKE_Fortran_FLAGS:STRING="" \
      -DCMAKE_CXX_FLAGS:STRING="" \
      -DCMAKE_C_FLAGS:STRING="" \
      -DMT_USE_OPENMP:BOOL=ON \
      -DMT_PACKAGES_PATH:PATH=${RECIPE_DIR}/cache

make -j${CPU_COUNT} && make install

#create environment activation & deactivation
ACTIVATE_DIR=$PREFIX/etc/conda/activate.d
DEACTIVATE_DIR=$PREFIX/etc/conda/deactivate.d
mkdir -p $ACTIVATE_DIR
mkdir -p $DEACTIVATE_DIR

cp $RECIPE_DIR/scripts/activate.sh $ACTIVATE_DIR/minc-toolkit-v2-activate.sh
cp $RECIPE_DIR/scripts/deactivate.sh $DEACTIVATE_DIR/minc-toolkit-v2-deactivate.sh
