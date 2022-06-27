#!/bin/sh

[ -z "$GIT_DIR" ] && GIT_DIR="."

CHANGES="$(git status --porcelain)"
if [ -n "$CHANGES" ]; then
  echo "==> Stash local changes"
  git stash --quiet -u
fi

if [ -n "$CHANGES" ]; then
  echo "==> Apply stashed local changes"
  git stash pop --quiet
fi

exit 0
