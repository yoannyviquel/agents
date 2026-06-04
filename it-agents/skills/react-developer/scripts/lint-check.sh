#!/bin/bash

# lint-check.sh
# Runs linting checks for the project
# Automatically detects project type and runs appropriate linter

set -e

echo "Running lint checks..."
echo ""

if grep -q "\"eslint\":" package.json || [ -f ".eslintrc.js" ] || [ -f ".eslintrc.json" ] || [ -f "eslint.config.js" ]; then
  echo "Detected ESLint configuration"

  if [ -f "node_modules/.bin/eslint" ]; then
    npx eslint . --ext .js,.jsx,.ts,.tsx
    echo "ESLint: PASS"
  else
    echo "Error: ESLint not installed. Run 'npm install'"
    exit 1
  fi
else
  echo "No ESLint configuration found"
  echo "Consider adding ESLint: npm install --save-dev eslint"
fi

# Check for Prettier
if grep -q "\"prettier\":" package.json || [ -f ".prettierrc" ] || [ -f ".prettierrc.json" ]; then
  echo ""
  echo "Checking Prettier formatting..."

  if [ -f "node_modules/.bin/prettier" ]; then
    npx prettier --check .
    echo "Prettier: PASS"
  else
    echo "Warning: Prettier not installed"
  fi
fi

# Check for TypeScript
if [ -f "tsconfig.json" ]; then
  echo ""
  echo "Running TypeScript compiler check..."

  if [ -f "node_modules/.bin/tsc" ]; then
    npx tsc --noEmit
    echo "TypeScript: PASS"
  else
    echo "Warning: TypeScript not installed"
  fi
fi

echo ""
echo "All lint checks passed!"
