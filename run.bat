@Echo off
rem //autor  : Nomiram 
rem //version: 2.3 

rem для работы необходимо добавить папки с необходимыми инструментами в Path
rem или указать путь в специальных местах для этого ниже
  
rem на вход подается полный путь до файла с кодом С/С++/python/AutoHotKey/WBS/JScript/Golang/GPSSh
rem работает с компилятором MinGW g++ или с python 3+
rem работает с расширениями py/pyw/cpp/cxx/c/csc/bat/js/ahk/go/gpss
rem %1 - полный путь до файла

rem установка кодировки windows 1251
chcp 1251 >nul
if '%1' EQU '' GOTO error
rem TEMP PROJECTS
if not '%~x1' == '.gps' goto trypy
gpssh.exe %1
notepad++ "%~dp1\%~n1.lis"
REM GOTO endOfPrgrm
exit
rem try find .py .pyw
rem if (%~x1 != .py OR %~x1 != .pyw) goto trycpp
:trypy
if not '%~x1' EQU '.py' if not '%~x1' EQU '.pyw' GOTO trycpp
rem cd /D"C:\python\" rem путь до интерпретатора
title %~nx1
rem запуск программы
cd /D %~dp1
@Echo on
python %1
@REM python %~nx1
@Echo off
IF "%ERRORLEVEL%" NEQ "0" GOTO compilationerror
GOTO endOfPrgrm
rem try find .cpp .cxx .c
:trycpp
if not '%~x1' == '.cpp' if not '%~x1' EQU '.cxx' if not '%~x1' EQU '.c' if not '%~x1' EQU '.cc' GOTO tryGolang

rem cd "C:\MinGW\bin\" 
rem путь до компилятора
rem необходимо добавить флаг -lgdi32 , чтобы работали функции windows.h
REM Precompiler output
REM g++.exe %1 -E -o "%~dp1\%~n1"
@Echo on
g++.exe %1 -o "%~dp1\%~n1.exe" -static-libgcc -static-libstdc++ -lgdi32 -lcomdlg32 -std=c++1z
@Echo off
IF "%ERRORLEVEL%" NEQ "0" GOTO compilationerror
goto cppsuccess

rem Golang
:tryGolang
if not '%~x1' == '.go' if not '%~x1' EQU '.GO' if not '%~x1' EQU '.Go' if not '%~x1' EQU '.cc' GOTO tryVBS
cd /D "%~dp1"
@Echo on
go.exe run %1
@Echo off
IF "%ERRORLEVEL%" NEQ "0" GOTO compilationerror
goto endOfPrgrm
REM run scripts: vbs, js, ahk, bat
:tryVBS
if not '%~x1' == '.vbs' if not '%~x1' == '.js' if not '%~x1' == '.ahk' if not '%~x1' == '.bat' GOTO tryCsc
@Echo on
start "" /b %1 
@Echo off
IF "%ERRORLEVEL%" NEQ "0" GOTO compilationerror
exit
GOTO endOfPrgrm
REM C#
:tryCsc
if not '%~x1' == '.cs' if not '%~x1' == '.CS' if not '%~x1' == '.csc' if not '%~x1' == '.CSC' GOTO typeerr
cd /D "%~dp1"
csc.exe %1
REM Стандартные места для csc.exe:
REM C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe %1
REM C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe /target:winexe %1
IF "%ERRORLEVEL%" NEQ "0" GOTO compilationerror
:cppsuccess
cd /D "%~dp1"
@Echo Для запуска программы нажмите любую клавишу. . .
PAUSE>nul 
cls
title %~n1.exe
"%~dpn1.exe"
:endOfPrgrm
@Echo.
@Echo Программа %~1 завершена
@Echo Для выхода из консоли нажмите любую клавишу . . .
@PAUSE >nul
exit
:error
Echo Необходимо передать имя файла первым параметром
set /P filein=Введите полный путь до файла : 
echo '%filein%'
call %0 %filein%
pause
exit
:compilationerror
@Echo Ошибка компиляции %ERRORLEVEL%
@Echo Для выхода из консоли нажмите любую клавишу . . .
PAUSE >nul
exit
:typeerr
@Echo тип файла должен быть py/pyw/cpp/cxx/c/csc/bat/js/ahk/go/gpss
@Echo ваш файл "%~nx1" 
@Echo Для выхода из консоли нажмите любую клавишу . . .
PAUSE >nul
exit
