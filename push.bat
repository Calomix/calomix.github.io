@echo off
cd /d C:\MyStuff\Coding\Mobirise\Calomix
git add .
set /p msg=Mensaje del commit: 
git commit -m "%msg%"
git push -u origin main
pause