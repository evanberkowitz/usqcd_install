#!/bin/bash
# Installer suite for USQCD and related packages.
# Copyright (C) 2016  Evan Berkowitz


if [[ ! ${BASH_VERSINFO[0]} -gt 3 ]]; then
    # Your preferred bash must have associative arrays, or LOTS of things will fail.
    # Practically speaking, this means you need bash version 4 or later.
    echo "bash version 4+ required."
    exit -1
fi

if [[ "1" == "$#" && "license" == "$1" ]]; then
    echo "usqcd.sh
    Installer suite for USQCD and related packages.
    Copyright (C) 2016  Evan Berkowitz

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>."
    exit
fi

if [[ ! "3" == "$#" ]]; then
    help="true"
fi

if [[ "help" == "$1" || "help" == "$2" || "help" == "$3" || "-h" == "$1" || "-h" == "$2" || "-h" == "$3" ]]; then
    help="true"
fi

if [[ ! -z "$help" ]]; then
    echo "usqcd.sh"
    echo "  Installer suite for USQCD and related packages."
    echo "  Copyright (C) 2016  Evan Berkowitz"
    echo ""
    
    echo "  Exactly 3 arguments are required MACHINE LIBRARY ACTION"
    echo "  MACHINE is one of the files in the machine directory, without the .sh"
    echo "  LIBRARY is one of the software packages specified in the STACK variable in the machine file."
    echo "  ACTION  is one of"
    echo "    report      Report information relevant to the LIBRARY."
    echo "    get         Go get the package."
    echo "    configure   Prepare to complile."
    echo "    make        Compile."
    echo "    install     Install."
    echo "    complete    get, configure, make, and install."
            
    echo "  Instead of the three mandatory arguments, you can"
    echo "    usqcd.sh help           to see this help information."
    echo "    usqcd.sh license        to see licensing information."
    
    exit
fi

MACHINE=$1
LIBRARY=$2
ACTION=$3

script_folder=$(unset CDPATH && cd "$(dirname "$0")" && echo $PWD)
this_script=${script_folder}/usqcd.sh

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

function DELETE_FOLDER {
    target="$1"
    if [[ "/" != "$target" ]]; then
        rm -rf "$target"
    else
        echo "Come on now... you don't really want to rm -rf /, right?"
        exit -1;
    fi
    
}

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

