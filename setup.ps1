Set-ExecutionPolicy Bypass -Scope Process -Force
$ErrorActionPreference = "Stop"

Write-Host "==> [1/5] Detecting Operating System..." -ForegroundColor Cyan
$isWin = $IsWindows -or ($env:OS -like "*Windows*")
Write-Host "OS Detected: Windows" -ForegroundColor Green

# Package Manager Check (winget)
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "winget not found. Please ensure Windows App Installer is updated." -ForegroundColor Red
    Exit 1
}

Write-Host "==> [2/5] Checking and Installing Prerequisites..." -ForegroundColor Cyan

# Check/Install Git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Git..." -ForegroundColor Yellow
    winget install --id Git.Git -e --source winget --accept-source-agreements --accept-package-agreements
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# Check/Install Node.js
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Node.js LTS..." -ForegroundColor Yellow
    winget install --id OpenJS.NodeJS.LTS -e --source winget --accept-source-agreements --accept-package-agreements
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# Check/Install PNPM
if (-not (Get-Command pnpm -ErrorAction SilentlyContinue)) {
    Write-Host "Installing pnpm..." -ForegroundColor Yellow
    corepack enable
    corepack prepare pnpm@latest --activate
}

Write-Host "==> Core Tools Verified: Node $(node -v), pnpm $(pnpm -v)" -ForegroundColor Green

Write-Host "==> [3/5] Configuring Network & Install Settings..." -ForegroundColor Cyan
Set-Content -Path ".npmrc" -Value "fetch-retries=5`nfetch-retry-mintimeout=20000`nfetch-retry-maxtimeout=120000`nnetwork-concurrency=1`nstrict-peer-dependencies=false"

Write-Host "==> [4/5] Installing Monorepo Dependencies & Building..." -ForegroundColor Cyan
pnpm install --no-frozen-lockfile
pnpm --filter web_dashboard build

Write-Host "==> [5/5] Launching Production Application..." -ForegroundColor Green
pnpm --filter web_dashboard start
