BASE=/nfs/tmp2/lattice_qcd/surface/gnu/USQCD/example
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

export CC=mpicc
export CXX=mpicxx

C_FLAGS[DEFAULT]="-fopenmp -g -O2 -std=c99 -march=core2"
CXX_FLAGS[DEFAULT]="-fopenmp -g -O2 -std=c++11 -march=core2"
CONFIG_FLAGS[chroma]+=' --enable-cpp-wilson-dslash --enable-sse-scalarsite-bicgstab-kernels --enable-sse2 --enable-sse3 --with-cuda=$CUDA_INSTALL_PATH --with-quda=${INSTALL[quda]} '

if [[ "chroma" == "$LIBRARY" && "install" == "$ACTION" && -z "${SURFACE_FIRST_INSTALL}" ]]; then
    echo "HEY!  Pay attention to this!"
    echo ""
    echo "ACTION IS REQUIRED!!"
    echo ""
    echo "If you're seeing this, chroma probably compiled correctly."
    echo "However, you may run into a problem when linking against this installation."
    echo ""
    echo "The issue is the ordering of the -l flags output by $(UNQUOTE "${INSTALL[chroma]}/bin/chroma-config")"
    echo "which is complicated when chroma is compiled against quda."
    echo ""
    echo "Via private communication, Balint Joo provided two workarounds."
    echo ""
    echo "1)  Add -lqmp to the end of the definition of chroma_libs in $(UNQUOTE "${INSTALL[chroma]}/bin/chroma-config")"
    echo ""
    echo "2)  Add an additional \$(CHROMA_LIBS) at the end of your compilation line.  In other words, REPEAT the chroma libs AFTER specifying -lyour_libs."
    echo ""
    echo "A long-term solution may be in the works (for example, modifying the generation of chroma-config) but one is not yet provided."
    echo ""
    echo ""
    sleep 5
fi
SURFACE_FIRST_INSTALL="no"
