@echo off
title Python 自动安装与配置
echo ========================================
echo      Python 自动安装与配置脚本
echo ========================================
echo.

:: 检查是否以管理员身份运行
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 请以管理员身份运行此脚本！
    echo 右键点击此文件，选择 "以管理员身份运行"。
    pause
    exit /b
)

:: 检查 Python 是否已安装
python --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [信息] 已检测到 Python，无需重复安装。
    python --version
    echo.
    echo 按任意键退出...
    pause >nul
    exit /b
)

echo [提示] 未检测到 Python，是否自动下载并安装？
echo        将自动下载 Python 3.12.4 64位版本并添加到 PATH。
echo.
set /p choice="是否继续安装? (Y/N): "
if /i not "%choice%"=="Y" (
    echo 取消安装。
    pause
    exit /b
)

echo.
echo [1/4] 准备下载 Python 3.12.4 64位安装包...
set "installer=python-3.12.4-amd64.exe"
set "url=https://www.python.org/ftp/python/3.12.4/%installer%"

:: 使用 PowerShell 下载
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%url%' -OutFile '%installer%'}"
if %errorlevel% neq 0 (
    echo [错误] 下载失败，请检查网络连接。
    pause
    exit /b
)
echo [成功] 安装包下载完成。

echo.
echo [2/4] 开始静默安装 Python...
%installer% /quiet InstallAllUsers=1 PrependPath=1
if %errorlevel% neq 0 (
    echo [错误] 安装过程中出现问题，请尝试手动安装。
    pause
    exit /b
)
echo [成功] Python 安装完成。

echo.
echo [3/4] 清理临时安装包...
del %installer% 2>nul

echo.
echo [4/4] 验证安装...
:: 等待系统刷新环境变量
echo 等待 5 秒让系统注册环境变量...
timeout /t 5 /nobreak >nul

:: 重新加载环境变量（无需重启）
call refreshenv.cmd 2>nul
:: 如果没有 refreshenv，尝试用新进程加载
set "path=C:\Python312;C:\Python312\Scripts;%path%"
python --version
if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo      Python 安装成功并已添加至 PATH！
    echo ========================================
    echo.
    echo 建议关闭此窗口后，重新打开命令提示符或重新启动计算机以确保环境变量完全生效。
) else (
    echo [警告] 环境变量可能未立即生效，请手动重启计算机或重新打开命令提示符。
)

echo.
echo 按任意键退出...
pause >nul
exit /b