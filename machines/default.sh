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

GET[qmp]='${GIT_CLONE} git@github.com:usqcd-software/qmp.git ${SOURCE[$LIBRARY]}; '
GET[libxml2]='${GIT_CLONE} git://git.gnome.org/libxml2 ${SOURCE[$LIBRARY]}; pushd ${SOURCE[$LIBRARY]}; git checkout v2.9.4; popd'
GET[hdf5]='curl https://support.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.17.tar -o ${SOURCE[$LIBRARY]%/*}/hdf5-1.8.17.tar; pushd; tar -xzf ${SOURCE[$LIBRARY]%/*}/hdf5-1.8.17.tar; popd;'
GET[fftw]='${GIT_CLONE} git@github.com:FFTW/fftw3.git ${SOURCE[$LIBRARY]}; '
GET[qdpxx]='${GIT_CLONE} git@github.com:azrael417/qdpxx.git ${SOURCE[$LIBRARY]}; ${GIT_UPDATE_SUBMODULES}; '
GET[quda]='${GIT_CLONE} git@github.com:lattice/quda.git ${SOURCE[$LIBRARY]};'
GET[qphix]='${GIT_CLONE} git@github.com:JeffersonLab/qphix.git ${SOURCE[$LIBRARY]};'
GET[chroma]='${GIT_CLONE} git@github.com:JeffersonLab/chroma.git ${SOURCE[$LIBRARY]}; ${GIT_UPDATE_SUBMODULES}; '

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
OTHER_LIBS[qdpxx]="other_libs/filedb other_libs/libintrin other_libs/qio/other_libs/c-lime other_libs/qio other_libs/xpath_reader "
OTHER_LIBS[quda]=""
OTHER_LIBS[qphix]=""
OTHER_LIBS[chroma]="other_libs/cg-dwf other_libs/cpp_wilson_dslash other_libs/qdp-lapack other_libs/sse_wilson_dslash other_libs/wilsonmg"

unset CONFIGURE
declare -A CONFIGURE

CONFIGURE[qmp]='${SOURCE[qmp]}/configure '
CONFIGURE[libxml2]='${SOURCE[libxml2]}/configure '
CONFIGURE[hdf5]='${SOURCE[hdf5]}/configure '
CONFIGURE[fftw]='${SOURCE[fftw]}/configure '
CONFIGURE[qdpxx]='${SOURCE[qdpxx]}/configure '
CONFIGURE[quda]='echo "NEED TO DO SOMETHING WITH CMAKE FOR quda"'
CONFIGURE[qphix]='echo "I do not understand QPhiX"'
CONFIGURE[chroma]='${SOURCE[chroma]}/configure '

unset CONFIG_FLAGS
declare -A CONFIG_FLAGS

CONFIG_FLAGS[qmp]='--prefix=${INSTALL[qmp]} --with-qmp-comms-type=MPI'
CONFIG_FLAGS[libxml2]='--prefix=${INSTALL[libxml2]}  --disable-shared  --without-zlib  --without-python  --without-readline  --without-threads  --without-history  --without-reader  --without-writer  --with-output  --without-ftp  --without-http  --without-pattern  --without-catalog  --without-docbook  --without-iconv  --without-schemas  --without-schematron  --without-modules  --without-xptr  --without-xinclude'
CONFIG_FLAGS[hdf5]='--prefix=${INSTALL[hdf5]} '
CONFIG_FLAGS[fftw]='--prefix=${INSTALL[fftw]} '
CONFIG_FLAGS[qdpxx]='--prefix=${INSTALL[qdpxx]} --with-qmp=${INSTALL[qmp]} --with-libxml2=${INSTALL[libxml]} --with-hdf5=${INSTALL[hdf5]} --enable-openmp --enable-precision=double --enable-largefile --enable-parallel-io --enable-db-lite --enable-parallel-arch=parscalar'
CONFIG_FLAGS[quda]='--prefix=${INSTALL[quda]} '
CONFIG_FLAGS[qphix]='--prefix=${INSTALL[qphix]} '
CONFIG_FLAGS[chroma]='--prefix=${INSTALL[chroma]} --with-qmp=${INSTALL[qmp]} --with-qdp=${INSTALL[qdpxx]} --enable-openmp --enable-cpp-wilson-dslash'

unset CXX_FLAGS
declare -A CXX_FLAGS

CXX_FLAGS[qmp]='${CXX_FLAGS[DEFAULT]}'
CXX_FLAGS[libxml2]='${CXX_FLAGS[DEFAULT]}'
CXX_FLAGS[hdf5]='${CXX_FLAGS[DEFAULT]}'
CXX_FLAGS[fftw]='${CXX_FLAGS[DEFAULT]}'
CXX_FLAGS[qdpxx]='${CXX_FLAGS[DEFAULT]}'
CXX_FLAGS[quda]='${CXX_FLAGS[DEFAULT]}'
CXX_FLAGS[qphix]='${CXX_FLAGS[DEFAULT]}'
CXX_FLAGS[chroma]='${CXX_FLAGS[DEFAULT]}'

unset C_FLAGS
declare -A C_FLAGS

C_FLAGS[qmp]='${C_FLAGS[DEFAULT]}'
C_FLAGS[libxml2]='${C_FLAGS[DEFAULT]}'
C_FLAGS[hdf5]='${C_FLAGS[DEFAULT]}'
C_FLAGS[fftw]='${C_FLAGS[DEFAULT]}'
C_FLAGS[qdpxx]='${C_FLAGS[DEFAULT]}'
C_FLAGS[quda]='${C_FLAGS[DEFAULT]}'
C_FLAGS[qphix]='${C_FLAGS[DEFAULT]}'
C_FLAGS[chroma]='${C_FLAGS[DEFAULT]}'

unset LIBTOOL AUTOHEADER ACLOCAL AUTOMAKE AUTOCONF AUTORECONF AUTOTOOLS MAKE
LIBTOOL="libtoolize"
AUTOHEADER="autoheader"
ACLOCAL="aclocal"
AUTOMAKE="automake --add-missing"
AUTOCONF="autoconf"
AUTORECONF="autoreconf -f"
AUTOTOOLS='touch ChangeLog; $LIBTOOLIZE; $AUTOHEADER ; $ACLOCAL ; $AUTOMAKE; $AUTOMAKE; $AUTOCONF ; $AUTORECONF; $LIBTOOLIZE; $AUTOHEADER ; $ACLOCAL ; $AUTOMAKE; $AUTOMAKE; $AUTOCONF ; $AUTORECONF'
MAKE="make -j 10"