#!/bin/sh
#
#     i686-elf-gcc cross compiler build script
#     Copyright (C) 2017  k4m1 ( k4m1@protonmail.com )
# 
#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
# 
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
# 
#     You should have received a copy of the GNU General Public License
#     along with this program. If not, see <http://www.gnu.org/licenses/>.


command -v gmake >/dev/null 2>&1 || {
	echo "Gnu make required!";
	echo "Gnu make can be downloaded from: ";
	echo "    https://www.gnu.org/software/make/ ";
	exit 1;
}

command -v gcc >/dev/null 2>&1 || { 
	echo "Gnu C Compiler required!"; 
	echo "Gnu C Compiler can be downloaded from:"; 
	echo "   https://www.gnu.org/software/gcc/"; 
	exit 1; 
}

command -v tar >/dev/null 2>&1 || { 
	"tar required!"; 
	echo "tar can be downloaded from: https://www.gnu.org/software/tar/"; 
	exit 1; 
}

command -v wget >/dev/null 2>&1 || { 
	"wget required!"; 
	echo "wget can be downloaded from https://www.gnu.org/software/wget"; 
	exit 1; 
}

command -v sudo >/dev/null 2>&1 || { 
	"sudo not installed, modify the script and run make install-gcc 
	and make install-target-libgcc manually"; 
	exit 1;
} 



# binutils and gcc version
export BINUTILS_VERSION="2.29"
export GCC_VERSION="7.2.0"

export PREFIX="$HOME/opt/cross"
export TARGET=mips-elf
export PATH="$PREFIX/bin:$PATH"

echo "Obtaining binutils and gcc..."

wget ftp://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.gz
wget ftp://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz

echo "Unpacking binutils and gcc..."

tar -xf binutils-$BINUTILS_VERSION.tar.gz
tar -xf gcc-$GCC_VERSION.tar.gz

echo "Obtainig gcc download prerequisities..."
cd gcc-$GCC_VERSION
./contrib/download_prerequisites
cd ../

echo "Configuring and building binutils..."
cd binutils-$BINUTILS_VERSION
mkdir -pv build
cd build
../configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
gmake
gmake install
cd ../../

echo "Configuring and building $TARGET-gcc..."
cd gcc-$GCC_VERSION
mkdir -pv build
cd build
../configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c --without-headers
gmake all-gcc
gmake all-target-libgcc
sudo gmake install-gcc
sudo gmake install-target-libgcc

echo "Cleaning up..."
cd ../../
rm -rf binutils-$BINUTILS_VERSION*
rm -rf gcc-$GCC_VERSION*


