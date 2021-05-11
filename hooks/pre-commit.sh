#!/bin/sh

set -e    # exit on any error

GREEN='\033[0;32m'
NC='\033[0m'

tsfiles=$(git diff --cached --name-only --diff-filter=ACM "*.ts" | tr '\n' ' ')
htmlfiles=$(git diff --cached --name-only --diff-filter=ACM "*.html" | tr '\n' ' ')
filestoprettify="$tsfiles $htmlfiles"

# || true prevents grep from exit when no matches
filestolint=$(git diff --diff-filter=d --cached --name-only | grep -E '\.(js|ts|html)$' || true)

if [ -n "$tsfiles" ]; then
  echo "==> Sort imports in .ts files"
  echo "$tsfiles" | xargs ./node_modules/.bin/import-sort --write

  echo "==> Prettify .ts, .html files"
  echo "$filestoprettify" | xargs ./node_modules/.bin/prettier --write

  echo "==> Stage formatted .ts, .html files"
  echo "$filestoprettify" | xargs git add

  echo "==> Check TSLint errors in staged files";
  echo "$filestolint" | xargs node_modules/tslint/bin/tslint --project tsconfig.json
  printf "${GREEN}All fine!${NC}\n"
fi;

exit 0;
