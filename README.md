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



### LICENSE

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