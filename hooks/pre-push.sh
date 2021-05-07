#!/bin/bash

[[ -z "$GIT_DIR" ]] && GIT_DIR=".";
CHANGES=$(git status --porcelain);
if [[ ! -z "$CHANGES" ]];
then
  echo "==> Stash local changes";
  git stash --quiet -u;
fi;

if [[ $(npm run | grep "^  crowdin-pre-push$" | wc -l) > 0 ]]; then
  echo "==> Check en.json for changes";
  npm run crowdin-pre-push
fi

if [[ ! -z "$CHANGES" ]];
then
  echo "==> Apply stashed local changes";
  git stash pop --quiet;
fi;

exit 0;
