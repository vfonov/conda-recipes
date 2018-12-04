#! /bin/bash

set -e -x

ls -l

#chmod +x configure
cd unix;./prebuild.sh;cd ..

./configure --prefix=$PREFIX --without-x \
  --with-zlib=${CONDA_PREFIX} \
  --with-libpng=${CONDA_PREFIX} \
  --with-libjpeg=${CONDA_PREFIX} \
  --with-libtiff=${CONDA_PREFIX} \
  --with-boost=${CONDA_PREFIX} \
  --with-boost-libdir=${CONDA_PREFIX}/lib \
 COMPILED_BY="Vladimir S. FONOV <vladimir.fonov@gmail.com>"

# builtin
# build and install
make -j${CPU_COUNT} && make check && make install #
