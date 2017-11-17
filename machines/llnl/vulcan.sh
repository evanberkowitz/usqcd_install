BASE=/nfs/tmp2/lattice_qcd/vulcan/USQCD

# load dotkit
. /usr/local/tools/dotkit/init.sh

use clang   > /dev/null 2>&1

HOST=powerpc64-bgq-linux
#BUILD=powerpc64-unknown-linux-gnu

INSTALL[hdf5]=/nfs/tmp2/lattice_qcd/vulcan/USQCD/install/hdf5-1.10.1
INSTALL[fftw]=/usr/local/tools/fftw-3.3.3

STACK="qmp libxml2 qdpxx chroma"

CC=mpiclang
CXX=mpiclang++11

C_FLAGS[DEFAULT]="-fopenmp -O3 -fPIC -std=c99 -D_GNU_SOURCE -Drestrict=__restrict__" #-fargument-noalias-global
CXX_FLAGS[DEFAULT]="-fopenmp -O3 -fno-strict-aliasing -fPIC -D_GNU_SOURCE -Drestrict=__restrict__" #-finline-limit=50000 -fargument-noalias-global

# C_FLAGS[qphix]+=' -I${INSTALL[qdpxx]}/include -I${INSTALL[libxml2]}/include '
# CXX_FLAGS[qphix]+=' -I${INSTALL[qdpxx]}/include -I${INSTALL[libxml2]}/include '

# CONFIG_FLAGS[chroma]+=" --enable-sse-scalarsite-bicgstab-kernels --enable-sse2 --enable-sse3"
LIBS[DEFAULT]="-ldl -L/nfs/tmp2/lattice_qcd/vulcan/USQCD/install/zlib-1.2.11/lib -lz" #" /usr/local/tools/zlib-1.2.6/lib/libz.a "
LD_FLAGS[DEFAULT]="-static"
# CONFIG_FLAGS[qphix]+=" --enable-clover --enable-proc=QPX --enable-soalen=4 "

# MESSAGE[vulcan,configure]="
# HEY!  Pay attention to this!
# Vulcan has some weird issue with -lz
#
# To circumvent this, I added /usr/local/tools/zlib-1.2.6/lib/libz.a to LIBS[DEFAULT].
#
# BUT, qdp++-config sticks -lz back in.  So you will have trouble making.
# Thus, there are some unfortunate manual steps.
#
# After chroma is configured but before making, go and remove -lz from build/chroma/chroma-config"
