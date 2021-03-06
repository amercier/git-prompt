#!/usr/bin/env roundup

describe "git-prompt-legacy"

before() {
	PATH="$PATH:$(pwd)/../src"
	tmp_dir="$(mktemp -d 2>/dev/null || mktemp -d -t 'git-prompt')"
	cd "$tmp_dir"
	unset GIT_PS1_DESCRIBE_STYLE
	unset GIT_PS1_SHOWCOLORHINTS
	unset GIT_PS1_SHOWDIRTYSTATE
	unset GIT_PS1_SHOWSTASHSTATE
	unset GIT_PS1_SHOWUNTRACKEDFILES
	unset GIT_PS1_SHOWUPSTREAM
	unset GIT_PS1_STATESEPARATOR
}

after() {
	rm -rf $tmp_dir
}

init_git_repo() {
	git init --bare repo.git
	git clone ./repo.git
	cd repo
	git config user.email "roundup@xample.com"
	git config user.name "Roundup"
	echo ok > README
	git add README
	git commit -m "Added README"
	git push -u origin master
}

it_shows_nothing_in_empty_dir() {
	output="$(git-prompt-legacy.sh 2>&1)"
	test "$output" "=" ""
}

it_shows_branch_name() {
	init_git_repo
	output="$(git-prompt-legacy.sh 2>&1)"
	test "$output" "=" "master"
	git checkout -b mybranch
	output="$(git-prompt-legacy.sh 2>&1)"
	test "$output" "=" "mybranch"
}

it_shows_merging_status() {
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

it_shows_rebasing_status() {
	init_git_repo

	git checkout -b branch-a
  echo a > file1
	git add file1
	git commit -m "a"
  echo b > file2
	git add file2
	git commit -m "b"
  echo c > file3
	git add file3
	git commit -m "c"

	git checkout master
	echo d > file1
	echo d > file2
	echo d > file3
	git add file1 file2 file3
	git commit -m "d"

	git checkout branch-a
	(git rebase master || exit 0)
	output="$(git-prompt-legacy.sh 2>&1)"
	test "$output" "=" "branch-a|REBASE 1/3"

	echo e > file1
	git add file1
	(git rebase --continue || exit 0)
	output="$(git-prompt-legacy.sh 2>&1)"
	test "$output" "=" "branch-a|REBASE 2/3"

	echo e > file2
	git add file2
	(git rebase --continue || exit 0)
	output="$(git-prompt-legacy.sh 2>&1)"
	test "$output" "=" "branch-a|REBASE 3/3"

	echo e > file3
	git add file3
	(git rebase --continue || exit 0)
	output="$(git-prompt-legacy.sh 2>&1)"
	test "$output" "=" "branch-a"
}

it_shows_detached_head_tag_status () {
	init_git_repo
	git tag v1.0.0
	git checkout v1.0.0
	output="$(git-prompt-legacy.sh 2>&1)"
	test "$output" '==' '(v1.0.0)'
	echo a > file1
	git add file1
	git commit -m "a"
	git tag v1.0.1
	echo b > file1
	git add file1
	git commit -m "b"
	echo c > file1
	git add file1
	git commit -m "c"
	git tag v1.1.0

	git checkout HEAD^
	output="$(git-prompt-legacy.sh 2>&1)"
	echo "$output" | egrep '^\([0-9a-f]{7}\.\.\.\)$'
	output="$(GIT_PS1_DESCRIBE_STYLE=contains git-prompt-legacy.sh 2>&1)"
	test "$output" '==' '(v1.1.0~1)'
	output="$(GIT_PS1_DESCRIBE_STYLE=branch git-prompt-legacy.sh 2>&1)"
	test "$output" '==' '(tags/v1.1.0~1)'
}

it_shows_detached_head_branch_status () {
	init_git_repo
	echo a > file1
	git add file1
	git commit -m "a"
	echo b > file1
	git add file1
	git commit -m "b"
	git checkout --detach HEAD^
	output="$(git-prompt-legacy.sh 2>&1)"
	echo "$output" | egrep '^\([0-9a-f]{7}\.\.\.\)$'
	output="$(GIT_PS1_DESCRIBE_STYLE=branch git-prompt-legacy.sh 2>&1)"
	test "$output" '==' '(master~1)'
}

it_shows_bare_repo () {
	init_git_repo
	cd ../repo.git
	output="$(git-prompt-legacy.sh 2>&1)"
	test "$output" '==' 'BARE:master'
}

it_shows_git_dir () {
	init_git_repo
	cd .git
	output="$(git-prompt-legacy.sh 2>&1)"
	test "$output" '==' 'GIT_DIR!'
}

it_shows_dirty_state () {
	init_git_repo
	echo a > file1
	echo a > file2
	git add file1 file2
	git commit -m "a"

	echo b > file1
	echo b > file2
	output="$(GIT_PS1_SHOWDIRTYSTATE=1 git-prompt-legacy.sh 2>&1)"
	test "$output" '==' 'master *'
	git add file1
	output="$(GIT_PS1_SHOWDIRTYSTATE=1 git-prompt-legacy.sh 2>&1)"
	test "$output" '==' 'master *+'
	git add file2
	output="$(GIT_PS1_SHOWDIRTYSTATE=1 git-prompt-legacy.sh 2>&1)"
	test "$output" '==' 'master +'
	git commit -m "b"
}

it_shows_dirty_state_on_new_repo () {
	mkdir repo
	cd repo
	git init
	output="$(GIT_PS1_SHOWDIRTYSTATE=1 git-prompt-legacy.sh 2>&1)"
	test "$output" '==' 'master #'
}

it_shows_untracked_files () {
	init_git_repo
	echo a > file1
	output="$(GIT_PS1_SHOWUNTRACKEDFILES=1 git-prompt-legacy.sh 2>&1)"
	test "$output" '==' 'master %'
}

it_shows_stash () {
	init_git_repo
	echo a > README
	git stash
	output="$(GIT_PS1_SHOWSTASHSTATE=1 git-prompt-legacy.sh 2>&1)"
	test "$output" '==' 'master $'
}
