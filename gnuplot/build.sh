#!/bin/bash

export CXXFLAGS="$CXXFLAGS -std=c++11"

if [ "$(uname)" == "Linux" ]
then
	export LDFLAGS="$LDFLAGS -L $PREFIX/lib "
fi


./configure \
	--prefix=$PREFIX \
	--without-lua \
	--without-latex \
	--without-libcerf \
	--without-qt \
	--without-readline \
	--without-x11 \
	--without-cairo \
	--without-tutorial

export GNUTERM=dumb
make PREFIX=$PREFIX
make check PREFIX=$PREFIX
make install PREFIX=$PREFIX
