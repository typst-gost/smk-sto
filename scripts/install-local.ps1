Param()

$root = Resolve-Path "$PSScriptRoot\.."
$versionPath = Join-Path $root "VERSION"
$version = (Get-Content $versionPath -First 1).Trim()
if (-not $version) {
  throw "VERSION file is empty."
}

$base = if ($env:APPDATA) { $env:APPDATA } else { Join-Path $env:USERPROFILE "AppData\Roaming" }
$dest = Join-Path $base "typst\packages\preview\smk-sto\$version"

Remove-Item -Recurse -Force $dest -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $dest | Out-Null

$excludeFiles = @(
  "standard-lab.pdf",
  "standard-practice.pdf",
  "standard-common.pdf",
  "AGENTS.md",
  ".gitignore",
  "lab-example.typ",
  "practice-example.typ",
  "practice-main.typ"
)
$excludeDirs = @(
  ".git",
  ".github",
  "temp-render",
  "reference",
  ".claude",
  "scripts"
)

robocopy $root $dest /E /XF $excludeFiles /XD $excludeDirs | Out-Null
Write-Host "Installed smk-sto $version to $dest"