if [[ ! -f ${script_folder}/machines/$MACHINE.sh ]]; then
    echo "Machine file not found: ${script_folder}/machines/$MACHINE.sh"
    suggestions="$(find ${script_folder}/machines -type file)"
    suggestions=${suggestions//${script_folder}\/machines\//}
    suggestions=${suggestions//.sh/}
    
    pattern="-e \"$MACHINE\" -e \""
    pattern+=$(echo "${MACHINE}" | awk -F'/' '{OFS="\" -e \""; $0=$0 } {$1=$1 ; print $0 }')\"
    
    suggestions="$(eval "echo \"${suggestions}\" | grep $pattern")"

    if [[ ! -z "${suggestions}" ]]; then
        echo ""
        echo "You might be looking for one of these:"
        for i in $(echo "${suggestions}"); do
            echo "    ${i}"
        done
        echo ""
    fi
    
    exit 1
fi

source ${script_folder}/machines/$MACHINE.sh    # Read the user options, as some are needed for
source ${script_folder}/machines/default.sh     # the default settings
source ${script_folder}/machines/$MACHINE.sh    # after which, the user can over-ride the defaults

if [[ "stack" == "$LIBRARY" ]]; then
    for library in $(UNQUOTE $STACK); do
        $this_script $MACHINE $library $ACTION
        status=$?
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

if [[ "report" != "$ACTION" ]]; then
    # Put the machine file in the installation directory.
    eval "cp ${script_folder}/machines/$MACHINE.sh $(UNQUOTE ${DIR[INSTALL]})"
fi

for folder in BUILD INSTALL LOG; do
    mkdir -p $(UNQUOTE "\${$folder[$LIBRARY]}")
done

case $ACTION in
    get)
        echo "###"
        echo "### GETTING $LIBRARY"
        echo "###"
        if [[ -d "$(UNQUOTE ${SOURCE[$LIBRARY]})" ]]; then
            echo "Directory exists: $(UNQUOTE ${SOURCE[$LIBRARY]})"
            overwrite=$(PROMPT_USER "Overwrite?" "NO")
            if [[ "$overwrite" =~ ^[yY]*$ ]]; then
                DELETE_FOLDER "$(UNQUOTE ${SOURCE[$LIBRARY]})"
            else
                echo "OK, not overwriting existing source directory."
                exit;
            fi
        fi
        echo "        tail -f $(UNQUOTE ${LOG[$LIBRARY]})/get.log"
        eval "$(UNQUOTE ${GET[$LIBRARY]}) > $(UNQUOTE ${LOG[$LIBRARY]})/get.log 2>&1"
        
        echo "$(UNQUOTE "${MESSAGE[$LIBRARY,get]}")"
        ;;
    configure)
        echo "###"
        echo "### AUTOTOOLS $LIBRARY"
        echo "###"

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
        eval "($AUTOTOOLS) > $(UNQUOTE ${LOG[$LIBRARY]})/autotools.$LIBRARY.log 2>&1"
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
        for library in $(UNQUOTE $STACK); do
        echo "$library      $(UNQUOTE ${INSTALL[$library]})" | awk '{printf("%-13s %s\n",$1,$2)}'
        done
        
        
        echo "================================================" #
        
        # Add QUDA_LIBS=\"-lquda -lcudart -lcuda\"  ?
        echo "CC=\"$CC\" CFLAGS=\"$(UNQUOTE "${C_FLAGS[$LIBRARY]}")\" CXX=\"$CXX\" CXXFLAGS=\"$(UNQUOTE "${CXX_FLAGS[$LIBRARY]}")\" LIBS=\"$(UNQUOTE "${LIBS[$LIBRARY]}")\" QUDA_LIBS=\"$(UNQUOTE "${QUDA_LIBS[$LIBRARY]}")\" LDFLAGS=\"$(UNQUOTE "${LD_FLAGS[$LIBRARY]}")\" $(UNQUOTE "${CONFIGURE[$LIBRARY]} ${CONFIG_FLAGS[$LIBRARY]}")"
        echo ""
        echo "        tail -f $(UNQUOTE ${LOG[$LIBRARY]})/configure.log"
        eval "CC=\"$CC\" CFLAGS=\"$(UNQUOTE "${C_FLAGS[$LIBRARY]}")\" CXX=\"$CXX\" CXXFLAGS=\"$(UNQUOTE "${CXX_FLAGS[$LIBRARY]}")\" LIBS=\"$(UNQUOTE "${LIBS[$LIBRARY]}")\" QUDA_LIBS=\"$(UNQUOTE "${QUDA_LIBS[$LIBRARY]}")\" LDFLAGS=\"$(UNQUOTE "${LD_FLAGS[$LIBRARY]}")\" $(UNQUOTE "${CONFIGURE[$LIBRARY]} ${CONFIG_FLAGS[$LIBRARY]}") > $(UNQUOTE ${LOG[$LIBRARY]})/configure.log 2>&1" 
        status=$?
        if [[ $status -ne 0 ]]; then
            echo ... failed; exit 1;
        fi
        popd
        
        echo "$(UNQUOTE "${MESSAGE[$LIBRARY,configure]}")"
        ;;
    make) 
        echo "###"
        echo "### COMPILING $LIBRARY"
        echo "###"
        echo "        tail -f $(UNQUOTE ${LOG[$LIBRARY]})/make.log"
        
        pushd $(UNQUOTE "${BUILD[$LIBRARY]}")
        MAKE_LOG="$(UNQUOTE ${LOG[$LIBRARY]})/make.log"
        $MAKE > $MAKE_LOG 2>&1
        status=$?
        if [[ $status -ne 0 ]]; then
            echo ... failed; exit 1;
        fi
        popd
        
        echo "$(UNQUOTE "${MESSAGE[$LIBRARY,make]}")"
        ;;
    install)
        if [[ ! -d $(UNQUOTE "${BUILD[$LIBRARY]}") ]]; then
            echo "Build first."
            exit
        fi
        echo "###"
        echo "### INSTALLING $LIBRARY"
        echo "###"
        if [[ "quda" == "$LIBRARY" ]]; then
            echo "quda is built in the installation directory!"
            exit 0;
        fi
        echo "        tail -f $(UNQUOTE ${LOG[$LIBRARY]})/install.log"
        pushd $(UNQUOTE "${BUILD[$LIBRARY]}")
        $MAKE install > "$(UNQUOTE ${LOG[$LIBRARY]})/install.log" 2>&1
        status=$?
        if [[ $status -ne 0 ]]; then
            echo ... failed; exit 1;
        fi
        popd
        
        echo "$(UNQUOTE "${MESSAGE[$LIBRARY,install]}")"
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
        echo ""
        echo "GET           $(UNQUOTE ${GET[$LIBRARY]})"
        echo ""
        echo "CONFIGURE     $(UNQUOTE ${CONFIGURE[$LIBRARY]})"
        echo "CONFIG_FLAGS  $(UNQUOTE ${CONFIG_FLAGS[$LIBRARY]})"
        echo ""
        echo "CC            $CC"
        echo "              $($CC --version | head -n 1)"
        echo "C_FLAGS       $(UNQUOTE ${C_FLAGS[$LIBRARY]})"
        echo ""
        echo "CXX           $CXX"
        echo "              $($CXX --version | head -n 1)"
        echo "CXX_FLAGS     $(UNQUOTE ${CXX_FLAGS[$LIBRARY]})"
        echo ""
        echo "HOST          $HOST"
        echo ""
        for library in $(UNQUOTE $STACK); do
        echo "$library      $(UNQUOTE ${INSTALL[$library]})" | awk '{printf("%-13s %s\n",$1,$2)}'
        done
        
        echo ""
        echo "LD_LIBRARY_PATH   ${LD_LIBRARY_PATH}"
        echo "================================================"
        
        echo "$(UNQUOTE "${MESSAGE[$LIBRARY,report]}")"
        ;;
    complete)
        for action in get configure make install; do
            $this_script $MACHINE $LIBRARY $action
            status=$?
            if [[ $status -ne 0 ]]; then
                exit 1;
            fi
        done ;
        
        echo "${MESSAGE[$LIBRARY,complete]}"
        exit ;;
    clean)
        for dir in INSTALL BUILD SOURCE; do
            target="$dir[$LIBRARY]"
            target="$(UNQUOTE "\${${target}}")"
            remove=$(PROMPT_USER "Remove $target" "N")
            if [[ "$remove" =~ [yY].* ]]; then 
                DELETE_FOLDER $target; 
            fi
        done ;
        
        echo "$(UNQUOTE "${MESSAGE[$LIBRARY,clean]}")"
        exit ;;
    *)
    echo "Unknown action $ACTION"; exit 1;;
esac
