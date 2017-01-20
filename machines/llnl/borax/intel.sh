BASE=/nfs/tmp2/lattice_qcd/borax/intel/USQCD

#module purge
module load intel/16.0.3
module load hdf5-parallel/1.8.17
module load mvapich2/2.2

#module load fftw/3.2

HOST=x86_64-linux-gnu


GET[libxml2]='curl ftp://xmlsoft.org/libxml2/libxml2-2.9.4.tar.gz -o ${SOURCE[$LIBRARY]%/*}/libxml2-2.9.4.tar.gz; pushd ${SOURCE[$LIBRARY]%/*}; tar -xzf libxml2-2.9.4.tar.gz; mv libxml2-2.9.4 ${SOURCE[$LIBRARY]}; popd;'
INSTALL[hdf5]=/usr/tce/packages/hdf5/hdf5-parallel-1.8.17-intel-16.0.3-mvapich2-2.2
INSTALL[fftw]=${FFTW_LIBS%/*}

STACK="qmp libxml2 qdpxx chroma"

CC=mpicc
CXX=mpicxx

C_FLAGS[DEFAULT]="-qopenmp -axCORE-AVX-I -g -O2 -std=c99 -D_GLIBCXX_USE_CXX11_ABI=0 "
CXX_FLAGS[DEFAULT]="-qopenmp -axCORE-AVX-I -g -O2 -std=c++11 -D_GLIBCXX_USE_CXX11_ABI=0 "
#CONFIG_FLAGS[chroma]+=" --enable-sse-scalarsite-bicgstab-kernels --enable-sse2 --enable-sse3"
CONFIG_FLAGS[chroma]+=" --enable-sse-scalarsite-bicgstab-kernels "
