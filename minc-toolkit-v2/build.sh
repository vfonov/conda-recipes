#!/bin/sh
mkdir build && cd build
# assume correct compilers will be setup by environment
# don't build visual tools though

cmake .. -DCMAKE_INSTALL_PREFIX=${PREFIX} -DCMAKE_BUILD_TYPE=Release \
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
      -DCMAKE_C_FLAGS:STRING=""

make install
