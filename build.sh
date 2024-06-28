#!/bin/bash -e

: ${CMAKE:=cmake}
: ${CHECK:=false}
: ${INTEGRATION:=true}

${CMAKE} --version

if [ "$1" = Debug -o "$1" = debug ] ; then
    shift
    CFG="-DCMAKE_BUILD_TYPE=Debug $*"
else
    CFG=$*
fi

if [[ "$CHECK" == "true" ]]; then
  CFG="-DLINT=ON $CFG"
fi

if [[ ! -d build ]]
then
  mkdir build
fi

cd build
${CMAKE} .. ${CFG}
make -j$(nproc)
make -j$(nproc) unittests
make test
if [[ "$INTEGRATION" == "true" ]]; then
  make integration
fi

echo
echo 'Everything looks good, you can install via "make install -C build".'
