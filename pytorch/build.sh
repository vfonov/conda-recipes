#! /bin/bash

set -ex

export CMAKE_LIBRARY_PATH=$PREFIX/lib:$PREFIX/include:$CMAKE_LIBRARY_PATH
export CMAKE_PREFIX_PATH=$PREFIX
export PYTORCH_BUILD_VERSION=$PKG_VERSION
export PYTORCH_BUILD_NUMBER=$PKG_BUILDNUM

if [ ${cudatoolkit} == "8.0" ]; then
    # compile for Kepler, Kepler+Tesla, Maxwell, Pascal
    export TORCH_CUDA_ARCH_LIST="3.0;3.5;5.0;5.2+PTX;6.0;6.1"
fi
if [ ${cudatoolkit} == "9.0" ]; then
    # compile for Kepler, Kepler+Tesla, Maxwell, Pascal, Volta
    export TORCH_CUDA_ARCH_LIST="3.0;3.5;5.0;5.2+PTX;6.0;6.1;7.0"
fi
export TORCH_NVCC_FLAGS="-Xfatbin -compress-all"

# Disabling CUDA and DISTRIBUTED

# use conda provided nccl
#export NCCL_ROOT_DIR="${PREFIX}"
#export NCCL_LIB_DIR="${PREFIX}/lib"
#export NCCL_INCLUDE_DIR="${PREFIX}/include"
export TH_BINARY_BUILD=1
export USE_SYSTEM_NCCL=0
export USE_CUDA=OFF
export USE_MKL=OFF
export USE_OPENMP=ON
export NO_MKLDNN=ON # because otherwise it tries to use AVX

export NO_CUDA=1
#export NO_DISTRIBUTED=OFF

#export CUDA_HOME=${PREFIX}
#export CUDA_TOOLKIT_ROOT_DIR=${PREFIX}

#export MAGMA_HOME="${PREFIX}"
export PYTORCH_BINARY_BUILD=1
export LIBRT=$(find ${BUILD_PREFIX} -name "librt.so")


python setup.py install

