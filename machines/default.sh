LIBS=("qmp" "libxml2" "hdf5" "fftw" "qdpxx" "qdpxx_single" "quda" "qphix" "chroma" "chroma_single")

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

GET[qmp]='${GIT_CLONE} git@github.com:usqcd-software/qmp.git ${SOURCE[$LIBRARY]}; pushd ${SOURCE[$LIBRARY]}; git checkout ${GIT_BRANCH[qmp]}; popd'
# GET[libxml2]='${GIT_CLONE} git://git.gnome.org/libxml2 ${SOURCE[$LIBRARY]}; pushd ${SOURCE[$LIBRARY]}; git checkout v2.9.4; popd' # doesn't autotools and configure properly.
GET[libxml2]='curl ftp://xmlsoft.org/libxml2/libxml2-2.9.4.tar.gz -o ${SOURCE[$LIBRARY]%/*}/libxml2-2.9.4.tar.gz; pushd ${SOURCE[$LIBRARY]%/*}; tar -xzf libxml2-2.9.4.tar.gz; mv libxml2-2.9.4 ${SOURCE[$LIBRARY]}; popd;'
GET[hdf5]='curl https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8.16/src/hdf5-1.8.16.tar.gz -o ${SOURCE[$LIBRARY]%/*}/hdf5-1.8.16.tar.gz; pushd ${SOURCE[$LIBRARY]%/*}; tar -xzf ${SOURCE[$LIBRARY]%/*}/hdf5-1.8.16.tar.gz;  mv hdf5-1.8.16 ${SOURCE[$LIBRARY]}; popd;'
GET[fftw]='${GIT_CLONE} git@github.com:FFTW/fftw3.git ${SOURCE[$LIBRARY]}; '
GET[qdpxx]='${GIT_CLONE} git@github.com:azrael417/qdpxx.git ${SOURCE[$LIBRARY]}; pushd ${SOURCE[$LIBRARY]}; git checkout ${GIT_BRANCH[qdpxx]}; ${GIT_UPDATE_SUBMODULES}; popd; '
GET[qdpxx_single]='${GIT_CLONE} git@github.com:azrael417/qdpxx.git ${SOURCE[$LIBRARY]}; pushd ${SOURCE[$LIBRARY]}; git checkout ${GIT_BRANCH[qdpxx_single]}; ${GIT_UPDATE_SUBMODULES}; popd; '
GET[quda]='${GIT_CLONE} git@github.com:lattice/quda.git ${SOURCE[$LIBRARY]}; pushd ${SOURCE[$LIBRARY]}; git checkout ${GIT_BRANCH[quda]}; ${GIT_UPDATE_SUBMODULES}; popd; '
GET[qphix]='${GIT_CLONE} git@github.com:JeffersonLab/qphix.git ${SOURCE[$LIBRARY]}; pushd ${SOURCE[$LIBRARY]}; git checkout ${GIT_BRANCH[qphix]}; ${GIT_UPDATE_SUBMODULES}; popd; '
GET[chroma]='${GIT_CLONE} git@github.com:JeffersonLab/chroma.git ${SOURCE[$LIBRARY]}; pushd ${SOURCE[$LIBRARY]}; git checkout ${GIT_BRANCH[chroma]}; ${GIT_UPDATE_SUBMODULES}; popd; '
GET[chroma_single]='${GIT_CLONE} git@github.com:JeffersonLab/chroma.git ${SOURCE[$LIBRARY]}; pushd ${SOURCE[$LIBRARY]}; git checkout ${GIT_BRANCH[chroma_single]}; ${GIT_UPDATE_SUBMODULES}; popd; '

unset GIT_BRANCH
declare -A GIT_BRANCH

GIT_BRANCH[qmp]="mpiaccess"
GIT_BRANCH[libxml2]="v2.9.4"
GIT_BRANCH[hdf5]=""
GIT_BRANCH[fftw]="master"
GIT_BRANCH[qdpxx]="devel"
GIT_BRANCH[qdpxx_single]="devel"
GIT_BRANCH[quda]="devel"
GIT_BRANCH[qphix]="devel"
GIT_BRANCH[chroma]="devel"
GIT_BRANCH[chroma_single]="devel"


unset SOURCE
declare -A SOURCE

