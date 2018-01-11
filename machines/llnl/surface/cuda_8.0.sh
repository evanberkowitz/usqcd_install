BASE=/nfs/tmp2/lattice_qcd/surface/cuda_8.0/USQCD
GPUS=1

# load dotkit
. /usr/local/tools/dotkit/init.sh

module purge
use hdf5-gnu-parallel-mvapich2-1.8.16 > /dev/null
use mvapich2-gnu-2.2                  > /dev/null
module load cudatoolkit/8.0
module load gnu/4.9.2
module load fftw/3.2

HOST=x86_64-linux-gnu
GPU_ARCH=sm_35  # Kepler GK110 at Keeneland

INSTALL[hdf5]=$HDF5
INSTALL[fftw]=${FFTW_LIBS%/*}

STACK="qmp libxml2 qdpxx quda chroma"

GIT_BRANCH[quda]="feature/multigrid"
CONFIG_FLAGS[quda]+=" -DQUDA_MULTIGRID=ON -DCMAKE_BUILD_TYPE=RELEASE "

export CC=mpicc
export CXX=mpicxx

C_FLAGS[DEFAULT]="-fopenmp -g -O2 -std=c99 -march=core2"
CXX_FLAGS[DEFAULT]="-fopenmp -g -O2 -std=c++11 -march=core2"
CONFIG_FLAGS[chroma]+=' --enable-cpp-wilson-dslash --enable-sse-scalarsite-bicgstab-kernels --enable-sse2 --enable-sse3 --with-cuda=$CUDA_INSTALL_PATH --with-quda=${INSTALL[quda]} '

MESSAGE[chroma,install]="

HEY!  Pay attention to this!

ACTION MAY BE REQUIRED!!

If you're seeing this, chroma probably compiled correctly.
However, you may run into a problem when linking against this installation.

The issue is the ordering of the -l flags output by $(UNQUOTE "${INSTALL[chroma]}/bin/chroma-config")
which is complicated when chroma is compiled against quda.

Via private communication, Balint Joo provided two workarounds.

1)  Add -lqmp to the end of the definition of chroma_libs in $(UNQUOTE "${INSTALL[chroma]}/bin/chroma-config")

2)  Add an additional \$(CHROMA_LIBS) at the end of your compilation line.  In other words, REPEAT the chroma libs AFTER specifying -lyour_libs.

A long-term solution may be in the works (for example, modifying the generation of chroma-config) but one is not yet provided.

"
