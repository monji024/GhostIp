:: author : Monji
:: telegram : https://t.me/DevCrr
:: GitHub : https://github.com/monji024

@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

set "GREEN=[92m"
set "RED=[91m"
set "NC=[0m"

echo %GREEN%+ Checking Dependencies...%NC%

where ruby >nul 2>&1
if %errorlevel% neq 0 (
    echo %RED%+ Ruby not found!!! Please install Ruby from: https://rubyinstaller.org/%NC%
    echo %RED%+ After installing Ruby, run this script again%NC%
    pause
    exit /b 1
) else (
    echo %GREEN%✓ Ruby already installed%NC%
)

set "TOR_FOUND=0"
if exist "C:\Program Files\Tor\tor.exe" set "TOR_FOUND=1"
if exist "C:\Program Files (x86)\Tor\tor.exe" set "TOR_FOUND=1"
if exist "%LOCALAPPDATA%\Tor\tor.exe" set "TOR_FOUND=1"

if %TOR_FOUND% equ 0 (
    echo %RED%+ tor not found!!! Please install tor from: https://www.torproject.org%NC%
    echo %RED%+ After installing Tor, make sure tor.exe is running%NC%
    pause
    exit /b 1
) else (
    echo %GREEN%✓ Tor already installed%NC%
)

gem list -i socksify >nul 2>&1
if %errorlevel% neq 0 (
    echo %RED%+ socksify gem not found. Installing...%NC%
    gem install socksify
    if %errorlevel% equ 0 (
        echo %GREEN%✓ socksify installed%NC%
    ) else (
        echo %RED%! Failed to install socksify ! Try running as administrator%NC%
        pause
        exit /b 1
    )
) else (
    echo %GREEN%✓ socksify gem already installed%NC%
)

echo.
echo %GREEN%✓ All dependencies are ready!!!%NC%
pause
