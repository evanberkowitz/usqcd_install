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