SOURCE[qmp]='${DIR[SOURCE]}/qmp'
SOURCE[libxml2]='${DIR[SOURCE]}/libxml2'
SOURCE[hdf5]='${DIR[SOURCE]}/hdf5'
SOURCE[fftw]='${DIR[SOURCE]}/fftw'
SOURCE[qdpxx]='${DIR[SOURCE]}/qdpxx'
SOURCE[qdpxx_single]='${DIR[SOURCE]}/qdpxx_single'
SOURCE[quda]='${DIR[SOURCE]}/quda'
SOURCE[qphix]='${DIR[SOURCE]}/qphix'
SOURCE[chroma]='${DIR[SOURCE]}/chroma'
SOURCE[chroma_single]='${DIR[SOURCE]}/chroma_single'

unset BUILD
declare -A BUILD

BUILD[qmp]='${DIR[BUILD]}/qmp'
BUILD[libxml2]='${DIR[BUILD]}/libxml2'
BUILD[hdf5]='${DIR[BUILD]}/hdf5'
BUILD[fftw]='${DIR[BUILD]}/fftw'
BUILD[qdpxx]='${DIR[BUILD]}/qdpxx'
BUILD[qdpxx_single]='${DIR[BUILD]}/qdpxx_single'
BUILD[quda]='${DIR[INSTALL]}/quda'  # I know this looks wrong, but the current cmake build system just wants you to build in the install directory.
BUILD[qphix]='${DIR[BUILD]}/qphix'
BUILD[chroma]='${DIR[BUILD]}/chroma'
BUILD[chroma_single]='${DIR[BUILD]}/chroma_single'

unset LOG
declare -A LOG

LOG[qmp]='${DIR[LOG]}/qmp'
LOG[libxml2]='${DIR[LOG]}/libxml2'
LOG[hdf5]='${DIR[LOG]}/hdf5'
LOG[fftw]='${DIR[LOG]}/fftw'
LOG[qdpxx]='${DIR[LOG]}/qdpxx'
LOG[qdpxx_single]='${DIR[LOG]}/qdpxx_single'
LOG[quda]='${DIR[LOG]}/quda'
LOG[qphix]='${DIR[LOG]}/qphix'
LOG[chroma]='${DIR[LOG]}/chroma'
LOG[chroma_single]='${DIR[LOG]}/chroma_single'

unset INSTALL
declare -A INSTALL

INSTALL[qmp]='${DIR[INSTALL]}/qmp'
INSTALL[libxml2]='${DIR[INSTALL]}/libxml2'
INSTALL[hdf5]='${DIR[INSTALL]}/hdf5'
INSTALL[fftw]='${DIR[INSTALL]}/fftw'
INSTALL[qdpxx]='${DIR[INSTALL]}/qdpxx'
INSTALL[qdpxx_single]='${DIR[INSTALL]}/qdpxx_single'
INSTALL[quda]='${DIR[INSTALL]}/quda'
INSTALL[qphix]='${DIR[INSTALL]}/qphix'
INSTALL[chroma]='${DIR[INSTALL]}/chroma'
INSTALL[chroma_single]='${DIR[INSTALL]}/chroma_single'

unset OTHER_LIBS
declare -A OTHER_LIBS

OTHER_LIBS[qmp]=""
OTHER_LIBS[libxml2]=""
OTHER_LIBS[hdf5]=""
OTHER_LIBS[fftw]=""
OTHER_LIBS[qdpxx]="other_libs/filedb other_libs/libintrin other_libs/qio/other_libs/c-lime other_libs/qio other_libs/xpath_reader "
OTHER_LIBS[qdpxx_single]="other_libs/filedb other_libs/libintrin other_libs/qio/other_libs/c-lime other_libs/qio other_libs/xpath_reader "
OTHER_LIBS[quda]=""
OTHER_LIBS[qphix]=""
OTHER_LIBS[chroma]="other_libs/cg-dwf other_libs/cpp_wilson_dslash other_libs/qdp-lapack other_libs/sse_wilson_dslash other_libs/wilsonmg"
OTHER_LIBS[chroma_single]="other_libs/cg-dwf other_libs/cpp_wilson_dslash other_libs/qdp-lapack other_libs/sse_wilson_dslash other_libs/wilsonmg"

unset LIBS
declare -A LIBS

