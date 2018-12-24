#!/bin/bash

YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'

if [[ -d .git ]]; then
  for hook in pre-push pre-commit post-merge
  do
    cp --remove-destination "./node_modules/ng-git-hooks/hooks/${hook}.sh" "./.git/hooks/${hook}";
  done
  echo -e "${GREEN}Success adding git hooks${NC}"
else
  echo -e "${YELLOW}Failure adding git hooks: .git/ directory not found${NC}"
fi;
