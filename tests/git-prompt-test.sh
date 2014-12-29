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

init_git_repo() {
	git init --bare repo.git
	git clone ./repo.git
	cd repo
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

it_displays_branch_name() {
	init_git_repo
	output="$(git-prompt.sh 2>&1)"
	test "$output" "=" "master"
	git checkout -b mybranch
	output="$(git-prompt.sh 2>&1)"
	test "$output" "=" "mybranch"
}
