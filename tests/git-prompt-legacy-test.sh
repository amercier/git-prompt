#!/usr/bin/env roundup

describe "git-prompt-legacy"

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
	git clone ./repo.git repo2
	cd repo
	echo ok > README
	git add README
	git commit -m "Added README"
	git push -u origin master
}

it_displays_nothing_in_empty_dir() {
	output="$(git-prompt-legacy.sh 2>&1)"
	test "$output" "=" ""
}

it_displays_nothing_in_empty_dir_containing_git_dir() {
	mkdir .git
	output="$(git-prompt-legacy.sh 2>&1)"
	test "$output" "=" ""
}

it_displays_branch_name() {
	init_git_repo
	output="$(git-prompt-legacy.sh 2>&1)"
	test "$output" "=" "master"
	git checkout -b mybranch
	output="$(git-prompt-legacy.sh 2>&1)"
	test "$output" "=" "mybranch"
}

it_displays_merging_status() {
	init_git_repo
	git checkout -b branch-a
	echo a > file
	git add file
	git commit -m "a"
	git checkout master
  echo b > file
	git add file
	git commit -m "b"
	(git merge branch-a || exit 0)
	output="$(git-prompt-legacy.sh 2>&1)"
	test "$output" "=" "master|MERGING"
}
