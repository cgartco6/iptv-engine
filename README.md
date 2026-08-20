# Monorepo Workspace & Dashboard

Monorepo architecture hosting web applications and services built with Next.js, TypeScript, and PNPM Workspaces.

## 🚀 Quick Start (Automated Setup)

Run one of the OS-specific automated setup scripts in the root folder to detect prerequisites, install missing tools, build, and deploy locally:

* **Windows (PowerShell):** `powershell -ExecutionPolicy Bypass -File setup.ps1`
* **Windows (CMD):** Double-click `setup.bat`
* **Linux / macOS:** `chmod +x setup.sh && ./setup.sh`

## 🛠 Manual Setup & Commands

### Prerequisites
* **Node.js**: `20.x` or higher
* **pnpm**: `9.x` or higher

### Installation & Development

1. **Install dependencies across monorepo:**
   ```bash
   pnpm install