LIBS[qmp]='${LIBS[DEFAULT]}'
LIBS[libxml2]='${LIBS[DEFAULT]}'
LIBS[hdf5]='${LIBS[DEFAULT]}'
LIBS[fftw]='${LIBS[DEFAULT]}'
LIBS[qdpxx]='${LIBS[DEFAULT]}'
LIBS[qdpxx_single]='${LIBS[DEFAULT]}'
LIBS[quda]='${LIBS[DEFAULT]}'
LIBS[qphix]='${LIBS[DEFAULT]}'
LIBS[chroma]='${LIBS[DEFAULT]}'
LIBS[chroma_single]='${LIBS[DEFAULT]}'


unset CONFIGURE
declare -A CONFIGURE

CONFIGURE[qmp]='${SOURCE[qmp]}/configure '
CONFIGURE[libxml2]='${SOURCE[libxml2]}/configure '
CONFIGURE[hdf5]='${SOURCE[hdf5]}/configure '
CONFIGURE[fftw]='${SOURCE[fftw]}/configure '
CONFIGURE[qdpxx]='${SOURCE[qdpxx]}/configure '
CONFIGURE[qdpxx_single]='${SOURCE[qdpxx_single]}/configure '
CONFIGURE[quda]='cmake ${SOURCE[quda]} '
CONFIGURE[qphix]='${SOURCE[qphix]}/configure'
CONFIGURE[chroma]='${SOURCE[chroma]}/configure '
CONFIGURE[chroma_single]='${SOURCE[chroma_single]}/configure '

unset CONFIG_FLAGS
declare -A CONFIG_FLAGS

CONFIG_FLAGS[qmp]='--prefix=${INSTALL[qmp]} --with-qmp-comms-type=MPI'
CONFIG_FLAGS[libxml2]='--prefix=${INSTALL[libxml2]}  --disable-shared  --without-zlib  --without-python  --without-readline  --without-threads  --without-history  --without-reader  --without-writer  --with-output  --without-ftp  --without-http  --without-pattern  --without-catalog  --without-docbook  --without-iconv  --without-schemas  --without-schematron  --without-modules  --without-xptr  --without-xinclude'
CONFIG_FLAGS[hdf5]='--prefix=${INSTALL[hdf5]} '
CONFIG_FLAGS[fftw]='--prefix=${INSTALL[fftw]} '
CONFIG_FLAGS[qdpxx]='--prefix=${INSTALL[qdpxx]} --with-qmp=${INSTALL[qmp]} --with-libxml2=${INSTALL[libxml2]} --with-hdf5=${INSTALL[hdf5]} --enable-openmp --enable-precision=double --enable-largefile --enable-parallel-io --enable-db-lite --enable-parallel-arch=parscalar'
CONFIG_FLAGS[qdpxx_single]='--prefix=${INSTALL[qdpxx_single]} --with-qmp=${INSTALL[qmp]} --with-libxml2=${INSTALL[libxml2]} --with-hdf5=${INSTALL[hdf5]} --enable-openmp --enable-precision=single --enable-largefile --enable-parallel-io --enable-db-lite --enable-parallel-arch=parscalar'
CONFIG_FLAGS[quda]='-DQUDA_GPU_ARCH=${GPU_ARCH} -DQUDA_MPI=ON -DQUDA_QMP=ON -DQUDA_QMPHOME=${INSTALL[qmp]} -DMPI_C_COMPILER=${CC} -DMPI_CXX_COMPILER=${CXX} -DQUDA_DIRAC_WILSON=ON -DQUDA_DIRAC_DOMAIN_WALL=ON ' # -DQUDA_DIRAC_TWISTED_MASS=OFF  -DQUDA_LINK_HISQ=OFF -DQUDA_FORCE_GAUGE=OFF -DQUDA_FORCE_HISQ=OFF
CONFIG_FLAGS[qphix]='--prefix=${INSTALL[qphix]}   --with-qmp=${INSTALL[qmp]} --with-qdp=${INSTALL[qdpxx]} --enable-parallel-arch=parscalar --enable-mm-malloc ' # --disable-mm-malloc # --with-qdp and --with-qdp++ seem to fail.
CONFIG_FLAGS[chroma]='--prefix=${INSTALL[chroma]} --with-qmp=${INSTALL[qmp]} --with-qdp=${INSTALL[qdpxx]} --enable-openmp '
CONFIG_FLAGS[chroma_single]='--prefix=${INSTALL[chroma_single]} --with-qmp=${INSTALL[qmp]} --with-qdp=${INSTALL[qdpxx_single]} --enable-openmp '

