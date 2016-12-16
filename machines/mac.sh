BASE=$HOME/USQCD
STACK="qmp qdpxx chroma qdpxx_single chroma_single"


# brew install gcc
export HOMEBREW_CC=gcc-6
export HOMEBREW_CXX=g++-6
# brew install open-mpi  --without-fortran --with-cxx-bindings --c++11 --with-mpi-thread-multiple  # --without-fortran is key to avoid `make check` errors on my system.
GET[libxml2]="brew install libxml2"
GET[fftw]="brew install fftw --with-mpi --with-openmp"
GET[hdf5]="brew install hdf5 --with-mpi --c++11"
INSTALL[libxml2]=/usr/local/opt/libxml2
INSTALL[hdf5]=/usr/local
INSTALL[fftw]=/usr/local


export CC=/usr/local/bin/mpicc
C_FLAGS[DEFAULT]="-O3 -march=corei7 -fpermissive -fopenmp -D_GLIBC_USE_CXX1_ABI=0"

export CXX=/usr/local/bin/mpicxx
CXX_FLAGS[DEFAULT]="-O3 -std=c++11 -march=corei7 -ffast-math -funroll-all-loops -fpermissive -fopenmp -D_GLIBC_USE_CXX1_ABI=0"

# No zmuldefs.
LD_FLAGS[chroma]='${LD_FLAGS[DEFAULT]}'
LD_FLAGS[chroma_single]='${LD_FLAGS[DEFAULT]}'

LIBTOOLIZE=glibtoolize