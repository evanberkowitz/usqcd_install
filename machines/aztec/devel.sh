BASE=/nfs/tmp2/lattice_qcd/aztec_devel/USQCD

# load dotkit
. /usr/local/tools/dotkit/init.sh

#module purge
module unload hdf5
use hdf5-intel-parallel-mvapich2-1.8.16    > /dev/null
use mvapich2-intel-2.2                     > /dev/null
module load intel/16.0
#module load fftw/3.2

HOST=x86_64-linux-gnu


GET[libxml2]='curl ftp://xmlsoft.org/libxml2/libxml2-2.9.4.tar.gz -o ${SOURCE[$LIBRARY]%/*}/libxml2-2.9.4.tar.gz; pushd ${SOURCE[$LIBRARY]%/*}; tar -xzf libxml2-2.9.4.tar.gz; mv libxml2-2.9.4 ${SOURCE[$LIBRARY]}; popd;'
# USING QDPXX devel (not thorsten's) for testing MILC src writer
GET[qdpxx]='${GIT_CLONE} git@github.com:usqcd-software/qdpxx.git ${SOURCE[$LIBRARY]}; pushd ${SOURCE[$LIBRARY]}; git checkout ${GIT_BRANCH[qdpxx]}; ${GIT_UPDATE_SUBMODULES}; '

INSTALL[hdf5]=$HDF5
INSTALL[fftw]=${FFTW_LIBS%/*}

STACK="qmp libxml2 qdpxx chroma"

CC=mpicc
CXX=mpicxx

C_FLAGS[DEFAULT]="-qopenmp -axCORE-AVX-I -g -O2 -std=c99 -D_GLIBCXX_USE_CXX11_ABI=0 "
CXX_FLAGS[DEFAULT]="-qopenmp -axCORE-AVX-I -g -O2 -std=c++11 -D_GLIBCXX_USE_CXX11_ABI=0 "
#CONFIG_FLAGS[chroma]+=" --enable-sse-scalarsite-bicgstab-kernels --enable-sse2 --enable-sse3"
CONFIG_FLAGS[chroma]+=" --enable-sse-scalarsite-bicgstab-kernels "
#CONFIG_FLAGS[qdpxx]='--prefix=${INSTALL[qdpxx]} --with-qmp=${INSTALL[qmp]} --with-libxml2=${INSTALL[libxml2]} --with-hdf5=${INSTALL[hdf5]} --enable-openmp --enable-precision=single --enable-largefile --enable-parallel-io --enable-db-lite --enable-parallel-arch=parscalar'
