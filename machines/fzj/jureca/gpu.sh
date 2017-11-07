BASE=/homea/jias41/jias4102/USQCD/jureca_gpu

HOST=x86_64-linux-gnu
GPU_ARCH=sm_35  # Kepler GK110 at Keeneland
GPUS=1

module purge
module load GCC/7.2.0 ParaStationMPI/5.2.0-1 CUDA/8.0.61 CMake/3.7.2 2> /dev/null

INSTALL[hdf5]=/usr/local/software/jureca/Stages/2017a/software/HDF5/1.8.19-gpsmpi-2017b
INSTALL[fftw]=/usr/local/software/jureca/Stages/2016b/software/FFTW/3.3.6-gpsmpi-2017b

GET[libxml2]='curl ftp://xmlsoft.org/libxml2/libxml2-2.9.4.tar.gz -o ${SOURCE[$LIBRARY]%/*}/libxml2-2.9.4.tar.gz; pushd ${SOURCE[$LIBRARY]%/*}; tar -xzf libxml2-2.9.4.tar.gz; mv libxml2-2.9.4 ${SOURCE[$LIBRARY]}; popd;'

STACK="qmp libxml2 qdpxx quda chroma"

CC=mpicc
CXX=mpicxx

C_FLAGS[DEFAULT]="-fopenmp -g -O2 -std=c99 -march=core2"
CXX_FLAGS[DEFAULT]="-fopenmp -g -O2 -std=c++11 -march=core2"
CXX_FLAGS[quda]="-fopenmp -g -O2 -march=core2 -Wno-dev"
CONFIG_FLAGS[chroma]+=" --enable-sse-scalarsite-bicgstab-kernels --enable-sse2 --enable-sse3 --with-cuda=$CUDA_PATH --with-quda=${INSTALL[quda]} "
