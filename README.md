# usqcd_install
Scripts for installing USQCD software

The philosophy of this script is to make it as easy as possible to compile [currently: my preferred] USQCD software and related software in a variety of environments.

The script is invoked quite simply: `usqcd.sh MACHINE LIBRARY ACTION`

```
MACHINE is one of the files in the machine directory, without the .sh
LIBRARY is one of the software packages specified in the STACK variable in the machine file.
ACTION  is one of
  report      Report information relevant to the LIBRARY.
  get         Go get the package.
  configure   Prepare to complile.
  make        Compile.
  install     Install.
  complete    get, configure, make, and install.
````

There are variables for many imaginable user options that default to values specified in `machine/default.sh`.
This makes it easy to alter the path to, compilation settings for, etc., just one of the libraries or them all at once.

### Table of Contents

- [`usqcd_install`](#usqcd_install)
- [Table of Contents](#table-of-contents)
- [Requirements](#requirements)
- [Machine files](#machine-files)
- [Usage](#usage)
  - [The `get` action](#the-get-action)
- [Configurable Variables](#configurable-variables)
- [License](#license)


### Requirements

The requirements are very basic:
- `bash 4+`:  `usqcd.sh` takes substantial advantage of associative arrays, so the shebang therein must point to a `bash` version 4.0 or later.  The script will refuse to run unless this is satisfied.

The other requirements are due to defaults---in principle you can configure your settings so that they aren't needed.  I struggle to imagine when that would be a good idea.

- `git`:  The default for most libraries is to `git clone` the software locally.
- `curl`: Currently, the default method to get the libxml2 and hdf5 source code.
- `autotools`: `libtoolize`, `autoheader`, `aclocal`, `automake`, `autoconf`, `autoreconf`.
- `make`: For compiling!
- `cmake`: if you want `quda`.
- [github](http://www.github.com) account with an SSH-key, as discussed in the [section on getting source code](#the-get-action).

### Machine files

A machine file is a file that lives in the `machine` directory of this repo.  It is where you specify what kind of software stack you want to compile, and what settings are needed.

Machine files are welcome!  I'm happy to accept pull requests, so as to build up successful scripts for as many machines as possible.  That makes this script more and more useful.

Machine files are bash (they get `source`d), and they can perform arbitrary steps if you want to get more and more clever, or if you have some exceptional scenario you want to handle.  Mostly, you will just use them to set the [configurable variables](#configurable-variables).

### Usage

In its normal usage, exactly three variables are required, so that the script is invoked via

```
./usqcd.sh $MACHINE $LIBRARY $ACTION
```

- `$MACHINE` is one of the files in the machine directory, without the .sh.
- `$LIBRARY` is one of the software packages specified in the STACK variable in the machine file.  Currently recognized target libraries are
    
    - [`qmp`][qmp], the QCD Message Passing layer.
    - [`libxml2`][libxml2], the parser for xml, which is needed for many input files.
    - [`hdf5`][hdf5], which was [hooked into QDP++](https://github.com/azrael417/qdpxx) and makes life nice.
    - [`fftw`][fftw], [EXPERIMENTAL] - not actually hooked into any of the USQCD stack, but is needed for some of the applications I use built on top.
    - [`qdpxx`][qdpxx], which is actually `qdp++`.
    - `qdpxx_single`, a single-precision build of `qdp++`.
    - [`quda`][quda], a library for performing calculations on GPUs.
    - [`qphix`][qphix], a library which provides QCD solvers on Xeon Phi, Xeon, and KNX Intel architectures.
    - [`chroma`][chroma], a library and application suite that provides physics capability.
    - `chroma_single`, a single-precision build of `chroma`.
    
    You may also specify `stack` to indicate you want to do the action for every library specified in the `STACK` variable of the machine file.
    
- `$ACTION`  is what you want to happen:

    - `report`      Report information relevant to the LIBRARY.
    - `get`         Go get the package.
    - `configure`   Prepare to complile.
    - `make`        Compile.
    - `install`     Install.
    - `complete`    get, configure, make, and install.

Instead of the three mandatory arguments, you can

- `usqcd.sh help`           to see help information (which is basically this section of the README.).
- `usqcd.sh license`        to see [licensing information](#license).

#### The `get` action.

The `git` repos are all on github, and the default `GET` methods that use `git` use `ssh` rather than `https`.  Life will be much easier for you if you have a github account and can [use a public key for authentication][github-ssh].  Then, you have two options, you can add

```
Host github.com
    IdentityFile /the/path/to/your_key
