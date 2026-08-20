@echo off
SETLOCAL EnableDelayedExpansion
echo ==> [1/5] Initializing Windows Automated Setup...

echo ==> [2/5] Checking Dependencies...

where git >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Git not found. Installing via winget...
    winget install --id Git.Git -e --source winget --accept-source-agreements --accept-package-agreements
)

where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Node.js not found. Installing via winget...
    winget install --id OpenJS.NodeJS.LTS -e --source winget --accept-source-agreements --accept-package-agreements
    call refreshenv >nul 2>nul
)

where pnpm >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo pnpm not found. Activating via Corepack...
    call corepack enable
    call corepack prepare pnpm@latest --activate
)

echo ==> [3/5] Creating Network Resilience Configuration...
(
  echo fetch-retries=5
  echo fetch-retry-mintimeout=20000
  echo fetch-retry-maxtimeout=120000
  echo network-concurrency=1
  echo strict-peer-dependencies=false
) > .npmrc

echo ==> [4/5] Installing Packages and Building Target App...
call pnpm install --no-frozen-lockfile
call pnpm --filter web_dashboard build

echo ==> [5/5] Starting Production Deployment...
call pnpm --filter web_dashboard start
pause
