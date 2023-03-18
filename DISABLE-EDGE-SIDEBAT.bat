:: 集成by kdXiaoyi
:::: HOME PAGE
::: https://kdxiaoyi.github.io/disabled-edge-sidebar
@echo off
goto getUACAdmin

:getUACAdmin
@REM rem 配置path路径
@REM if exist "%SystemRoot%\SysWOW64" path %path%;%windir%\SysNative;%SystemRoot%\SysWOW64;%~dp0
rem 通过访问bcd的方法判断是否有UAC管理员权限
bcdedit >>nul
if '%errorlevel%' NEQ '0' (goto UACPrompt) else (goto UACAdmin)

:UACPrompt
rem 通过VBS方法得到UAC管理员权限
rem mshta是一个快速执行JS/VBS脚本的命令行工具
%1 start "GetUACAdmin:getting" mshta vbscript:createobject("shell.application").shellexecute("""%~0""","::",,"runas",1)(window.close)&exit
exit 0 /b
exit 0 /b

:UACAdmin
cd /d "%~dp0"
echo 当前运行路径是：%CD%
echo 已获取管理员权限
goto main

:main
cls
echo ^> Disable Edge Sidebar
echo =======================================================
echo.
echo     选择一个操作：
echo     [1] 禁用Bing Discoverd
echo     [2] 方法2 （需自行实操）
echo.
echo     [X] 恢复
echo     [0] 退出
echo.
echo  kdXiaoyi (C) 2023
echo  [A]ll copyright reserved.
echo =======================================================
echo.
choice /n /c 0x12 /m CHOICE^> 
echo.
echo.
if "%errorlevel%"=="1" exit /b 0
if "%errorlevel%"=="2" goto X
if "%errorlevel%"=="3" goto 1
if "%errorlevel%"=="4" goto 2
goto main

:X
echo 是否恢复？这会导致全部的Policies被删除！
choice /n /c YN /m "CHOICE [Y/N]^>" 
if "%errorlevel%"=="1" reg delete HKEY_CURRENT_USER\Software\Policies\Microsoft\Edge /va /f
if "%errorlevel%"=="2" goto menu
goto end

:1
taskkill /f /im edge.exe /im msedge.exe
reg add HKEY_CURRENT_USER\Software\Policies\Microsoft\Edge /v HubsSidebarEnabled /t REG_DWORD /d 0x00000000 /f
taskkill /f /im edge.exe /im msedge.exe
echo.
echo    请检查edge://policy/中是否出现新策略
echo    若失效，请查看下述URL中的解决方案
echo    https://kdxiaoyi.github.io/blogs/2023/18-edge-sidebar
start msedge.exe
goto end

:2
start https://kdxiaoyi.github.io/blogs/2023/18-edge-sidebar
exit /b 0

:end
echo.
echo.
echo   操作已执行，请自行启动Edge查看效果
echo.
echo   任意键退出
echo  by kdxiaoyi
pause>nul
exit /b 0