BASE=/p/lscratchv/berkowit/USQCD/vulcan
INSTALL=/p/lscratchv/berkowit/USQCD/vulcan/install
GPUS=false

# load dotkit
. /usr/local/tools/dotkit/init.sh

HOST=powerpc64-bgq-linux

HDF5=
FFTW=${FFTW_LIBS%/*}
CC=/usr/local/bin/mpiclang
CXX=/usr/local/bin/mpiclang++
BUILD_FLAG=powerpc64-unknown-linux-gnu

QMP_BRANCH=master
QDPXX_BRANCH=master
CHROMA_BRANCH=master
LIBXML2_BRANCH=v2.9.4
FFTW_BRANCH=fftw-3.3.4

CONFIG_QMP=""
CONFIG_QDPXX=""
CONFIG_QPHIX=""
CONFIG_QUDA=""
CONFIG_CHROMA="--enable-sse-scalarsite-bicgstab-kernels --enable-cpp-wilson-dslash --enable-sse2 --enable-sse3"

OMPFLAGS="-fopenmp"
OMPENABLE="--enable-openmp"
CFLAGS=${OMPFLAGS}" -O3 -fPIC -std=c99 -D_GNU_SOURCE -Drestrict=__restrict__"
CXXFLAGS=${OMPFLAGS}" -O3 -fno-strict-aliasing -fPIC -D_GNU_SOURCE -Drestrict=__restrict__"
MAKE_JOBS=10