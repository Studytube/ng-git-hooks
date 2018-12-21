#!/bin/bash

[[ -z "$GIT_DIR" ]] && GIT_DIR=".";
CHANGES="git status --porcelain";
if [[ ! -z "$CHANGES" ]];
then
  echo "==> Stash local changes";
  git stash --quiet -u;
fi;

echo "==> Check en.json for changes";
node ./node_modules/crowdin-helper/crowdin-helper.js pre-push

echo "==> Check TSLint and AOT errors";
npm run lint && ng build --aot && echo -e "$All fine!${NC}"
RESULT=$?;
if [[ ! -z "$CHANGES" ]];
then
  echo "==> Apply stashed local changes";
  git stash pop --quiet;
fi;

exit $RESULT;
