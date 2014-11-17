#!/usr/bin/env bash

source $@
mkdir .git
result="$(git-prompt)"

if [ "$result" == "" ]; then
  exit 0
else
  echo "Should have returned '', returned '$result'" >&2
  exit 1
fi
