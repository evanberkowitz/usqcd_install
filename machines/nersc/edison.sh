BASE=/project/projectdirs/callat/software/edison/USQCD

module unload ugni/6.0-1.0502.10245.9.9.ari pmi dmapp/7.0.1-1.0502.10246.8.47.ari gni-headers/4.0-1.0502.10317.9.2.ari xpmem/0.1-2.0502.57015.1.15.ari dvs/2.5_0.9.0-1.0502.1958.2.55.ari alps/5.2.3-2.0502.9295.14.14.ari  rca/1.0.0-2.0502.57212.2.56.ari
module load ugni/6.0-1.0502.10245.9.9.ari pmi dmapp/7.0.1-1.0502.10246.8.47.ari gni-headers/4.0-1.0502.10317.9.2.ari xpmem/0.1-2.0502.57015.1.15.ari dvs/2.5_0.9.0-1.0502.1958.2.55.ari alps/5.2.3-2.0502.9295.14.14.ari  rca/1.0.0-2.0502.57212.2.56.ari

. /opt/modules/default/init/bash
module load modules
module unload PrgEnv-cray
module unload PrgEnv-intel
module unload PrgEnv-pgi
module unload PrgEnv-gnu
module load intel/17.0.1.132
module load PrgEnv-intel/5.2.56
module unload cray-hdf5
module load cray-hdf5-parallel/1.8.16
module load cray-mpich/7.4.1
module load fftw/3.3.4.9

HOST=x86_64-linux-gnu


GET[libxml2]='curl ftp://xmlsoft.org/libxml2/libxml2-2.9.4.tar.gz -o ${SOURCE[$LIBRARY]%/*}/libxml2-2.9.4.tar.gz; pushd ${SOURCE[$LIBRARY]%/*}; tar -xzf libxml2-2.9.4.tar.gz; mv libxml2-2.9.4 ${SOURCE[$LIBRARY]}; popd;'
INSTALL[hdf5]=/opt/cray/hdf5-parallel/1.8.16/INTEL/14.0
INSTALL[fftw]=${FFTW_DIR%/lib}

STACK="qmp libxml2 qdpxx qphix chroma"

CC=/opt/cray/craype/2.5.5/bin/cc
CXX=/opt/cray/craype/2.5.5/bin/CC

C_FLAGS[DEFAULT]="-qopenmp -axCORE-AVX-I -g -O2 -std=c99 "
CXX_FLAGS[DEFAULT]="-qopenmp -axCORE-AVX-I -g -O2 -std=c++11  "
CONFIG_FLAGS[qphix]+=" --disable-cean --enable-clover --enable-proc=AVX --enable-soalen=4 "
CONFIG_FLAGS[chroma]+=" --enable-sse-scalarsite-bicgstab-kernels --enable-sse2 --enable-sse3 --disable-cean --enable-cpp-wislon-dslash --enable-qphix-solver-arch=avx --enable-qphix-solver-soalen=4 --enable-qphix-solver-inner-soalen=8 --enable-qphix-solver-inner-type=float --enable-qphix-solver-compress12 --with-qphix-solver=${INSTALL[qphix]}" #--enable-lapack=lapack 
