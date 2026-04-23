<#
.SYNOPSIS
  After Mobirise export: inject a <style> that hides the credit section via CSS.

.DESCRIPTION
  Targets the Mobirise promo section with  section:has(a[href*="mobirise.com"])
  so it works regardless of how Mobirise reformats the section's inline styles
  between exports. Injects once before </head>; idempotent on re-runs.

  Uses position:absolute + left:-9999px + height:1px so the box is invisible
  and off-screen but has a non-zero computed height, which prevents script.js
  from stripping mbr-additional.css (it checks height != 0 on the last section).

.PARAMETER SiteRoot
  Folder containing exported *.html (default: directory of this script).
#>
param(
  [string] $SiteRoot = (Split-Path -Parent $MyInvocation.MyCommand.Path)
)

$ErrorActionPreference = 'Stop'

# %~dp0 in batch ends with \ so the shell sees C:\path\" — strip stray quotes and trailing slash
$SiteRoot = $SiteRoot.Trim('"').TrimEnd('\')

$markerId  = 'mbr-promo-hidden'
$styleTag  = '<style id="' + $markerId + '">section:has(a[href*="mobirise.com"]){opacity:0!important;pointer-events:none!important;position:absolute!important;left:-9999px!important;height:1px!important;overflow:hidden!important}</style>'

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$htmlFiles = Get-ChildItem -LiteralPath $SiteRoot -Filter '*.html' -File

if (-not $htmlFiles) {
  Write-Warning "No .html files found in: $SiteRoot"
  exit 0
}

$total = 0
foreach ($f in $htmlFiles) {
  $path    = $f.FullName
  $content = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)

  if ($content.Contains($markerId)) {
    Write-Host "[ok]   $($f.Name)  (already patched)" -ForegroundColor Gray
    continue
  }

  if (-not $content.Contains('</head>')) {
    Write-Host "[skip] $($f.Name)  (no </head> tag)" -ForegroundColor DarkYellow
    continue
  }

  $newContent = $content.Replace('</head>', $styleTag + '</head>')
  [System.IO.File]::WriteAllText($path, $newContent, $utf8NoBom)
  Write-Host "[fix]  $($f.Name)" -ForegroundColor Green
  $total++
}

Write-Host ""
Write-Host "Done. Patched $total file(s). Hard-refresh in browser to see changes." -ForegroundColor Cyan