unset CXX_FLAGS
declare -A CXX_FLAGS

CXX_FLAGS[qmp]='${CXX_FLAGS[DEFAULT]}'
CXX_FLAGS[libxml2]='${CXX_FLAGS[DEFAULT]}'
CXX_FLAGS[hdf5]='${CXX_FLAGS[DEFAULT]}'
CXX_FLAGS[fftw]='${CXX_FLAGS[DEFAULT]}'
CXX_FLAGS[qdpxx]='${CXX_FLAGS[DEFAULT]}'
CXX_FLAGS[qdpxx_single]='${CXX_FLAGS[DEFAULT]}'
CXX_FLAGS[quda]='${CXX_FLAGS[DEFAULT]}'
CXX_FLAGS[qphix]='${CXX_FLAGS[DEFAULT]}'
CXX_FLAGS[chroma]='${CXX_FLAGS[DEFAULT]}'
CXX_FLAGS[chroma_single]='${CXX_FLAGS[DEFAULT]}'

unset C_FLAGS
declare -A C_FLAGS

C_FLAGS[qmp]='${C_FLAGS[DEFAULT]}'
C_FLAGS[libxml2]='${C_FLAGS[DEFAULT]}'
C_FLAGS[hdf5]='${C_FLAGS[DEFAULT]}'
C_FLAGS[fftw]='${C_FLAGS[DEFAULT]}'
C_FLAGS[qdpxx]='${C_FLAGS[DEFAULT]}'
C_FLAGS[qdpxx_single]='${C_FLAGS[DEFAULT]}'
C_FLAGS[quda]='${C_FLAGS[DEFAULT]}'
C_FLAGS[qphix]='${C_FLAGS[DEFAULT]}'
C_FLAGS[chroma]='${C_FLAGS[DEFAULT]}'
C_FLAGS[chroma_single]='${C_FLAGS[DEFAULT]}'

unset QUDA_LIBS
declare -A QUDA_LIBS
if [[ ! -z "$GPUS" ]]; then
    GPU_ARCH=sm_35
    QUDA_LIBS[DEFAULT]='-lquda -lcudart -lcuda'
fi
QUDA_LIBS[qmp]='${QUDA_LIBS[DEFAULT]}'
QUDA_LIBS[libxml2]='${QUDA_LIBS[DEFAULT]}'
QUDA_LIBS[hdf5]='${QUDA_LIBS[DEFAULT]}'
QUDA_LIBS[fftw]='${QUDA_LIBS[DEFAULT]}'
QUDA_LIBS[qdpxx]='${QUDA_LIBS[DEFAULT]}'
QUDA_LIBS[qdpxx_single]='${QUDA_LIBS[DEFAULT]}'
QUDA_LIBS[quda]='${QUDA_LIBS[DEFAULT]}'
QUDA_LIBS[qphix]='${QUDA_LIBS[DEFAULT]}'
QUDA_LIBS[chroma]='${QUDA_LIBS[DEFAULT]}'
QUDA_LIBS[chroma_single]='${QUDA_LIBS[DEFAULT]}'

unset LD_FLAGS
declare -A LD_FLAGS

LD_FLAGS[qmp]='${LD_FLAGS[DEFAULT]}'
LD_FLAGS[libxml2]='${LD_FLAGS[DEFAULT]}'
LD_FLAGS[hdf5]='${LD_FLAGS[DEFAULT]}'
LD_FLAGS[fftw]='${LD_FLAGS[DEFAULT]}'
LD_FLAGS[qdpxx]='${LD_FLAGS[DEFAULT]}'
LD_FLAGS[qdpxx_single]='${LD_FLAGS[DEFAULT]}'
LD_FLAGS[quda]='${LD_FLAGS[DEFAULT]}'
LD_FLAGS[qphix]='${LD_FLAGS[DEFAULT]}'
LD_FLAGS[chroma]='${LD_FLAGS[DEFAULT]} -Wl,-zmuldefs'
LD_FLAGS[chroma_single]='${LD_FLAGS[DEFAULT]} -Wl,-zmuldefs'

