#!/usr/bin/env bash

export CPPFLAGS="-I${PREFIX}/include ${CPPFLAGS}"
export CFLAGS="-I${PREFIX}/include ${CFLAGS}"
export LDFLAGS="-L${PREFIX}/lib ${LDFLAGS}"

chmod +x configure
chmod +x build-aux/mk-opts.pl

./configure --help
./configure --prefix=$PREFIX \
    --disable-docs \
    --enable-readline \
    --enable-shared \
    --without-fltk \
    --enable-dl \
    --without-qrupdate \
    --without-qt \
    --without-qscintilla \
    --without-opengl \
    --without-x \
    --without-freetype \
    --without-fontconfig \
    --disable-openmp \
    --without-sndfile \
    --with-qhull \
    --with-arpack \
    --with-openssl \
    --with-magick \
    --disable-java \
    --with-hdf5-includedir=${PREFIX}/include \
    --with-hdf5-libdir=${PREFIX}/lib \
    --with-fontconfig-includedir=${PREFIX}/include \
    --with-fontconfig-libdir=${PREFIX}/lib \
    --with-blas="-lopenblas" \
    --with-lapack="-lopenblas" 

make -j${CPU_COUNT}
make install

# Copy the [de]activate scripts to $PREFIX/etc/conda/[de]activate.d.
# This will allow them to be run on environment activation.
for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/scripts/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
done
