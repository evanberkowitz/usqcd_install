BASE=/project/projectdirs/callat/software/evan/USQCD

module unload ugni/6.0.12-2.1 pmi/5.0.10-1.0000.11050.0.0.ari dmapp/7.1.0-12.37 gni-headers/5.0.7-3.1  xpmem/0.1-4.5 dvs/2.7_0.9.0-2.243 alps/6.1.3-17.12 rca/1.0.0-8.1
module load pmi/5.0.10-1.0000.11050.0.0.ari 

#module purge
. /opt/modules/default/init/bash
module load modules
module unload PrgEnv-cray
module unload PrgEnv-intel
module unload PrgEnv-pgi
module unload PrgEnv-gnu
module unload libxml2
module load intel/17.0.1.132
module load PrgEnv-intel/6.0.3
module unload cray-hdf5
module load cray-hdf5-parallel/1.8.16
module unload cray-mpich
module load libxml2/2.9.4
module load cray-mpich/7.5.2
module load fftw/3.3.4.11

module unload python
module load python/3.6-anaconda-4.4
PYTHON_ROOT=/usr/common/software/python/3.6-anaconda-4.4

HOST=x86_64-linux-gnu


GET[libxml2]='curl ftp://xmlsoft.org/libxml2/libxml2-2.9.4.tar.gz -o ${SOURCE[$LIBRARY]%/*}/libxml2-2.9.4.tar.gz; pushd ${SOURCE[$LIBRARY]%/*}; tar -xzf libxml2-2.9.4.tar.gz; mv libxml2-2.9.4 ${SOURCE[$LIBRARY]}; popd;'
INSTALL[hdf5]=/opt/cray/hdf5-parallel/1.8.16/INTEL/14.0
INSTALL[fftw]=${FFTW_DIR%/lib}

INSTALL[libxml2]=$LIBXML2_ROOT

STACK="qmp qdpxx qphix chroma"

CC=/opt/cray/pe/craype/2.5.7/bin/cc
CXX=/opt/cray/pe/craype/2.5.7/bin/CC

LIBS[DEFAULT]="-L/global/common/cori/software/liblzma/20160630/hsw/lib"
C_FLAGS[DEFAULT]="-qopenmp -axCORE-AVX-I -g -O2 -std=c99 -D_GLIBCXX_USE_CXX11_ABI=0 "
CXX_FLAGS[DEFAULT]="-qopenmp -axCORE-AVX-I -g -O2 -std=c++11 -D_GLIBCXX_USE_CXX11_ABI=0 "

CONFIGURE[qphix]='cmake ${SOURCE[qphix]} '
CONFIG_FLAGS[qphix]=" -Disa=avx2 -Dhost_cxx='g++' -Dhost_cxxflags='-g -O3 -std=c++11' -Drecursive_jN=$(nproc) -DCMAKE_INSTALL_PREFIX=\"${INSTALL[qphix]}\" -DQDPXX_DIR=\"${INSTALL[qdpxx]}\" -Dclover=TRUE -Dtwisted_mass=TRUE -Dtm_clover=TRUE -Dcean=FALSE -Dmm_malloc=TRUE -Dtesting=TRUE -DPYTHON_LIBRARY=${PYTHON_ROOT}/lib/libpython3.6m.so -DPYTHON_INCLUDE_DIR=${PYTHON_ROOT}/include/python3.6m"
CXX_FLAGS[qphix]+=" -restrict "

CONFIG_FLAGS[chroma]+=" --enable-sse-scalarsite-bicgstab-kernels --enable-sse2 --enable-sse3 --disable-cean --enable-cpp-wislon-dslash --enable-qphix-solver-arch=avx --enable-qphix-solver-soalen=4 --enable-qphix-solver-inner-type=float --enable-qphix-solver-compress12 --with-qphix-solver=${INSTALL[qphix]}" #--enable-lapack=lapack 
