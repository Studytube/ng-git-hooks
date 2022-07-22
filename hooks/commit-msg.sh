#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

COMMIT_MSG=$(cat $1)
REGEX='(\[\w+\])?(\[([A-Z]{2,}\-[0-9]+)\])\s(.\s?)+'

echo "==> Checking commit message"

if [ -z "$(echo $COMMIT_MSG | egrep $REGEX | cat)" ]; then
  echo "${RED}Commit message is incorrect: ${COMMIT_MSG}${NC}\n"
  echo "Please follow the commit requirement pattern: https://studytube.atlassian.net/wiki/spaces/TECH/pages/677609473/Development+Processes#Definition-of-done\n"
  echo "Examples:"
  echo "\t[TO-1707] implement git commit linter"
  echo "\t[HOTFIX][TO-1707] fix urgent bug"

  exit 1
fi

echo "${GREEN}Commit message is good!${NC}"
exit 0
