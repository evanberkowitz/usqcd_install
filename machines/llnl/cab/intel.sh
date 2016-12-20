BASE=/nfs/tmp2/lattice_qcd/cab/intel/USQCD

# load dotkit
. /usr/local/tools/dotkit/init.sh

module purge
module unload hdf5
use hdf5-intel-parallel-mvapich2-1.8.16    > /dev/null
use mvapich2-intel-2.2                     > /dev/null
module load intel/16.0
# No FFTW is needed, as it is provided in MKL.

HOST=x86_64-linux-gnu

INSTALL[hdf5]=$HDF5

STACK="qmp libxml2 qdpxx chroma qdpxx_single chroma_single"

CC=mpicc
CXX=mpicxx

C_FLAGS[DEFAULT]="-qopenmp -axCORE-AVX-I -g -O2 -std=c99 -D_GLIBCXX_USE_CXX11_ABI=0 "
CXX_FLAGS[DEFAULT]="-qopenmp -axCORE-AVX-I -g -O2 -std=c++11 -D_GLIBCXX_USE_CXX11_ABI=0 "
#CONFIG_FLAGS[chroma]+=" --enable-sse-scalarsite-bicgstab-kernels --enable-sse2 --enable-sse3"
CONFIG_FLAGS[chroma]+=" --enable-sse-scalarsite-bicgstab-kernels "
