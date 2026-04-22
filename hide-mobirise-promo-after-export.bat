@echo off
setlocal
REM Run after each Mobirise publish/export. Patches all *.html in this folder.
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0hide-mobirise-promo-after-export.ps1" -SiteRoot "%~dp0"
if errorlevel 1 exit /b 1
