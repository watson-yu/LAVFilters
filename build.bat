@ECHO OFF

for /f "usebackq tokens=*" %%i in (`call "%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -requires Microsoft.Component.MSBuild -property installationPath`) do (
  set vsInstallDir=%%i
)

set "VSCMD_START_DIR=%CD%"
call "%VSInstallDir%\Common7\Tools\VsDevCmd.bat" -no_logo -arch=x86 > NUL

sh build_ffmpeg.sh x86 || EXIT /B 1
MSBuild.exe LAVFilters.sln /nologo /m /t:Rebuild /property:Configuration=Release;Platform=Win32
IF ERRORLEVEL 1 EXIT /B 1

sh build_ffmpeg.sh x64 || EXIT /B 1
MSBuild.exe LAVFilters.sln /nologo /m /t:Rebuild /property:Configuration=Release;Platform=x64
IF ERRORLEVEL 1 EXIT /B 1

PAUSE
