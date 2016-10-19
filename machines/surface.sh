BASE=/nfs/tmp2/lattice_qcd/surface/USQCD
GPUS=1

# load dotkit
. /usr/local/tools/dotkit/init.sh

module purge
use hdf5-gnu-parallel-mvapich2-1.8.16 > /dev/null
use mvapich2-gnu-2.2                  > /dev/null
module load cudatoolkit/7.5
module load gnu/4.9.2
module load fftw/3.2

HOST=x86_64-linux-gnu
GPU_ARCH=sm_35  # Kepler GK110 at Keeneland

INSTALL[hdf5]=$HDF5
INSTALL[fftw]=${FFTW_LIBS%/*}

STACK="qmp libxml2 qdpxx quda chroma"

export PK_CUDA_HOME=${CUDA_INSTALL_PATH}

CC=mpicc
CXX=mpicxx

C_FLAGS[DEFAULT]="-fopenmp -g -O2 -std=c99 -march=core2"
CXX_FLAGS[DEFAULT]="-fopenmp -g -O2 -std=c++11 -march=core2"
CONFIG_FLAGS[chroma]+=' --enable-sse-scalarsite-bicgstab-kernels --enable-sse2 --enable-sse3 --with-cuda=$CUDA_INSTALL_PATH --with-quda=${INSTALL[quda]} '
