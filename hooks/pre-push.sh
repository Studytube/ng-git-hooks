#!/bin/bash

[[ -z "$GIT_DIR" ]] && GIT_DIR=".";
CHANGES=$(git status --porcelain);
if [[ ! -z "$CHANGES" ]];
then
  echo "==> Stash local changes";
  git stash --quiet -u;
fi;

if [ -f "./node_modules/crowdin-helper/crowdin-helper.js" ]; then
  echo "==> Check en.json for changes";
  node ./node_modules/crowdin-helper/crowdin-helper.js pre-push
fi

echo "==> Check TSLint errors";
npm run lint && echo -e "$All fine!${NC}"
RESULT=$?;
if [[ ! -z "$CHANGES" ]];
then
  echo "==> Apply stashed local changes";
  git stash pop --quiet;
fi;

exit $RESULT;
