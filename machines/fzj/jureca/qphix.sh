BASE=/homea/jias41/jias4102/usqcd/jureca_qphix

HOST=x86_64-linux-gnu

module purge
module load Intel/2017.2.174-GCC-5.4.0 IntelMPI/2017.2.174 2> /dev/null
module load GMP HDF5/1.8.18 FFTW/3.3.6

INSTALL[hdf5]=$EBROOTHDF5
INSTALL[fftw]=$EBROOTFFTW

GET[libxml2]='curl ftp://xmlsoft.org/libxml2/libxml2-2.9.4.tar.gz -o ${SOURCE[$LIBRARY]%/*}/libxml2-2.9.4.tar.gz; pushd ${SOURCE[$LIBRARY]%/*}; tar -xzf libxml2-2.9.4.tar.gz; mv libxml2-2.9.4 ${SOURCE[$LIBRARY]}; popd;'

STACK="qmp libxml2 qdpxx qphix chroma"

CC=mpiicc
CXX=mpiicpc

C_FLAGS[DEFAULT]="-fopenmp -g -xAVX2 -O2 -std=c99 "
CXX_FLAGS[DEFAULT]="-fopenmp -g -xAVX2 -O2 -std=c++11 "
CONFIG_FLAGS[qphix]+=" --enable-cean --enable-clover --enable-proc=AVX --enable-soalen=8"
CXX_FLAGS[qphix]+=" -restrict "
CONFIG_FLAGS[chroma]+=" 
    --enable-parallel-io
    --enable-parallel-arch=parscalar
    --enable-precision=double
    --enable-qdp-alignment=128
    --enable-sse-scalarsite-bicgstab-kernels 
    --enable-sse2 
    --enable-sse3 
    --enable-qphix-solver-arch=avx 
    --enable-qphix-solver-soalen=2
    --enable-qphix-solver-compress12 
    --with-qphix-solver=${INSTALL[qphix]} 
    --with-gmp=$EBROOTGMP"
