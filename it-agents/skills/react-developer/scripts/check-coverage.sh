#!/bin/bash

# check-coverage.sh
# Runs test coverage and checks against minimum threshold (80%)
# Usage: ./check-coverage.sh [threshold]

set -e

# Default threshold is 80%
THRESHOLD=${1:-80}

echo "Running test coverage check..."
echo "Minimum threshold: ${THRESHOLD}%"
echo ""

if grep -q "\"jest\":" package.json; then
  echo "Detected Jest configuration"

  # Run Jest with coverage
  if [ -f "node_modules/.bin/jest" ]; then
    npx jest --coverage --coverageReporters=text --coverageReporters=text-summary
  else
    echo "Error: Jest not installed. Run 'npm install' first."
    exit 1
  fi

elif grep -q "\"vitest\":" package.json; then
  echo "Detected Vitest configuration"
  npx vitest run --coverage

elif grep -q "\"mocha\":" package.json; then
  echo "Detected Mocha configuration"
  if [ -f "node_modules/.bin/nyc" ]; then
    npx nyc --reporter=text --reporter=text-summary npm test
  else
    echo "Warning: nyc not installed. Run 'npm install --save-dev nyc'"
    npm test
    exit 0
  fi

else
  echo "No recognized test framework found in package.json"
  echo "Supported: jest, vitest, mocha (with nyc)"
  exit 1
fi

echo ""
echo "Coverage check complete!"
echo ""
echo "Note: Ensure your coverage meets the ${THRESHOLD}% threshold."
echo "If coverage is below threshold, add more tests or remove untested code."
