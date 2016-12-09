BASE=$HOME/USQCD/juqueen

module load clang/3.7.r236977 hdf5/1.8.15_bgclang
HOST=powerpc64-bgq-linux
INSTALL[hdf5]=/bgsys/local/hdf5/v1.8.15_bgclang

STACK="qmp libxml2 qdpxx chroma" 

CC=mpiclang
CXX=mpiclang++11

LD_FLAGS[DEFAULT]="-static"
C_FLAGS[DEFAULT]="-fopenmp -O3 -fPIC -std=c99 -D_GNU_SOURCE -Drestrict=__restrict__" #-fargument-noalias-global
CXX_FLAGS[DEFAULT]="-fopenmp -O3 -fno-strict-aliasing -fPIC -D_GNU_SOURCE -Drestrict=__restrict__" #-finline-limit=50000 -fargument-noalias-global

CONFIG_FLAGS[qmp]+=" --host=powerpc64-bgq-linux --build=powerpc64-unknown-linux-gnu "
CONFIG_FLAGS[libxml2]+=" --host=powerpc64-bgq-linux --build=powerpc64-unknown-linux-gnu "
CONFIG_FLAGS[qdpxx]+=" --host=powerpc64-bgq-linux --build=powerpc64-unknown-linux-gnu "
CONFIG_FLAGS[chroma]+=" --host=powerpc64-bgq-linux --build=powerpc64-unknown-linux-gnu "

# GIT_BRANCH[qphix]="bgq_port_debug"
# C_FLAGS[qphix]+=' -I${INSTALL[qdpxx]}/include -I${INSTALL[libxml2]}/include '
# CXX_FLAGS[qphix]+=' -I${INSTALL[qdpxx]}/include -I${INSTALL[libxml2]}/include '
# CONFIG_FLAGS[qphix]+=" --enable-clover --enable-proc=QPX --enable-soalen=4 --host=powerpc64-bgq-linux --build=powerpc64-unknown-linux-gnu "
