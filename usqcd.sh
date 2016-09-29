#!/usr/local/bin/bash
# Your preferred bash must have associative arrays, or LOTS of things will fail.
# Practically speaking, this means you need bash version 4 or later.

# USQCD Install Script, by Evan Berkowitz
# for my Mac, as of 2016-07-01
# 2.7 GHz Intel Core i7
# NVIDIA GeForce GT 650M 1024MB
# OS X 10.9.5

if [[ $# -ne 3 ]]; then
    echo "Exactly 3 requirements: settings_file.sh action library"
	echo "action can be one of:"
	echo "    fetch    get the library from the repo"
	echo "    make     configure and build"
	echo "    install  put into the final destination"
	echo "    complete fetch, make, and then install"
	echo "    clean    remove the relevant source, build, log, and install"
	echo "library can be one of:"
	echo "    qmp"
    echo "    libxml2"
	echo "    qdpxx"
	echo "    chroma"
	echo "    all      qmp, libxml2, qdpxx, and then chroma."
	exit
fi

DEFAULT_BRANCH=master
BUILD_FLAG="none"

settings=$1
source $settings
library=$2
action=$3


SOURCE=$BASE/source
BUILD=$BASE/build
LOG=$BASE/log
CONFIG_FLAGS="--prefix=$INSTALL/$library "

mkdir -p $BASE $SOURCE $BUILD $LOG

case $library in
    libxml2) 
            LIB=libxml2                                     ;
            REPO=git://git.gnome.org/libxml2                ;
            if [[ -z "$LIBXML2_BRANCH" ]]; then
                BRANCH=v2.9.4                               ;
            else
                BRANCH=$LIBXML2_BRANCH                      ;
            fi                                              ;
            CONFIG_FLAGS+=" --disable-shared  --without-zlib  --without-python  --without-readline  --without-threads  --without-history  --without-reader  --without-writer  --with-output  --without-ftp  --without-http  --without-pattern  --without-catalog  --without-docbook  --without-iconv  --without-schemas  --without-schematron  --without-modules  --without-xptr  --without-xinclude"                                         ;;
    hdf5)   LIB=hdf5                                        ;
            REPO=foo    ;
            CONFIG_FLAGS+=" --enable-parallel"              ;;
    fftw)   LIB=fftw                                        ;
            REPO=git@github.com:FFTW/fftw3.git              ;
            if [[ -z "$FFTW_BRANCH" ]]; then
                BRANCH=$DEFAULT_BRANCH                      ;
            else
                BRANCH=$FFTW_BRANCH                         ;
            fi                                              ;
            CONFIG_FLAGS+=" --enable-maintainer-mode --enable-fma --enable-omp --enable-threads"
            ;;
    qmp)    LIB=qmp                                         ;
            REPO=git@github.com:usqcd-software/qmp.git      ;
            if [[ -z "$QMP_BRANCH" ]]; then
                BRANCH=$DEFAULT_BRANCH                      ;
            else
                BRANCH=$QMP_BRANCH                          ;
            fi                                              ;
            CONFIG_FLAGS+="--with-qmp-comms-type=MPI --enable-openmp $CONFIG_QMP" ;;
    qdpxx)  LIB=qdpxx                                       ;
            REPO=git@github.com:azrael417/qdpxx.git         ;
            if [[ -z "$QDPXX_BRANCH" ]]; then
                BRANCH=$DEFAULT_BRANCH
            else
                BRANCH=$QDPXX_BRANCH                        ;
            fi                                              ;
            CONFIG_FLAGS+="--with-qmp=$INSTALL/qmp  --with-libxml2=$INSTALL/libxml2 --with-hdf5=${HDF5} --enable-openmp --enable-precision=double --enable-largefile --enable-parallel-io --enable-db-lite --enable-parallel-arch=parscalar $CONFIG_QDPXX" ;;
    qphix)  echo "QPhiX not yet implemented."; 
            echo "It requires icc compilers.";exit          ;
            LIB=qphix                                       ;
            REPO=git@github.com:JeffersonLab/qphix.git      ; 
            CONFIG_FLAGS+="--with-qmp=$INSTALL/qmp --with-qdp++=$INSTALL/qdpxx --enable-parallel-arch=parscalar --enable-clover --enable-soalen=4 --disable-mm-malloc $CONFIG_QPHIX" ;;
    quda)   echo "QUDA not yet implemented"; exit           ;
            LIB=quda                                        ;
            REPO=git@github.com:lattice/quda.git            ; 
            CONFIG_FLAGS+="--with-qmp=$INSTALL/qmp --with-qdp=$INSTALL/qdpxx --with-cuda=/Developer/NVIDIA/CUDA-5.5 --enable-wilson-dirac --enable-clover-dirac --enable-staggered-dirac --enable-twisted-mass-dirac --enable-domain-wall-dirac --enable-numa-affinity --enable-hisq-force --enable-hisq-fatlink --enable-gauge-force --enable-milc-interface $CONFIG_QUDA" ;;
    chroma) LIB=chroma                                      ;
            REPO=git@github.com:JeffersonLab/chroma.git     ; 
            if [[ -z "$CHROMA_BRANCH" ]]; then
                BRANCH=$DEFAULT_BRANCH
            else
                BRANCH=$CHROMA_BRANCH                       ;
            fi                                              ;
            CONFIG_FLAGS+="--with-qmp=$INSTALL/qmp --with-qdp=$INSTALL/qdpxx --enable-openmp --enable-cpp-wilson-dslash $CONFIG_CHROMA" ;
            if [[ "$GPUS" ]]; then
                CONFIG_FLAGS+=" --with-quda=$INSTALL/quda ";
            fi
    all)    for lib in qmp libxml2 qdpxx chroma; do
                echo "$0 $settings $lib $action"
                $0 $settings $lib $action
                status=$?
                if [[ $status -ne 0 ]]; then
                    echo ... failed; exit 1;
                fi
            done ;
			exit ;;
    *)      echo "Unknown library $library"; exit 1;;
