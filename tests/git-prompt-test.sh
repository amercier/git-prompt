#!/usr/bin/env roundup

describe "git-prompt"

before() {
  PATH="$PATH:$(pwd)/../src"
  tmp_dir="$(mktemp -d 2>/dev/null || mktemp -d -t 'git-prompt')"
  cd "$tmp_dir"
}

after() {
  rm -rf $tmp_dir
}

it_displays_nothing_in_empty_dir() {
  output="$(git-prompt.sh 2>&1)"
  test "$output" "=" ""
}

it_displays_nothing_in_empty_dir_containing_git_dir() {
  mkdir .git
  output="$(git-prompt.sh 2>&1)"
  test "$output" "=" ""
}
