@echo off
cd /d "%~dp0"
echo.
git add .
set /p msg=Mensaje del commit:
git commit -m "%msg%"
git push -u origin main
pause
