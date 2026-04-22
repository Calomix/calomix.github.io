@echo off
cd /d "%~dp0"

:: ── Fix Mobirise footer ──────────────────────────────────────────────────────
echo Fixing footer in HTML files...
set "SCRIPT_DIR=%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$folder = $env:SCRIPT_DIR.TrimEnd('\');" ^
  "$old = '</section><section class=\"display-7\" style=\"display:padding: 0;align-items: center;justify-content: center;flex-wrap: wrap;    align-content: center;display: flex;position: relative;height: 4rem;\"><a href=\"https://mobiri.se/\" style=\"flex: 1 1;height: 4rem;position: absolute;width: 100%%;z-index: 1;\"><img alt=\"\" style=\"height: 4rem;\" src=\"data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==\"></a><p style=\"margin: 0;text-align: center;\" class=\"display-7\">&#8204;</p><a style=\"z-index:1\" href=\"https://mobirise.com/builder/ai-website-generator.html\">AI Website Generator</a></section><script src=\"assets/bootstrap/js/bootstrap.bundle.min.js\"></script>  <script src=\"assets/smoothscroll/smooth-scroll.js\"></script>  <script src=\"assets/ytplayer/index.js\"></script>  <script src=\"assets/dropdown/js/navbar-dropdown.js\"></script>  <script src=\"assets/theme/js/script.js\"></script>';" ^
  "$new = '</section><section class=\"display-7\" style=\"opacity:0!important;pointer-events:none!important;position:absolute!important;left:-9999px!important;top:0!important;width:1px!important;height:1px!important;overflow:hidden!important;clip-path:inset(50%%)!important;margin:0!important;padding:0!important;border:0!important;\"><a href=\"https://mobiri.se/\" style=\"flex: 1 1;height: 4rem;position: absolute;width: 100%%;z-index: 1;\"><img alt=\"\" style=\"height: 4rem;\" src=\"data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==\"></a><p style=\"margin: 0;text-align: center;\" class=\"display-7\">&#8204;</p><a style=\"z-index:1\" href=\"https://mobirise.com/builder/ai-website-generator.html\">AI Website Generator</a></section><script src=\"assets/bootstrap/js/bootstrap.bundle.min.js\"></script>  <script src=\"assets/smoothscroll/smooth-scroll.js\"></script>  <script src=\"assets/ytplayer/index.js\"></script>  <script src=\"assets/dropdown/js/navbar-dropdown.js\"></script>  <script src=\"assets/theme/js/script.js\"></script>';" ^
  "Get-ChildItem -Path $folder -Filter '*.html' | ForEach-Object {" ^
  "  $content = Get-Content $_.FullName -Raw -Encoding UTF8;" ^
  "  if ($content -like ('*' + $old + '*')) {" ^
  "    $content.Replace($old, $new) | Set-Content $_.FullName -Encoding UTF8 -NoNewline;" ^
  "    Write-Host '[FIXED]   ' $_.Name" ^
  "  } else {" ^
  "    Write-Host '[SKIPPED] ' $_.Name '(pattern not found)'" ^
  "  }" ^
  "}"

:: ── Git push ─────────────────────────────────────────────────────────────────
echo.
git add .
set /p msg=Mensaje del commit:
git commit -m "%msg%"
git push -u origin main
pause
