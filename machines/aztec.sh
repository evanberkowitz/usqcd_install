BASE=/nfs/tmp2/lattice_qcd/aztec/USQCD
GPUS=false

# load dotkit
. /usr/local/tools/dotkit/init.sh

module purge
use hdf5-gnu-parallel-mvapich2-1.8.16    > /dev/null
use mvapich2-gnu-2.2                     > /dev/null
module load gnu/4.9.2
module load fftw/3.2

HOST=x86_64-linux-gnu


GET[libxml2]='curl ftp://xmlsoft.org/libxml2/libxml2-2.9.4.tar.gz -o ${SOURCE[$LIBRARY]%/*}/libxml2-2.9.4.tar.gz; pushd ${SOURCE[$LIBRARY]%/*}; tar -xzf libxml2-2.9.4.tar.gz; mv libxml2-2.9.4 ${SOURCE[$LIBRARY]}; popd;'
INSTALL[hdf5]=$HDF5
INSTALL[fftw]=${FFTW_LIBS%/*}

STACK="qmp libxml2 qdpxx chroma"

CC=mpicc
CXX=mpicxx

C_FLAGS[DEFAULT]="-fopenmp -g -O2 -std=c99 -march=core2"
CXX_FLAGS[DEFAULT]="-fopenmp -g -O2 -std=c++11 -march=core2"
CONFIG_FLAGS[chroma]+=" --enable-sse-scalarsite-bicgstab-kernels --enable-sse2 --enable-sse3"
