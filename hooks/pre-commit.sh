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
appScriptsToLint=$(git diff --cached --name-only --diff-filter=d | grep -E '^(src|projects)\/\S*\.ts$' || true)
e2eScriptsToLint=$(git diff --cached --name-only --diff-filter=d | grep -E '^e2e\/\S*\.ts$' || true)
stylesToLint=$(git diff --cached --name-only --diff-filter=d | grep -E '\.(scss|css)$' || true)

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
fi;

if [ -n "$appScriptsToLint" ]; then
  echo "==> Checking TSLint errors in app's staged files";
  echo "$appScriptsToLint" | xargs node_modules/tslint/bin/tslint --project tsconfig.json
  printf "${GREEN}🔨️ App's scripts and templates are fine!${NC}\n\n"
fi;

if [ -n "$e2eScriptsToLint" ]; then
  echo "==> Checking TSLint errors in e2e staged files";
  echo "$e2eScriptsToLint" | xargs node_modules/tslint/bin/tslint --project ./e2e/tsconfig.json
  printf "${GREEN}🔨️ E2e scripts are fine!${NC}\n\n"
fi;

if [ -f "$STYLELINT_CONFIG" ] && [ -n "$stylesToLint" ]; then
  echo "==> Checking Stylelint errors in staged files";
  echo "$stylesToLint" | xargs ./node_modules/.bin/stylelint --fix

  echo "==> Staging formatted .scss, .css files"
  echo "$stylesToLint" | xargs git add

  printf "${GREEN}💅 Styles are fine!${NC}\n\n"
fi;

if [ -n "$tsfiles" ] || [ -n "$stylesToLint" ]; then
  printf "${GREEN}===== ✅ Linting passed. Well done!👏🥇 =====${NC}\n\n"
fi;

exit 0;
