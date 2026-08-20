#!/usr/bin/env bash
set -e

echo "==> [1/5] Auto-Detecting Operating System..."
OS_TYPE="$(uname -s)"
case "${OS_TYPE}" in
    Linux*)     OS=Linux;;
    Darwin*)    OS=Mac;;
    *)          OS="UNKNOWN:${OS_TYPE}"
esac
echo "OS Detected: ${OS}"

echo "==> [2/5] Auto-Detecting and Installing Missing Software..."

# Helper package installer
install_pkg() {
    if [ "$OS" = "Mac" ]; then
        if ! command -v brew &> /dev/null; then
            echo "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install "$1"
    elif [ "$OS" = "Linux" ]; then
        if command -v apt-get &> /dev/null; then
            sudo apt-get update && sudo apt-get install -y "$1"
        elif command -v yum &> /dev/null; then
            sudo yum install -y "$1"
        elif command -v pacman &> /dev/null; then
            sudo pacman -S --noconfirm "$1"
        fi
    fi
}

# Check Git
if ! command -v git &> /dev/null; then
    echo "Git not found. Installing..."
    install_pkg git
fi

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "Node.js not found. Installing Node.js LTS via NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts
    nvm use --lts
fi

# Check PNPM
if ! command -v pnpm &> /dev/null; then
    echo "pnpm not found. Installing via Corepack..."
    corepack enable
    corepack prepare pnpm@latest --activate
fi

echo "==> Environment ready: Node $(node -v) | pnpm $(pnpm -v)"

echo "==> [3/5] Applying Network Timeout Patch (.npmrc)..."
cat <<EOT > .npmrc
fetch-retries=5
fetch-retry-mintimeout=20000
fetch-retry-maxtimeout=120000
network-concurrency=1
strict-peer-dependencies=false
EOT

echo "==> [4/5] Executing Monorepo Dependencies Installation & Build..."
pnpm install --no-frozen-lockfile
pnpm --filter web_dashboard build

echo "==> [5/5] Launching Production Server..."
pnpm --filter web_dashboard start
