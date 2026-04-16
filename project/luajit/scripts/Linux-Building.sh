#!/bin/bash

ARCH=${1:-x64}

if [ "$ARCH" = "x86" ]; then
    MARCH="i686"
elif [ "$ARCH" = "arm64" ]; then
    MARCH="armv8-a"
elif [ "$ARCH" = "armv7" ]; then
    MARCH="armv7-a+simd"
else
    MARCH="x86-64"
fi

if [ -d "LuaJIT" ]; then
    cd LuaJIT
    git checkout v2.1
    git pull origin v2.1
else
    git clone https://github.com/LuaJIT/LuaJIT.git -b v2.1 --depth 1
    cd LuaJIT
fi

mkdir -p build/$ARCH
mkdir -p build/$ARCH/include

if command -v nproc &> /dev/null; then
    JOBS=$(nproc)
elif command -v sysctl &> /dev/null; then
    JOBS=$(sysctl -n hw.ncpu)
else
    JOBS=4
fi

make clean
make -j$JOBS TARGET_FLAGS="-march=$MARCH"
cp src/libluajit.a build/$ARCH/libluajit.a

cp src/{lua.hpp,lauxlib.h,lua.h,luaconf.h,lualib.h,luajit.h} build/$ARCH/include

rm -f *.o

cd ..