unset MESSAGE
declare -A MESSAGE

MESSAGE[qmp,DEFAULT]='${MESSAGE[DEFAULT]}'
MESSAGE[libxml2,DEFAULT]='${MESSAGE[DEFAULT]}'
MESSAGE[hdf5,DEFAULT]='${MESSAGE[DEFAULT]}'
MESSAGE[fftw,DEFAULT]='${MESSAGE[DEFAULT]}'
MESSAGE[qdpxx,DEFAULT]='${MESSAGE[DEFAULT]}'
MESSAGE[qdpxx_single,DEFAULT]='${MESSAGE[DEFAULT]}'
MESSAGE[quda,DEFAULT]='${MESSAGE[DEFAULT]}'
MESSAGE[qphix,DEFAULT]='${MESSAGE[DEFAULT]}'
MESSAGE[chroma,DEFAULT]='${MESSAGE[DEFAULT]}'
MESSAGE[chroma_single,DEFAULT]='${MESSAGE[DEFAULT]}'

MESSAGE[qmp,report]='${MESSAGE[qmp,DEFAULT]}'
MESSAGE[qmp,get]='${MESSAGE[qmp,DEFAULT]}'
MESSAGE[qmp,configure]='${MESSAGE[qmp,DEFAULT]}'
MESSAGE[qmp,make]='${MESSAGE[qmp,DEFAULT]}'
MESSAGE[qmp,install]='${MESSAGE[qmp,DEFAULT]}'
MESSAGE[qmp,complete]='${MESSAGE[qmp,DEFAULT]}'
MESSAGE[qmp,clean]='${MESSAGE[qmp,DEFAULT]}'

MESSAGE[libxml2,report]='${MESSAGE[libxml2,DEFAULT]}'
MESSAGE[libxml2,get]='${MESSAGE[libxml2,DEFAULT]}'
MESSAGE[libxml2,configure]='${MESSAGE[libxml2,DEFAULT]}'
MESSAGE[libxml2,make]='${MESSAGE[libxml2,DEFAULT]}'
MESSAGE[libxml2,install]='${MESSAGE[libxml2,DEFAULT]}'
MESSAGE[libxml2,complete]='${MESSAGE[libxml2,DEFAULT]}'
MESSAGE[libxml2,clean]='${MESSAGE[libxml2,DEFAULT]}'

MESSAGE[hdf5,report]='${MESSAGE[hdf5,DEFAULT]}'
MESSAGE[hdf5,get]='${MESSAGE[hdf5,DEFAULT]}'
MESSAGE[hdf5,configure]='${MESSAGE[hdf5,DEFAULT]}'
MESSAGE[hdf5,make]='${MESSAGE[hdf5,DEFAULT]}'
MESSAGE[hdf5,install]='${MESSAGE[hdf5,DEFAULT]}'
MESSAGE[hdf5,complete]='${MESSAGE[hdf5,DEFAULT]}'
MESSAGE[hdf5,clean]='${MESSAGE[hdf5,DEFAULT]}'

MESSAGE[fftw,report]='${MESSAGE[fftw,DEFAULT]}'
MESSAGE[fftw,get]='${MESSAGE[fftw,DEFAULT]}'
MESSAGE[fftw,configure]='${MESSAGE[fftw,DEFAULT]}'
MESSAGE[fftw,make]='${MESSAGE[fftw,DEFAULT]}'
MESSAGE[fftw,install]='${MESSAGE[fftw,DEFAULT]}'
MESSAGE[fftw,complete]='${MESSAGE[fftw,DEFAULT]}'
MESSAGE[fftw,clean]='${MESSAGE[fftw,DEFAULT]}'

MESSAGE[qdpxx,report]='${MESSAGE[qdpxx,DEFAULT]}'
MESSAGE[qdpxx,get]='${MESSAGE[qdpxx,DEFAULT]}'
MESSAGE[qdpxx,configure]='${MESSAGE[qdpxx,DEFAULT]}'
MESSAGE[qdpxx,make]='${MESSAGE[qdpxx,DEFAULT]}'
MESSAGE[qdpxx,install]='${MESSAGE[qdpxx,DEFAULT]}'
MESSAGE[qdpxx,complete]='${MESSAGE[qdpxx,DEFAULT]}'
MESSAGE[qdpxx,clean]='${MESSAGE[qdpxx,DEFAULT]}'

