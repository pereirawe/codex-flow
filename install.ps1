# Codex Flow installer for Windows.
# Native Windows (cmd/PowerShell) is NOT supported — use WSL2 (Ubuntu recommended).
# This script detects the environment and either forwards to WSL or prints setup steps.

$ErrorActionPreference = "Stop"

function Test-IsWsl {
    try {
        $v = Get-Content -Raw /proc/version -ErrorAction SilentlyContinue
        return ($v -match "Microsoft|WSL")
    } catch {
        return $false
    }
}

Write-Host "Codex Flow — Windows entrypoint" -ForegroundColor Cyan
Write-Host ""

if ($env:WSL_DISTRO_NAME -or (Test-Path "/proc/version")) {
    Write-Host "Detected WSL. Continuing with bash install.sh ..." -ForegroundColor Green
    $here = Split-Path -Parent $MyInvocation.MyCommand.Path
    bash "$here/install.sh" @args
    exit $LASTEXITCODE
}

$wsl = Get-Command wsl -ErrorAction SilentlyContinue
if (-not $wsl) {
    Write-Host @"
ERROR: Native Windows is not supported for Codex Flow install/init.

Supported path:
  1. Install WSL2:  wsl --install -d Ubuntu
  2. Reboot, open Ubuntu
  3. Inside WSL:
       git clone <this-repo> && cd codex-flow
       bash install.sh
       python3 scripts/restore-vendors.py
       bash scripts/init.sh /path/to/project pt

Docs: docs/install.md
"@ -ForegroundColor Red
    exit 2
}

Write-Host "Forwarding to default WSL distro..." -ForegroundColor Yellow
$repoWin = (Resolve-Path (Split-Path -Parent $MyInvocation.MyCommand.Path)).Path
# Convert C:\... to /mnt/c/...
$drive = $repoWin.Substring(0, 1).ToLower()
$unix = "/mnt/$drive" + ($repoWin.Substring(2) -replace "\\", "/")
$argList = ($args | ForEach-Object { $_ }) -join " "
wsl -e bash -lc "cd '$unix' && bash install.sh $argList"
exit $LASTEXITCODE
