BASE=/nfs/tmp2/lattice_qcd/vulcan/USQCD

# load dotkit
. /usr/local/tools/dotkit/init.sh

use clang   > /dev/null 2>&1

HOST=powerpc64-bgq-linux
#BUILD=powerpc64-unknown-linux-gnu

INSTALL[hdf5]=/usr/local/tools/hdf5/hdf5-1.8.16/parallel_clang
INSTALL[fftw]=${FFTW_LIBS%/*}

STACK="qmp libxml2 qdpxx qphix chroma"

CC=mpiclang
CXX=mpiclang++11

C_FLAGS[DEFAULT]="-fopenmp -O3 -fPIC -std=c99 -D_GNU_SOURCE -Drestrict=__restrict__" #-fargument-noalias-global
CXX_FLAGS[DEFAULT]="-fopenmp -O3 -fno-strict-aliasing -fPIC -D_GNU_SOURCE -Drestrict=__restrict__" #-finline-limit=50000 -fargument-noalias-global

C_FLAGS[qphix]+=' -I${INSTALL[qdpxx]}/include -I${INSTALL[libxml2]}/include '
CXX_FLAGS[qphix]+=' -I${INSTALL[qdpxx]}/include -I${INSTALL[libxml2]}/include '

# CONFIG_FLAGS[chroma]+=" --enable-sse-scalarsite-bicgstab-kernels --enable-sse2 --enable-sse3"
LIBS[DEFAULT]="-ldl /usr/local/tools/zlib-1.2.6/lib/libz.a "
LD_FLAGS[DEFAULT]="-static"
CONFIG_FLAGS[qphix]+=" --enable-clover --enable-proc=QPX --enable-soalen=4 "

if [[ "chroma" == "$LIBRARY" && ! -z "${vulcan_first}" ]]; then # && "complete" == "$ACTION" 
    echo "HEY!  Pay attention to this!"
    echo "Vulcan has some weird issue with -lz"
    echo "To circumvent this, I added /usr/local/tools/zlib-1.2.6/lib/libz.a to LIBS[DEFAULT]."
    echo "BUT, qdp++-config sticks -lz back in.  So you will have trouble making."
    echo "Thus, there are some unfortunate manual steps."
    echo ""
    echo $(UNQUOTE "After chroma is configured but before making, go and remove -lz from ${BUILD[chroma]}/chroma-config")
    echo ""
    sleep 5
fi
vulcan_first="no"