esac

SOURCE=$SOURCE/$LIB
BUILD=$BUILD/$LIB
LOG=$LOG/$LIB
INSTALL=$INSTALL/$LIB

mkdir -p $LOG

case $action in
    fetch)
        if [[ -d $SOURCE ]]; then
            rm -rf $SOURCE;
        fi
        echo "###"
        echo "### FETCHING $LIB"
        echo "###"
        git clone --recursive $REPO $SOURCE;
        pushd $SOURCE;
            echo "CHECKING OUT BRANCH $BRANCH"
            git checkout $BRANCH
            echo "Updating submodules.";
            git submodule update --init --recursive;
            for olib in other_libs/*/ other_libs/*/other_libs/*/; do
                if [[ ! -d "$olib" ]]; then continue; fi;
                echo "Autotools: $olib"
                (cd $olib; git checkout master; git pull; git pull;) > $LOG/autotools.$(basename $olib).log 2>&1;
                (cd $olib; libtoolize; autoheader; aclocal; automake --add-missing; automake; autoconf; autoreconf -f;) >>  $LOG/autotools.$(basename $olib).log 2>&1
            done;
            echo "Autotools: $LIB";
            (touch ChangeLog; libtoolize; autoheader ; aclocal ; automake --add-missing; automake --add-missing; autoconf ; autoreconf -f; libtoolize; autoheader ; aclocal ; automake --add-missing; automake --add-missing; autoconf ; autoreconf -f;) > $LOG/autotools.$LIB.log 2>&1
        popd
        ;;
    make) 
        if [[ -d $BUILD ]]; then
            rm -rf $BUILD;
        fi
        echo "###"
        echo "### MAKING $LIB"
        echo "###"
        mkdir -p $BUILD;
        pushd $BUILD;
            echo "Configuring $LIB"

            echo "================================================"
            
            echo "CC        $CC"
            echo "          $($CC --version | head -n 1)"
            echo "CXX       $CXX"
            echo "          $($CXX --version | head -n 1)"
            echo "CFLAGS    $CFLAGS"
            echo "CXXFLAGS  $CXXFLAGS"
            echo "HOST      $HOST"
            echo "FFTW      $FFTW"
            echo "HDF5      $HDF5"
            
            echo "================================================"
            
            echo $SOURCE/configure $CONFIG_FLAGS CC=\"$CC\" CFLAGS=\"$CFLAGS\" CXX=\"$CXX\" CXXFLAGS=\"$CXXFLAGS\" --host=$HOST --build=${BUILD_FLAG}
            $SOURCE/configure $CONFIG_FLAGS CC="$CC" CFLAGS="$CFLAGS" CXX="$CXX" CXXFLAGS="$CXXFLAGS"  --host=$HOST --build=${BUILD_FLAG} > $LOG/configure.log 2>&1
            status=$?
            if [[ $status -ne 0 ]]; then
                echo ... failed; exit 1;
            fi
            echo "Making $LIB"
            make -j $MAKE_JOBS > $LOG/make.log 2>&1
            status=$?
            if [[ $status -ne 0 ]]; then
                echo ... failed; exit 1;
            fi
        popd;
        ;;
    install)
        if [[ ! -d $BUILD ]]; then
            echo "Build first."
            exit 1
        fi
        echo "###"
        echo "### INSTALLING $LIB"
        echo "###"
        pushd $BUILD;
            mkdir -p $INSTALL;
            make install > $LOG/install.log 2>&1;
            status=$?
            if [[ $status -ne 0 ]]; then
                echo ... failed; exit 1;
            fi
        popd;
        ;;
    clean)
        rm -rf $SOURCE $BUILD $INSTALL $LOG 2>/dev/null
        ;;
    complete)
        for action in fetch make install; do
            echo "$0 $settings $LIB $action"
            $0 $settings $LIB $action
            status=$?
            if [[ $status -ne 0 ]]; then
                echo ... failed; exit 1;
            fi
        done ;
		exit ;;
    *)      echo "Unknown action $action"; exit 1;;
esac