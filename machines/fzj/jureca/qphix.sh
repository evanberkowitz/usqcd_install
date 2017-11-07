BASE=/homea/jias41/jias4102/USQCD/jureca_qphix

HOST=x86_64-linux-gnu

module purge
module load Intel/2017.2.174-GCC-5.4.0 IntelMPI/2017.2.174 2> /dev/null
module load CMake/3.9.4 Python/3.6.3    #for QPhiX
module load GMP HDF5/1.8.19 FFTW/3.3.6

INSTALL[hdf5]=$EBROOTHDF5
INSTALL[fftw]=$EBROOTFFTW

# One-time only:
if [[ ! -d ${HOME}/.python3.6/lib/python3.6/site-packages/jinja2 ]]; then
    mkdir ${HOME}/.python3.6
    pip3.6 install --install-option="--prefix=${HOME}/.python3.6" jinja2
    # jinja is needed for qphix cmake.
fi
export PYTHONPATH=$PYTHONPATH:${HOME}/.python3.6/lib/python3.6/site-packages

GET[libxml2]='curl ftp://xmlsoft.org/libxml2/libxml2-2.9.4.tar.gz -o ${SOURCE[$LIBRARY]%/*}/libxml2-2.9.4.tar.gz; pushd ${SOURCE[$LIBRARY]%/*}; tar -xzf libxml2-2.9.4.tar.gz; mv libxml2-2.9.4 ${SOURCE[$LIBRARY]}; popd;'

STACK="qmp libxml2 qdpxx qphix chroma"

CC=mpiicc
CXX=mpiicpc

C_FLAGS[DEFAULT]="-fopenmp -g -xAVX2 -O2 -std=c99 "
CXX_FLAGS[DEFAULT]="-fopenmp -g -xAVX2 -O2 -std=c++11 "

CONFIGURE[qphix]='cmake ${SOURCE[qphix]} '
CONFIG_FLAGS[qphix]=" -Disa=avx2 -Dhost_cxx='g++' -Dhost_cxxflags='-g -O3 -std=c++11' -Drecursive_jN=$(nproc) -DCMAKE_INSTALL_PREFIX=\"${INSTALL[qphix]}\" -DQDPXX_DIR=\"${INSTALL[qdpxx]}\" -Dclover=TRUE -Dtwisted_mass=TRUE -Dtm_clover=TRUE -Dcean=FALSE -Dmm_malloc=TRUE -Dtesting=TRUE -DPYTHON_LIBRARY=${EBROOTPYTHON}/lib/libpython3.6m.so -DPYTHON_INCLUDE_DIR=${EBROOTPYTHON}/include/python3.6m"
CXX_FLAGS[qphix]+=" -restrict "

CONFIG_FLAGS[chroma]+="
    --enable-parallel-io
    --enable-parallel-arch=parscalar
    --enable-precision=double
    --enable-qdp-alignment=128
    --enable-sse-scalarsite-bicgstab-kernels
    --enable-sse2
    --enable-sse3
    --enable-qphix-solver-arch=avx2
    --enable-qphix-solver-compress12
    --with-qphix-solver=${INSTALL[qphix]}
    --with-gmp=$EBROOTGMP"
