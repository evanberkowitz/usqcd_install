BASE=$PROJECT/USQCD/jureca/gpu
GPUS=1
HOST=x86_64-linux-gnu

module purge
module load GCC/7.3.0 MVAPICH2/2.3-GDR HDF5/1.8.20 FFTW/3.3.8 CUDA/9.2.88 CMake/3.13.0

DIR[SOURCE]=$HOME/USQCD/jureca/source
INSTALL[hdf5]=/usr/local/software/jureca/Stages/2018b/software/HDF5/1.8.20-gpsmpi-2018b
INSTALL[fftw]=/usr/local/software/jureca/Stages/2018b/software/FFTW/3.3.8-gpsmpi-2018b

export HOST=x86_64-linux-gnu
export GPU_ARCH=sm_30

GET[libxml2]='curl ftp://xmlsoft.org/libxml2/libxml2-2.9.4.tar.gz -o ${SOURCE[$LIBRARY]%/*}/libxml2-2.9.4.tar.gz; pushd ${SOURCE[$LIBRARY]%/*}; tar -xzf libxml2-2.9.4.tar.gz; mv libxml2-2.9.4 ${SOURCE[$LIBRARY]}; popd;'

STACK="qmp libxml2 qdpxx quda chroma "

CC=mpicc
CXX=mpicxx

C_FLAGS[DEFAULT]="-fopenmp -g -O2 -std=c99 -march=core2"
CXX_FLAGS[DEFAULT]="-fopenmp -g -O2 -std=c++11 -march=core2"
CXX_FLAGS[quda]="-fopenmp -g -O2 -march=core2 -Wno-dev"

CONFIG_FLAGS[quda]='-DQUDA_GPU_ARCH=${GPU_ARCH} -DQUDA_MPI=ON -DQUDA_QMP=ON -DQUDA_QMPHOME=${INSTALL[qmp]} -DMPI_C_COMPILER=${CC} -DMPI_CXX_COMPILER=${CXX} -DQUDA_DIRAC_WILSON=ON '
CONFIG_FLAGS[chroma]+=" --enable-sse-scalarsite-bicgstab-kernels --enable-sse2 --enable-sse3"
