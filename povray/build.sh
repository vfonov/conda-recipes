#! /bin/bash

set -e -x

ls -l

#chmod +x configure
cd unix;./prebuild.sh;cd ..

if [[ $(uname) == Darwin ]]; then
echo "Building for macosX"
#export CC=clang
#export CXX=clang++
export LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib -headerpad_max_install_names $LDFLAGS"
export LIBRARY_SEARCH_VAR=DYLD_FALLBACK_LIBRARY_PATH
#export MACOSX_DEPLOYMENT_TARGET="10.9"
export CXXFLAGS="-stdlib=libc++ $CXXFLAGS"

./configure --prefix=$PREFIX \
  --without-x \
  --with-zlib=${CONDA_PREFIX} \
  --with-libpng=${CONDA_PREFIX} \
  --with-libjpeg=${CONDA_PREFIX} \
  --with-libtiff=${CONDA_PREFIX} \
  --with-boost=${CONDA_PREFIX} \
  --with-boost-libdir=${CONDA_PREFIX}/lib \
  --disable-optimiz-arch \
 COMPILED_BY="Vladimir S. FONOV <vladimir.fonov@gmail.com>"
else
#  export LDFLAGS="-L$PREFIX/lib $LDFLAGS"
# linux
./configure --prefix=$PREFIX \
  --without-x \
  --with-zlib=${CONDA_PREFIX} \
  --with-libpng=${CONDA_PREFIX} \
  --with-libjpeg=${CONDA_PREFIX} \
  --with-libtiff=${CONDA_PREFIX} \
  --with-boost=${CONDA_PREFIX} \
  --with-boost-libdir=${CONDA_PREFIX}/lib \
  --disable-optimiz-arch \
 COMPILED_BY="Vladimir S. FONOV <vladimir.fonov@gmail.com>"

fi

# builtin
# build and install
make -j${CPU_COUNT} && make check && make install #