MESSAGE[qdpxx_single,report]='${MESSAGE[qdpxx_single,DEFAULT]}'
MESSAGE[qdpxx_single,get]='${MESSAGE[qdpxx_single,DEFAULT]}'
MESSAGE[qdpxx_single,configure]='${MESSAGE[qdpxx_single,DEFAULT]}'
MESSAGE[qdpxx_single,make]='${MESSAGE[qdpxx_single,DEFAULT]}'
MESSAGE[qdpxx_single,install]='${MESSAGE[qdpxx_single,DEFAULT]}'
MESSAGE[qdpxx_single,complete]='${MESSAGE[qdpxx_single,DEFAULT]}'
MESSAGE[qdpxx_single,clean]='${MESSAGE[qdpxx_single,DEFAULT]}'

MESSAGE[quda,report]='${MESSAGE[quda,DEFAULT]}'
MESSAGE[quda,get]='${MESSAGE[quda,DEFAULT]}'
MESSAGE[quda,configure]='${MESSAGE[quda,DEFAULT]}'
MESSAGE[quda,make]='${MESSAGE[quda,DEFAULT]}'
MESSAGE[quda,install]='${MESSAGE[quda,DEFAULT]}'
MESSAGE[quda,complete]='${MESSAGE[quda,DEFAULT]}'
MESSAGE[quda,clean]='${MESSAGE[quda,DEFAULT]}'

MESSAGE[qphix,report]='${MESSAGE[qphix,DEFAULT]}'
MESSAGE[qphix,get]='${MESSAGE[qphix,DEFAULT]}'
MESSAGE[qphix,configure]='${MESSAGE[qphix,DEFAULT]}'
MESSAGE[qphix,make]='${MESSAGE[qphix,DEFAULT]}'
MESSAGE[qphix,install]='${MESSAGE[qphix,DEFAULT]}'
MESSAGE[qphix,complete]='${MESSAGE[qphix,DEFAULT]}'
MESSAGE[qphix,clean]='${MESSAGE[qphix,DEFAULT]}'

MESSAGE[chroma,report]='${MESSAGE[chroma,DEFAULT]}'
MESSAGE[chroma,get]='${MESSAGE[chroma,DEFAULT]}'
MESSAGE[chroma,configure]='${MESSAGE[chroma,DEFAULT]}'
MESSAGE[chroma,make]='${MESSAGE[chroma,DEFAULT]}'
MESSAGE[chroma,install]='${MESSAGE[chroma,DEFAULT]}'
MESSAGE[chroma,complete]='${MESSAGE[chroma,DEFAULT]}'
MESSAGE[chroma,clean]='${MESSAGE[chroma,DEFAULT]}'

MESSAGE[chroma_single,report]='${MESSAGE[chroma_single,DEFAULT]}'
MESSAGE[chroma_single,get]='${MESSAGE[chroma_single,DEFAULT]}'
MESSAGE[chroma_single,configure]='${MESSAGE[chroma_single,DEFAULT]}'
MESSAGE[chroma_single,make]='${MESSAGE[chroma_single,DEFAULT]}'
MESSAGE[chroma_single,install]='${MESSAGE[chroma_single,DEFAULT]}'
MESSAGE[chroma_single,complete]='${MESSAGE[chroma_single,DEFAULT]}'
MESSAGE[chroma_single,clean]='${MESSAGE[chroma_single,DEFAULT]}'


unset LIBTOOL AUTOHEADER ACLOCAL AUTOMAKE AUTOCONF AUTORECONF AUTOTOOLS MAKE
LIBTOOL="libtoolize"
AUTOHEADER="autoheader"
ACLOCAL="aclocal"
AUTOMAKE="automake --add-missing"
AUTOCONF="autoconf"
AUTORECONF="autoreconf -f"
AUTOTOOLS='touch ChangeLog; $LIBTOOLIZE; $AUTOHEADER ; $ACLOCAL ; $AUTOMAKE; $AUTOMAKE; $AUTOCONF ; $AUTORECONF; $LIBTOOLIZE; $AUTOHEADER ; $ACLOCAL ; $AUTOMAKE; $AUTOMAKE; $AUTOCONF ; $AUTORECONF'
MAKE="make -j 10 "