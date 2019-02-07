BASE=$HOME/USQCD/jureca/cpu

HOST=x86_64-linux-gnu

module purge
module load GCC/8.2.0 ParaStationMPI/5.2.1-1 HDF5/1.10.1 FFTW/3.3.8 CMake

DIR[SOURCE]=$HOME/USQCD/jureca/source
INSTALL[hdf5]=/usr/local/software/jureca/Stages/2018b/software/HDF5/1.10.1-gpsmpi-2018b
INSTALL[fftw]=/usr/local/software/jureca/Stages/2018b/software/FFTW/3.3.8-gpsmpi-2018b

GET[libxml2]='curl ftp://xmlsoft.org/libxml2/libxml2-2.9.4.tar.gz -o ${SOURCE[$LIBRARY]%/*}/libxml2-2.9.4.tar.gz; pushd ${SOURCE[$LIBRARY]%/*}; tar -xzf libxml2-2.9.4.tar.gz; mv libxml2-2.9.4 ${SOURCE[$LIBRARY]}; popd;'

STACK="qmp libxml2 qdpxx chroma "

CC=mpicc
CXX=mpicxx

C_FLAGS[DEFAULT]="-fopenmp -g -O2 -std=c99 -march=core2"
CXX_FLAGS[DEFAULT]="-fopenmp -g -O2 -std=c++11 -march=core2"
CONFIG_FLAGS[chroma]+=" --enable-sse-scalarsite-bicgstab-kernels --enable-sse2 --enable-sse3"
