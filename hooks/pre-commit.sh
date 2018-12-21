#!/bin/sh

tsfiles=$(git diff --cached --name-only --diff-filter=ACM "*.ts" | tr '\n' ' ')
htmlfiles=$(git diff --cached --name-only --diff-filter=ACM "*.html" | tr '\n' ' ')
filestoprettify="$tsfiles $htmlfiles"

if [ -n "$tsfiles" ]; then
  echo "==> Sort imports in .ts files"
  echo "$tsfiles" | xargs ./node_modules/.bin/import-sort --write

  echo "==> Prettify .ts, .html files"
  echo "$filestoprettify" | xargs ./node_modules/.bin/prettier --write

  echo "==> Stage formatted .ts, .html files"
  echo "$filestoprettify" | xargs git add
fi;

exit 0;
