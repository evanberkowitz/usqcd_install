BASE=$HOME/USQCD
STACK="qmp qdpxx chroma"

# We used apt-get to install
# libxml2-dev
# hdf5-dev
# hdf5-utils
# autoconf
# autotools

INSTALL[libxml2]=/usr
INSTALL[hdf5]=/usr/lib/mpich

# It took a little while to figure out that ubuntu's apt-get didn't install all the HDF5 things into /some/folder/to/hdf5/{lib,include} but rather (at least if you use mpich)
# hides them in other places.  This is why we explicitly add the -I/usr/include/hdf5/mpich to the flags.

export CC=/usr/bin/mpicc
C_FLAGS[DEFAULT]="-O3 -march=broadwell -fpermissive -fopenmp -I/usr/include/hdf5/mpich"

export CXX=/usr/bin/mpicxx
CXX_FLAGS[DEFAULT]="-O3 -std=c++11 -march=broadwell -ffast-math -funroll-all-loops -fpermissive -fopenmp -I/usr/include/hdf5/mpich"

# No zmuldefs.
LD_FLAGS[chroma]='${LD_FLAGS[DEFAULT]}'
LD_FLAGS[chroma_single]='${LD_FLAGS[DEFAULT]}'

LD_FLAGS[qdpxx]+=' -L/usr/lib/mpich/lib '

