#!/usr/local/bin/bash

if [[ ! $BASH_VERSINFO -gt 3 ]]; then
    # Your preferred bash must have associative arrays, or LOTS of things will fail.
    # Practically speaking, this means you need bash version 4 or later.
    echo "bash version 4+ required."
    exit -1
fi

MACHINE=$1
LIBRARY=$2
ACTION=$3

this_script=$0
script_folder=${this_script%/*}
source ${script_folder}/machines/$MACHINE.sh    # Read the user options, as some are needed for
source ${script_folder}/machines/default.sh     # the default settings
source ${script_folder}/machines/$MACHINE.sh    # after which, the user can over-ride the defaults

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

function UNQUOTE {
    s="$*"
    while [[ "$s" != "$(eval echo \"$s\")" ]]; do
        s="$(eval echo \"$s\")"
    done
    echo "$s"
}

function PROMPT_USER {
    prompt="$1"
    if [[ 2 == $# ]]; then
        prompt+=" [$2]"
    fi
    read -p "$prompt " response
    if [[ -z "$response" ]]; then
        response="$2";
    fi
    echo $response
}

if [[ "all" == "$LIBRARY" ]]; then
    for library in $(UNQUOTE $STACK); do
        $this_script $MACHINE $library $ACTION
        if [[ $status -ne 0 ]]; then
            echo ... failed; exit 1;
        fi
    done
    exit
fi

needed=""
for library in $(UNQUOTE $STACK); do
    if [[ "$LIBRARY" == "$library" ]]; then
        needed="yes"
    fi
done
if [[ -z "$needed" ]]; then
    echo "$LIBRARY is not needed according to your STACK: $(UNQUOTE $STACK)"
    exit
fi


for folder in SOURCE BUILD INSTALL LOG; do
    mkdir -p $(UNQUOTE "${DIR[$folder]}")
done
for folder in BUILD INSTALL LOG; do
    mkdir -p $(UNQUOTE "\${$folder[$LIBRARY]}")
done

case $ACTION in
    get)
        if [[ -d "$(UNQUOTE ${SOURCE[$LIBRARY]})" ]]; then
            echo "Directory exists: $(UNQUOTE ${SOURCE[$LIBRARY]})"
            overwrite=$(PROMPT_USER "Overwrite?" "NO")
            if [[ "$overwrite" =~ ^[yY]*$ ]]; then
                if [[ "/" != "$(UNQUOTE ${SOURCE[$LIBRARY]})" ]]; then
                    rm -rf "$(UNQUOTE ${SOURCE[$LIBRARY]})"
                else
                    echo "Come on now... you don't really want to rm -rf /, right?"
                    exit -1;
                fi
            else
                echo "OK, not overwriting existing source directory."
                exit;
            fi
        fi
        echo "###"
        echo "### GETTING $LIBRARY"
        echo "###"
        # echo "        tail -f $(UNQUOTE ${LOG[$LIBRARY]})/get.log"
        # echo "$(UNQUOTE ${GET[$LIBRARY]})"
        eval "$(UNQUOTE ${GET[$LIBRARY]}) > $(UNQUOTE ${LOG[$LIBRARY]})/get.log 2>&1"
        ;;
    configure)
        echo "###"
        echo "### AUTOTOOLS $LIBRARY"
        echo "###"
        
        if [[ "quda" == "$LIBRARY" ]]; then
            echo "QUDA is annoying"; return;
        fi
        
        for olib in $(UNQUOTE ${OTHER_LIBS[$LIBRARY]}); do
            if [[ ! -d "$(UNQUOTE ${SOURCE[$LIBRARY]}/$olib)" ]]; then continue; fi
            echo "Autotools: $olib"
            sanitized=${olib##*/}
            echo "        tail -f $(UNQUOTE ${LOG[$LIBRARY]})/autotools.$sanitized.log"
            pushd $(UNQUOTE ${SOURCE[$LIBRARY]}/$olib)
            eval "($AUTOTOOLS) > $(UNQUOTE ${LOG[$LIBRARY]})/autotools.$sanitized.log 2>&1"
            popd

        done 
        
        echo "Autotools: $LIBRARY";
        echo "        tail -f $(UNQUOTE ${LOG[$LIBRARY]})/autotools.$LIBRARY.log"
        pushd $(UNQUOTE ${SOURCE[$LIBRARY]})
        eval "($AUTOTOOLS) > $(UNQUOTE ${LOG[$LIBRARY]})/autotools.$LIBRARY.log 2>&1" #> "$(UNQUOTE ${LOG[$LIBRARY]})/autotools.$LIBRARY.log"
        popd
        
        pushd $(UNQUOTE "${BUILD[$LIBRARY]}")

        echo "###"
        echo "### CONFIGURING $LIBRARY"
        echo "###"

        echo "================================================"
        
        echo "CC        $CC"
        echo "          $($CC --version | head -n 1)"
        echo "CXX       $CXX"
        echo "          $($CXX --version | head -n 1)"
        echo "CFLAGS    $(UNQUOTE ${C_FLAGS[$LIBRARY]})"
        echo "CXXFLAGS  $(UNQUOTE ${CXX_FLAGS[$LIBRARY]})"
        echo "HOST      $HOST"
        echo "FFTW      $(UNQUOTE ${INSTALL[fftw]})"    #TODO: replace with a loop over the stack.
        echo "HDF5      $(UNQUOTE ${INSTALL[hdf5]})"    #TODO: replace with a loop over the stack.
        
        echo "================================================"
        
        echo "CC=\"$CC\" CFLAGS=\"$(UNQUOTE "${C_FLAGS[$LIBRARY]}")\" CXX=\"$CXX\" CXXFLAGS=\"$(UNQUOTE "${CXX_FLAGS[$LIBRARY]}")\" $(UNQUOTE "${CONFIGURE[$LIBRARY]} ${CONFIG_FLAGS[$LIBRARY]}")"
        echo ""
        echo "        tail -f $(UNQUOTE ${LOG[$LIBRARY]})/configure.log"
        eval "CC=\"$CC\" CFLAGS=\"$(UNQUOTE "${C_FLAGS[$LIBRARY]}")\" CXX=\"$CXX\" CXXFLAGS=\"$(UNQUOTE "${CXX_FLAGS[$LIBRARY]}")\" $(UNQUOTE "${CONFIGURE[$LIBRARY]} ${CONFIG_FLAGS[$LIBRARY]}") > $(UNQUOTE ${LOG[$LIBRARY]})/configure.log 2>&1" 
        if [[ $status -ne 0 ]]; then
            echo ... failed; exit 1;
        fi
        popd
        ;;
    make) 
        echo "###"
        echo "### COMPILING $LIBRARY"
        echo "###"
        echo "        tail -f $(UNQUOTE ${LOG[$LIBRARY]})/make.log"
        
        pushd $(UNQUOTE "${BUILD[$LIBRARY]}")
        MAKE_LOG="$(UNQUOTE ${LOG[$LIBRARY]})/make.log"
        $MAKE > $MAKE_LOG 2>&1
        if [[ $status -ne 0 ]]; then
            echo ... failed; exit 1;
        fi
        popd
        ;;
    install)
        if [[ ! -d $(UNQUOTE "${BUILD[$LIBRARY]}") ]]; then
            echo "Build first."
            exit
        fi
        echo "###"
        echo "### INSTALLING $LIBRARY"
        echo "###"
        echo "        tail -f $(UNQUOTE ${LOG[$LIBRARY]})/install.log"
        pushd $(UNQUOTE "${BUILD[$LIBRARY]}")
        $MAKE install > "$(UNQUOTE ${LOG[$LIBRARY]})/install.log" 2>&1
        if [[ $status -ne 0 ]]; then
            echo ... failed; exit 1;
        fi
        popd
        ;;
    report)
        echo "###"
        echo "### REPORT ON $LIBRARY"
        echo "###"
        echo "================================================"
        echo "SOURCE        $(UNQUOTE ${SOURCE[$LIBRARY]})"
        echo "BUILD         $(UNQUOTE ${BUILD[$LIBRARY]})"
        echo "INSTALL       $(UNQUOTE ${INSTALL[$LIBRARY]})"
        echo "LOG           $(UNQUOTE ${LOG[$LIBRARY]})"
        
        echo "GET           $(UNQUOTE ${GET[$LIBRARY]})"
        echo "CONFIGURE     $(UNQUOTE ${CONFIGURE[$LIBRARY]})"
        echo "CONFIG_FLAGS  $(UNQUOTE ${CONFIG_FLAGS[$LIBRARY]})"
        
        echo "CC            $CC"
        echo "              $($CC --version | head -n 1)"
        echo "C_FLAGS       $(UNQUOTE ${C_FLAGS[$LIBRARY]})"
        echo ""
        echo "CXX           $CXX"
        echo "              $($CXX --version | head -n 1)"
        echo "CXX_FLAGS     $(UNQUOTE ${CXX_FLAGS[$LIBRARY]})"
        echo ""
        echo "HOST      $HOST"
        # echo "FFTW      $(UNQUOTE ${INSTALL[fftw]})"    #TODO: replace with a loop over the stack.
        # echo "HDF5      $(UNQUOTE ${INSTALL[hdf5]})"    #TODO: replace with a loop over the stack.
        
        echo "================================================"
        
        ;;
    complete)
        for action in get configure make install; do
            #echo "$this_script $settings $LIB $action"
            $this_script $MACHINE $LIBRARY $action
            status=$?
            if [[ $status -ne 0 ]]; then
                echo ... failed; exit 1;
            fi
        done ;
        exit ;;
    *)
    echo "Unknown action $ACTION"; exit 1;;
esac