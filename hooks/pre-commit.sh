#!/bin/sh

set -e    # exit on any error

GREEN='\033[0;32m'
NC='\033[0m'

STYLELINT_CONFIG=.stylelintrc

tsfiles=$(git diff --cached --name-only --diff-filter=ACM "*.ts" | tr '\n' ' ')
htmlfiles=$(git diff --cached --name-only --diff-filter=ACM "*.html" | tr '\n' ' ')

filestoprettify="$tsfiles $htmlfiles"

# || true prevents grep from exit when no matches
#
# TODO: Add *.html after migrating to eslint.
# (on TSLint it leads to "is not included in project" error in some cases)
#
scriptstolint=$(git diff --cached --name-only --diff-filter=d | grep -E '\.(js|ts)$' || true)
stylestolint=$(git diff --cached --name-only --diff-filter=d | grep -E '\.(scss|css)$' || true)

# TODO: Ideally, we want to lint only staged changes
#  so that we don't add any random changes that haven't been staged before linting starts
#  but could be added after auto-fixing lint errors and indexing the same files.
#  This could be solved via https://github.com/okonet/lint-staged

if [ -n "$tsfiles" ]; then
  echo "==> Sorting imports in .ts files"
  echo "$tsfiles" | xargs ./node_modules/.bin/import-sort --write

  echo "==> Prettifying .ts, .html files"
  echo "$filestoprettify" | xargs ./node_modules/.bin/prettier --write

  echo "==> Staging formatted .ts, .html files"
  echo "$filestoprettify" | xargs git add

  echo "==> Checking TSLint errors in staged files";
  echo "$scriptstolint" | xargs node_modules/tslint/bin/tslint --project tsconfig.json
  printf "${GREEN}🔨️ Scripts and templates are fine!${NC}\n\n"
fi;

if [ -f "$STYLELINT_CONFIG" ] && [ -n "$stylestolint" ]; then
  echo "==> Checking Stylelint errors in staged files";
  echo "$stylestolint" | xargs ./node_modules/.bin/stylelint --fix

  echo "==> Staging formatted .scss, .css files"
  echo "$stylestolint" | xargs git add

  printf "${GREEN}💅 Styles are fine!${NC}\n\n"
fi;

if [ -n "$tsfiles" ] || [ -n "$stylestolint" ]; then
  printf "${GREEN}===== ✅ Linting passed. Well done!👏🥇 =====${NC}\n\n"
fi;

exit 0;
