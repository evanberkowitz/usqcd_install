BASE=/ccs/proj/lgt100/software/USQCD/titan
GPUS=1

 . /opt/modules/3.2.10.3/init/bash

module purge
module load modules/3.2.10.3
module load PrgEnv-gnu/5.2.82
module load cudatoolkit/7.5.18-1.0502.10743.2.1
module load fftw/3.3.4.5
module load cray-hdf5-parallel/1.8.16
module load cmake3/3.2.3


HOST=x86_64-linux-gnu
GPU_ARCH=sm_35  # Kepler GK110 at Keeneland

INSTALL[hdf5]=$HDF5_DIR
INSTALL[fftw]=${FFTW_DIR%/*}

STACK="qmp libxml2 qdpxx quda chroma"

MPI=/ccs/proj/lgt100/software/install/openmpi-2.0.0
CC=$MPI/bin/mpicc
CXX=$MPI/bin/mpicxx
CUDA_INSTALL_PATH=$CUDATOOLKIT_HOME

C_FLAGS[DEFAULT]="-fopenmp -g -O2 -std=c99" # -march=core2"
CXX_FLAGS[DEFAULT]="-fopenmp -g -O2 -std=c++11" # -march=core2"

CONFIG_FLAGS[chroma]+=' --enable-sse-scalarsite-bicgstab-kernels --enable-sse2 --enable-sse3 --with-cuda=$CUDA_INSTALL_PATH --with-quda=${INSTALL[quda]} '
LD_FLAGS[chroma]+=' -L${CUDATOOLKIT_HOME}/lib64/stubs '
