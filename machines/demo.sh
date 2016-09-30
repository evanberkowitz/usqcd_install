BASE=$(unset CDPATH && cd "$(dirname "$0")" && echo $PWD)
STACK="qmp libxml2 hdf5 fftw qdpxx quda qphix chroma"
CC=gcc
CXX=g++

LIBS=("qmp" "libxml2" "hdf5" "fftw" "qdpxx" "quda" "qphix" "chroma")

unset DIR
declare -A DIR

DIR[SOURCE]='${BASE}/source'
DIR[BUILD]='${BASE}/build'
DIR[INSTALL]='${BASE}/install'
DIR[LOG]='${BASE}/log'

unset GET
declare -A GET
GIT_CLONE="git clone --recursive"
GIT_UPDATE_SUBMODULES="git submodule update --init --recursive"
#GIT_UPDATE_SUBMODULES="echo FOOBAR"

GET[qmp]='echo GETTING qmp'
GET[libxml2]='echo GETTING libxml2'
GET[hdf5]='echo GETTING hdf5'
GET[fftw]='echo GETTING fftw'
GET[qdpxx]='echo GETTING qdpxx'
GET[quda]='echo GETTING quda'
GET[qphix]='echo GETTING qphix'
GET[chroma]='echo GETTING chroma'

unset SOURCE
declare -A SOURCE

SOURCE[qmp]='${DIR[SOURCE]}/qmp'
SOURCE[libxml2]='${DIR[SOURCE]}/libxml2'
SOURCE[hdf5]='${DIR[SOURCE]}/hdf5'
SOURCE[fftw]='${DIR[SOURCE]}/fftw'
SOURCE[qdpxx]='${DIR[SOURCE]}/qdpxx'
SOURCE[quda]='${DIR[SOURCE]}/quda'
SOURCE[qphix]='${DIR[SOURCE]}/qphix'
SOURCE[chroma]='${DIR[SOURCE]}/chroma'

unset BUILD
declare -A BUILD

BUILD[qmp]='${DIR[BUILD]}/qmp'
BUILD[libxml2]='${DIR[BUILD]}/libxml2'
BUILD[hdf5]='${DIR[BUILD]}/hdf5'
BUILD[fftw]='${DIR[BUILD]}/fftw'
BUILD[qdpxx]='${DIR[BUILD]}/qdpxx'
BUILD[quda]='${DIR[BUILD]}/quda'
BUILD[qphix]='${DIR[BUILD]}/qphix'
BUILD[chroma]='${DIR[BUILD]}/chroma'

unset LOG
declare -A LOG

LOG[qmp]='${DIR[LOG]}/qmp'
LOG[libxml2]='${DIR[LOG]}/libxml2'
LOG[hdf5]='${DIR[LOG]}/hdf5'
LOG[fftw]='${DIR[LOG]}/fftw'
LOG[qdpxx]='${DIR[LOG]}/qdpxx'
LOG[quda]='${DIR[LOG]}/quda'
LOG[qphix]='${DIR[LOG]}/qphix'
LOG[chroma]='${DIR[LOG]}/chroma'

unset INSTALL
declare -A INSTALL

INSTALL[qmp]='${DIR[INSTALL]}/qmp'
INSTALL[libxml2]='${DIR[INSTALL]}/libxml2'
INSTALL[hdf5]='${DIR[INSTALL]}/hdf5'
INSTALL[fftw]='${DIR[INSTALL]}/fftw'
INSTALL[qdpxx]='${DIR[INSTALL]}/qdpxx'
INSTALL[quda]='${DIR[INSTALL]}/quda'
INSTALL[qphix]='${DIR[INSTALL]}/qphix'
INSTALL[chroma]='${DIR[INSTALL]}/chroma'

unset OTHER_LIBS
declare -A OTHER_LIBS

OTHER_LIBS[qmp]=""
OTHER_LIBS[libxml2]=""
OTHER_LIBS[hdf5]=""
OTHER_LIBS[fftw]=""
OTHER_LIBS[qdpxx]="QDPXX OTHER LIBS"
OTHER_LIBS[quda]=""
OTHER_LIBS[qphix]=""
OTHER_LIBS[chroma]="CHROMA OTHER LIBS"

unset CONFIGURE
declare -A CONFIGURE

CONFIGURE[qmp]='echo "CONFIGURE qmp"'
CONFIGURE[libxml2]='echo "CONFIGURE libxml2"'
CONFIGURE[hdf5]='echo "CONFIGURE hdf5"'
CONFIGURE[fftw]='echo "CONFIGURE fftw"'
CONFIGURE[qdpxx]='echo "CONFIGURE qdpxx"'
CONFIGURE[quda]='echo "CONFIGURE quda"'
CONFIGURE[qphix]='echo "CONFIGURE qphix"'
CONFIGURE[chroma]='echo "CONFIGURE chroma"'

unset CONFIG_FLAGS
declare -A CONFIG_FLAGS

CONFIG_FLAGS[qmp]=' CONFIG_FLAGS[qmp] '
CONFIG_FLAGS[libxml2]=' CONFIG_FLAGS[libxml2] '
CONFIG_FLAGS[hdf5]=' CONFIG_FLAGS[hdf5] '
CONFIG_FLAGS[fftw]=' CONFIG_FLAGS[fftw] '
CONFIG_FLAGS[qdpxx]=' CONFIG_FLAGS[qdpxx] '
CONFIG_FLAGS[quda]=' CONFIG_FLAGS[quda] '
CONFIG_FLAGS[qphix]=' CONFIG_FLAGS[qphix] '
CONFIG_FLAGS[chroma]=' CONFIG_FLAGS[chroma] '

unset CXX_FLAGS
declare -A CXX_FLAGS

CXX_FLAGS[qmp]=' CXX_FLAGS[qmp] '
CXX_FLAGS[libxml2]=' CXX_FLAGS[libxml2] '
CXX_FLAGS[hdf5]=' CXX_FLAGS[hdf5] '
CXX_FLAGS[fftw]=' CXX_FLAGS[fftw] '
CXX_FLAGS[qdpxx]=' CXX_FLAGS[qdpxx] '
CXX_FLAGS[quda]=' CXX_FLAGS[quda] '
CXX_FLAGS[qphix]=' CXX_FLAGS[qphix] '
CXX_FLAGS[chroma]=' CXX_FLAGS[chroma] '

unset C_FLAGS
declare -A C_FLAGS

C_FLAGS[qmp]=' C_FLAGS[qmp] '
C_FLAGS[libxml2]=' C_FLAGS[libxml2] '
C_FLAGS[hdf5]=' C_FLAGS[hdf5] '
C_FLAGS[fftw]=' C_FLAGS[fftw] '
C_FLAGS[qdpxx]=' C_FLAGS[qdpxx] '
C_FLAGS[quda]=' C_FLAGS[quda] '
C_FLAGS[qphix]=' C_FLAGS[qphix] '
C_FLAGS[chroma]=' C_FLAGS[chroma] '

unset LIBTOOL AUTOHEADER ACLOCAL AUTOMAKE AUTOCONF AUTORECONF AUTOTOOLS MAKE
LIBTOOL="libtoolize"
AUTOHEADER="autoheader"
ACLOCAL="aclocal"
AUTOMAKE="automake --add-missing"
AUTOCONF="autoconf"
AUTORECONF="autoreconf -f"
AUTOTOOLS='echo AUTOTOOLS'
MAKE="echo RUNNING MAKE"