```

to `~/.ssh/config`.  Alternatively, you may utter the magic incantation

```
eval `ssh-agent`
ssh-add /the/path/to/your_key
```

before invoking the script.  I made this the default mode of getting source code, because otherwise it is hard to set the script going and walk away.  You can change the `GET` strings at your own option / hazard.

### Configurable Variables

Defaults are found in `machines/default.sh`.   Any variable set there can be overridden in a custom machine file.  

The most widely-reaching is `BASE`.  It is a path to the directory where you want to base your installation.  By default, inside the `$BASE` folder will be four directories `DIR[SOURCE]=$BASE/source` `DIR[BUILD]=$BASE/build` `DIR[INSTALL]=$BASE/install` and `DIR[LOG]=${BASE}/log`, but any of these can be overridden manually and put someplace else.  For example, if you want to put your installation somewhere easily accessible to your collaborators but don't want them fiddling with your source code, you can reassign `DIR[INSTALL]=/some/other/shared/path`.

You also must set the `STACK` variable to be a space-delimited string of libraries you want in your software stack.  Ideally you would put them in compilation order, so that the `stack` special library keyword works.

Many settings are stored in associative arrays like `VARIABLE[library]` where `VARIABLE` indicates the purpose of variable and `library` indicates which library it is for.

The generally useful things to overwrite are:

- `GET[library]`    how to get the source code for `library`.
- `GIT_BRANCH[library]` which branch to check out, if the source is a git repo.  Most are `master` or `devel`, at the recommendation of some USQCD software developers.
- `SOURCE[library]` defaults to `${DIR[SOURCE]}/library`.
- `BUILD[library]` defaults to `${DIR[BUILD]}/library`.
- `LOG[library]` defaults to `${DIR[LOG]}/library`.
- `INSTALL[library]` defaults to `${DIR[INSTALL]}/library`.
- `OTHER_LIBS[library]` a space-delimited list of relative paths from `${SOURCE[library]}` that need configuration before compilation.
- `LIBS[library]` libraries you might need that fall outside the scope of this script.
- `CONFIGURE[library]` the executable/script that configures before compilation.  For most libraries, `${SOURCE[library]}/configure`, but `quda` uses `cmake`.
- `CONFIG_FLAGS` what arguments to pass when invoking `CONFIGURE[library]`.  The defaults differ from library to library, but most are set to something very sensible.  You can modify them with `+=` or over-ride them completely, of course.
- `CXX_FLAGS[library]` defaults to an empty variable `CXX_FLAGS[DEFAULT]` that you should probably set in your machine file.
- `C_FLAGS[library]` similarly defaults to `C_FLAGS[DEFAULT]` which is the empty string unless you specify something in the machine file.
- `QUDA_LIBS[library]` defaults to the empty string, unless `GPUS` is not the empty string, in which case it is `QUDA_LIBS[DEFAULT]='-lquda -lcudart -lcuda'`.
- `LD_FLAGS[library]` defaults to `LD_FLAGS[DEFAULT]` which is empty unless specified by the user.  The exception is `LD_FLAGS[chroma]` which adds some warning-suppression flags that maybe more properly should be in a machine file, but they're very often useful.

Then, there are things you probably shouldn't change.  These perform some of the automatic regeneration of configuration scripts that tend to be unreliable with the distributed USQCD software.  They include `AUTOHEADER`, `ACLOCAL`, `AUTOMAKE`, `AUTOCONF`, `AUTORECONF`, `AUTOTOOLS`.  The two you may want to override are `MAKE="make -j 10"` and `LIBTOOL="libtoolize"` (on a Mac, for example, `libtoolize` is usually the system-installed one to avoid problems, so `brew install libtool` installes `glibtoolize`).


### LICENSE

I would really appreciate it if you would cite

```
@misc{berkowitz.usqcd.installer,
  author = {Berkowitz, Evan},
  title = {\texttt{usqcd_install}},
  year = {2016},
  publisher = {GitHub},
  journal = {GitHub repository},
  howpublished = {\url{https://github.com/evanberkowitz/usqcd_install}},
  commit = {...}
}
```

or drop me an email / buy me a beer at a conference if these scripts made your life easier.  But, the license is GPLv3.0.

```
usqcd.sh
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
```

[qmp]:          https://usqcd-software.github.io/qmp/
[libxml2]:      http://xmlsoft.org/
[hdf5]:         https://support.hdfgroup.org/HDF5/
[fftw]:         http://www.fftw.org/
[qdpxx]:        https://usqcd-software.github.io/qdpxx/
[quda]:         https://github.com/lattice/quda
[qphix]:        http://jeffersonlab.github.io/qphix/
[chroma]:       https://usqcd-software.github.io/Chroma.html
[github-ssh]:   https://help.github.com/articles/generating-an-ssh-key/