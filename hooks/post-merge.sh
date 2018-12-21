#!/bin/sh

# get the list of changed files
changed_files="$(git diff-tree -r --name-only --no-commit-id ORIG_HEAD HEAD)"

check_file() {
  echo "$changed_files" | grep --quiet "$1" && eval "$2"
}

echo "==> Check package.json for changes and reinstall packages when necessary"
check_file "package.json" "npm install && npm prune"
