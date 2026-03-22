@echo off
chcp 65001 >nul
title Python Auto Installer
echo ========================================
echo    Python Auto Installation Script
echo ========================================
echo.

:: Check admin rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Please run as Administrator!
    echo Right-click this file and select "Run as administrator".
    pause
    exit /b
)

:: Check if Python is already installed
python --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [INFO] Python is already installed.
    python --version
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b
)

echo [INFO] Python not found. Do you want to download and install Python 3.12.4?
set /p choice="Continue? (Y/N): "
if /i not "%choice%"=="Y" (
    echo Installation cancelled.
    pause
    exit /b
)

echo.
echo [1/4] Downloading Python 3.12.4 64-bit installer...
set "installer=python-3.12.4-amd64.exe"
set "url=https://www.python.org/ftp/python/3.12.4/%installer%"

:: Download using PowerShell
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%url%' -OutFile '%installer%'}"
if %errorlevel% neq 0 (
    echo [ERROR] Download failed. Please check your internet connection.
    pause
    exit /b
)
echo [SUCCESS] Download completed.

echo.
echo [2/4] Installing Python silently...
%installer% /quiet InstallAllUsers=1 PrependPath=1
if %errorlevel% neq 0 (
    echo [ERROR] Installation failed. Please try manual installation.
    pause
    exit /b
)
echo [SUCCESS] Python installed.

echo.
echo [3/4] Cleaning up...
del %installer% 2>nul

echo.
echo [4/4] Verifying installation...
:: Wait for system to register environment variables
echo Waiting 5 seconds for environment variables...
timeout /t 5 /nobreak >nul

:: Try to use Python from default location
set "PATH=C:\Python312;C:\Python312\Scripts;%PATH%"
python --version
if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo   Python installed successfully!
    echo   Path has been added automatically.
    echo ========================================
    echo.
    echo You may need to restart your computer or
    echo reopen the command prompt for PATH changes.
) else (
    echo [WARNING] Please restart your computer to finalize installation.
)

echo.
echo Press any key to exit...
pause >nul
exit /b