BASE=/g/g14/berkowit/USQCD/aztec
INSTALL=/p/lscratche/berkowit/USQCD/aztec
GPUS=false

# load dotkit
. /usr/local/tools/dotkit/init.sh

module purge
use hdf5-gnu-parallel-mvapich2-1.8.16
use mvapich2-gnu-2.2
module load gnu/4.9.2
module load fftw/3.2

HOST=x86_64-linux-gnu

HDF5=$HDF5
FFTW=${FFTW_LIBS%/*}
CC=mpicc
CXX=mpicxx

QMP_BRANCH=master
QDPXX_BRANCH=master
CHROMA_BRANCH=master
LIBXML2_BRANCH=v2.9.4

CONFIG_QMP=""
CONFIG_QDPXX=""
CONFIG_QPHIX=""
CONFIG_QUDA=""
CONFIG_CHROMA="--enable-sse-scalarsite-bicgstab-kernels --enable-cpp-wilson-dslash --enable-sse2 --enable-sse3"

OMPFLAGS="-fopenmp"
OMPENABLE="--enable-openmp"
CFLAGS=${OMPFLAGS}" -g -O2 -std=c99 -march=core2"
CXXFLAGS=${OMPFLAGS}" -g -O2 -std=c++11 -march=core2"
MAKE_JOBS=10