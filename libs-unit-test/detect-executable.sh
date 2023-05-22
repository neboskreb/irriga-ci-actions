#!/bin/bash


if ! cd $1;
then
    echo "FATAL: Directory not found $1" >&2
    exit 1
fi
WORKDIR=$(pwd)
echo "INFO: Working directory $WORKDIR" >&2


# Assert the required files exist
if [ ! -f CMakeLists.txt ]; 
then
    echo "FATAL: CMakeLists.txt not found in $WORKDIR" >&2
    exit 2
fi

if [ ! -f conanfile.py ] && [ ! -f conanfile.txt ]; 
then
    echo "FATAL: conanfile not found in $WORKDIR" >&2
    exit 3
fi


# Extract the required information
EXECUTABLE=$(sed -n "s/^.*project(\(.*\))/\1/p" CMakeLists.txt)
if [ ! $EXECUTABLE ]
then
    echo "FATAL: executable name not detected in CMakeLists.txt" >&2
    exit 4
fi	

echo "INFO: Executable name detected in CMakeLists.txt: $EXECUTABLE" >&2

# Return the results (GitHub picks it up from stdout)
echo "cmake_found=True"
echo "conan_found=True"
echo "executable=$EXECUTABLE"
