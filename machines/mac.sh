BASE=$HOME/USQCD
STACK="qmp qdpxx qdpxx_single chroma chroma_single"


# brew install gcc
export HOMEBREW_CC=gcc-6
export HOMEBREW_CXX=g++-6
#GET[libxml2]="brew install libxml2"
#GET[fftw]="brew install fftw --with-mpi --with-openmp"
#GET[hdf5]="brew install hdf5 --with-mpi --c++11"
INSTALL[libxml2]=/usr/local/opt/libxml2
INSTALL[hdf5]=/usr/local
INSTALL[fftw]=/usr/local


CC=/usr/local/bin/mpicc
C_FLAGS[DEFAULT]="-O3 -march=corei7 -fpermissive -fopenmp"

CXX=/usr/local/bin/mpicxx
CXX_FLAGS[DEFAULT]="-O3 -std=c++11 -march=corei7 -ffast-math -funroll-all-loops -fpermissive -fopenmp"

LIBTOOLIZE=glibtoolize