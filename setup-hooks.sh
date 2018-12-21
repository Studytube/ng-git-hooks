#!/bin/bash

YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'

SRC_DIR='./node_modules/ng-git-hooks/hooks/'
DEST_DIR='./.git/hooks/'

if [[ -d .git ]]; then
  cp --remove-destination "${SRC_DIR}pre-push.sh" "${DEST_DIR}pre-push";
  cp --remove-destination "${SRC_DIR}pre-commit.sh" "${DEST_DIR}pre-commit";
  cp --remove-destination "${SRC_DIR}post-merge.sh" "${DEST_DIR}post-merge";
  echo -e "${GREEN}Success adding git hooks${NC}"
else
  echo -e "${YELLOW}Failure adding git hooks: .git/ directory not found${NC}"
fi;
