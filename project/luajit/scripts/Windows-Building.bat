@echo off

set ARCH=%1
if "%ARCH%"=="" set ARCH=x86_64

if exist LuaJIT (
    cd LuaJIT
    git checkout v2.1
    git pull origin v2.1
) else (
    git clone https://github.com/ShadowEngineTeam/LuaJIT.git -b v2.1 --depth 1
    cd LuaJIT
)

if not exist build (
    mkdir build
)

if not exist build\%ARCH% (
    mkdir build\%ARCH%
)

if not exist build\%ARCH%\include (
    mkdir build\%ARCH%\include
)

cd src

call msvcbuild.bat static %ARCH%

cd ..

xcopy /Y /Q src\lua51.lib build\%ARCH%\*
xcopy /Y /Q src\lua.hpp build\%ARCH%\include\*
xcopy /Y /Q src\lauxlib.h build\%ARCH%\include\*
xcopy /Y /Q src\lua.h build\%ARCH%\include\*
xcopy /Y /Q src\luaconf.h build\%ARCH%\include\*
xcopy /Y /Q src\lualib.h build\%ARCH%\include\*
xcopy /Y /Q src\luajit.h build\%ARCH%\include\*

cd ..
