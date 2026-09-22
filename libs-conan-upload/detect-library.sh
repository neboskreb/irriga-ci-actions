#!/bin/bash

# Error codes:
# 1 - Work directory not found
# 2 - Conan file not found
# 3 - Command `conan inspect` failed
# 4 - Library name not detected via conan inspect
# 5 - Library version not detected via conan inspect

if ! cd $1;
then
    echo "FATAL: Directory not found $1" >&2
    exit 1
fi
WORKDIR=$(pwd)
echo "INFO: Working directory $WORKDIR" >&2

CONANFILE=${2:-conanfile.py}
if [ ! -f "$CONANFILE" ];
then
    echo "FATAL: conanfile not found: $CONANFILE" >&2
    exit 2
fi

# Extract library name and version using `conan inspect` (matching conan-get-version.bat approach)
CONAN_OUTPUT=$(conan inspect $CONANFILE 2>/dev/null)
if [ $? -ne 0 ]; then
    echo "FATAL: 'conan inspect $CONANFILE' failed in $WORKDIR" >&2
    exit 3
fi


LIBRARY=""
VERSION=""

while IFS= read -r line; do
    read -r key val <<< "$line"
    if [ "$key" == "name:" ]; then
        LIBRARY="$val"
    elif [ "$key" == "version:" ]; then
        VERSION="$val"
    fi
done <<< "$CONAN_OUTPUT"

# Clean up quotes and trailing spaces/carriage returns
LIBRARY=$(echo "$LIBRARY" | tr -d '"' | tr -d '\r' | xargs)
VERSION=$(echo "$VERSION" | tr -d '"' | tr -d '\r' | xargs)

if [ -z "$LIBRARY" ] || [ "$LIBRARY" == "None" ]; then
    echo "FATAL: library name not detected via conan inspect" >&2
    exit 4
fi	

if [ -z "$VERSION" ] || [ "$VERSION" == "None" ]; then
    echo "FATAL: library version not detected via conan inspect" >&2
    exit 5
fi

echo "INFO: Library detected via conan inspect: $LIBRARY/$VERSION" >&2

# Check if version is snapshot or prerelease (matching conan-get-version.bat logic)
IS_SNAPSHOT=False
if [[ "$VERSION" == *-snapshot* ]] || [[ "$VERSION" == *-prerelease* ]]; then
    echo "INFO: Snapshot/Prerelease version is detected" >&2
    IS_SNAPSHOT=True
else
    IS_SNAPSHOT=False
fi

# Return the results (GitHub picks it up from stdout)
echo "library=$LIBRARY"
echo "is_snapshot=$IS_SNAPSHOT"
