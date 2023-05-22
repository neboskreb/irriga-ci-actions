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

if [ ! -f conanfile.py ]; 
then
    echo "FATAL: conanfile not found in $WORKDIR" >&2
    exit 3
fi


# Extract the required information
LIBRARY=$(sed -n "s/^.*name.*=.*\"\(.*\)\"/\1/p" conanfile.py)
if [ ! $LIBRARY ]
then
    echo "FATAL: library name not detected in conanfile.py" >&2
    exit 4
fi	

echo "INFO: Library name detected in conanfile.py: $LIBRARY" >&2

# Return the results (GitHub picks it up from stdout)
echo "cmake_found=True"
echo "conan_found=True"
echo "library=$LIBRARY"
