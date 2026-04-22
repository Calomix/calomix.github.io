<#
.SYNOPSIS
  After Mobirise export: hide the credit promo <section> without triggering script.js
  (which strips mbr-additional.css when the last section's computed height is 0px).

.DESCRIPTION
  Replaces the opening tag of <section class="display-7" style="..."> (Mobirise footer
  bar) with visually-hidden styles that keep a non-zero box (see project notes).

.PARAMETER SiteRoot
  Folder containing exported *.html (default: directory of this script).
#>
param(
  [Parameter(Mandatory = $false)]
  [string] $SiteRoot = (Split-Path -Parent $MyInvocation.MyCommand.Path)
)

$ErrorActionPreference = 'Stop'

$safeStyle = 'opacity:0!important;pointer-events:none!important;position:absolute!important;left:-9999px!important;top:0!important;width:1px!important;height:1px!important;overflow:hidden!important;clip-path:inset(50%)!important;margin:0!important;padding:0!important;border:0!important;'

# Match Mobirise promo block opening tag only (one per typical export page).
$pattern = '<section class="display-7" style="[^"]+">'

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$htmlFiles = Get-ChildItem -LiteralPath $SiteRoot -Filter '*.html' -File

if (-not $htmlFiles) {
  Write-Warning "No .html files in: $SiteRoot"
  exit 0
}

$total = 0
foreach ($f in $htmlFiles) {
  $path = $f.FullName
  $content = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)
  # Repair older buggy patch that dropped the closing angle bracket before <a
  if ($content.Contains('border:0!important;"<a')) {
    $content = $content.Replace('border:0!important;"<a', 'border:0!important;"><a')
  }
  $matches = [regex]::Matches($content, $pattern)
  if ($matches.Count -eq 0) {
    Write-Host "[skip] $($f.Name) - no <section class=`"display-7`" style=...> found" -ForegroundColor DarkYellow
    continue
  }
  if ($matches.Count -gt 1) {
    Write-Warning "$($f.Name): $($matches.Count) matches; replacing first only. Review layout if needed."
  }
  $newContent = [regex]::Replace(
    $content,
    $pattern,
    '<section class="display-7" style="' + $safeStyle + '">',
    1
  )
  if ($newContent -eq $content) {
    Write-Host "[ok]   $($f.Name) - already patched or unchanged" -ForegroundColor Gray
    continue
  }
  [System.IO.File]::WriteAllText($path, $newContent, $utf8NoBom)
  Write-Host "[fix]  $($f.Name)" -ForegroundColor Green
  $total++
}

Write-Host ""
Write-Host "Done. Patched $total file(s). Re-open pages in browser (hard refresh)." -ForegroundColor Cyan
