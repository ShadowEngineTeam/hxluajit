#!/bin/bash

ARCH=${1:-x86_64}

if [ "$ARCH" = "x86" ]; then
    CC_TARGET="i686-w64-windows-gnu"
    NATIVE_ARCH="i686"
    MTUNE="generic"
elif [ "$ARCH" = "arm64" ]; then
    CC_TARGET="aarch64-w64-windows-gnu"
    NATIVE_ARCH="arm64"
    MTUNE="generic"
else
    CC_TARGET="x86_64-w64-windows-gnu"
    NATIVE_ARCH="x86-64"
    MTUNE="haswell"
fi

if [ -d "LuaJIT" ]; then
    cd LuaJIT
    git checkout v2.1
    git pull origin v2.1
else
    git clone https://github.com/ShadowEngineTeam/LuaJIT.git -b v2.1 --depth 1
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
make -j$JOBS HOST_CC="clang" CC="clang --target=$CC_TARGET" AR="llvm-ar" BUILDMODE=static TARGET_SYS=Windows TARGET_FLAGS="-march=$NATIVE_ARCH -mtune=$MTUNE" CCOPT="-O3 -funroll-loops -fomit-frame-pointer"
cp src/libluajit.a build/$ARCH/libluajit.a

cp src/{lua.hpp,lauxlib.h,lua.h,luaconf.h,lualib.h,luajit.h} build/$ARCH/include

cd ..
