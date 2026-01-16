#!/bin/bash
set -euo pipefail

# Only run in Claude Code on the web (remote environments)
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

echo "🔧 Spark Session Start Hook"
echo "Checking for dependencies..."

# Flag to track if any dependencies were installed
INSTALLED_ANYTHING=false

# Check for Node.js dependencies
if [ -f "package.json" ]; then
  echo "📦 Found package.json - installing Node.js dependencies..."
  if [ -f "package-lock.json" ]; then
    npm install
  else
    npm install
  fi
  INSTALLED_ANYTHING=true
fi

# Check for Python dependencies
if [ -f "requirements.txt" ]; then
  echo "🐍 Found requirements.txt - installing Python dependencies..."
  pip install -r requirements.txt
  INSTALLED_ANYTHING=true
fi

# Check for Python Poetry
if [ -f "pyproject.toml" ]; then
  echo "🐍 Found pyproject.toml - checking for Poetry..."
  if command -v poetry &> /dev/null; then
    poetry install
    INSTALLED_ANYTHING=true
  fi
fi

# Check for Ruby dependencies
if [ -f "Gemfile" ]; then
  echo "💎 Found Gemfile - installing Ruby dependencies..."
  bundle install
  INSTALLED_ANYTHING=true
fi

# Check for Go dependencies
if [ -f "go.mod" ]; then
  echo "🔷 Found go.mod - installing Go dependencies..."
  go mod download
  INSTALLED_ANYTHING=true
fi

# Check for Rust dependencies
if [ -f "Cargo.toml" ]; then
  echo "🦀 Found Cargo.toml - installing Rust dependencies..."
  cargo fetch
  INSTALLED_ANYTHING=true
fi

if [ "$INSTALLED_ANYTHING" = false ]; then
  echo "✅ No dependencies to install yet"
  echo "💡 This hook will automatically install dependencies when you add them to the project"
else
  echo "✅ Dependencies installed successfully"
fi

echo "🎉 Session ready!"
