@echo off
cd /d "%~dp0"

:: ── Hide Mobirise promo footer ────────────────────────────────────────────────
echo Hiding Mobirise promo footer...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0hide-mobirise-promo-after-export.ps1" -SiteRoot "%~dp0"
if errorlevel 1 (
  echo [ERROR] Footer script failed. Aborting.
  pause
  exit /b 1
)

:: ── Git push ──────────────────────────────────────────────────────────────────
echo.
git add .
set /p msg=Mensaje del commit:
git commit -m "%msg%"
git push -u origin main
pause
