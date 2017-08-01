BASE=$HOME/USQCD/jureca

HOST=x86_64-linux-gnu

module load GCC/5.4.0 ParaStationMPI/5.1.9-1 HDF5/1.8.18 FFTW/3.3.6
INSTALL[hdf5]=/usr/local/software/jureca/Stages/2017a/software/HDF5/1.8.18-gpsmpi-2017a
INSTALL[fftw]=/usr/local/software/jureca/Stages/2016b/software/FFTW/3.3.6-gpsmpi-2017b/

GET[libxml2]='curl ftp://xmlsoft.org/libxml2/libxml2-2.9.4.tar.gz -o ${SOURCE[$LIBRARY]%/*}/libxml2-2.9.4.tar.gz; pushd ${SOURCE[$LIBRARY]%/*}; tar -xzf libxml2-2.9.4.tar.gz; mv libxml2-2.9.4 ${SOURCE[$LIBRARY]}; popd;'

STACK="qmp libxml2 qdpxx chroma "

CC=mpicc
CXX=mpicxx

C_FLAGS[DEFAULT]="-fopenmp -g -O2 -std=c99 -march=core2"
CXX_FLAGS[DEFAULT]="-fopenmp -g -O2 -std=c++11 -march=core2"
CONFIG_FLAGS[chroma]+=" --enable-sse-scalarsite-bicgstab-kernels --enable-sse2 --enable-sse3"
