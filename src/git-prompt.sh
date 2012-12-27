#!/usr/bin/env bash

_git_info="?"

function _git-info {
	if [ "$_git_info" == "?" ]; then
		_git_info="$(git rev-parse \
			--git-dir \
			--is-inside-git-dir \
			--is-bare-repository \
			--is-inside-work-tree \
			--short HEAD 2>/dev/null)"
	fi
	echo "$_git_info"
}

function is-inside-git-dir {
	[ "$(_git-info | head -n 2 | tail -n 1)" = "true" ] && return 0 || return 1;
}

function is-bare-repository {
	[ "$(_git-info | head -n 3 | tail -n 1)" = "true" ] && return 0 || return 1;
}

function is-inside-work-tree {
	[ "$(_git-info | head -n 4 | tail -n 1)" = "true" ] && return 0 || return 1;
}

function git-sha {
	_git-info | head -n 5 | tail -n 1
}

function git-dir {
  _git-info | head -n 1
}

function git-branch {
	is-inside-work-tree || return 1
	local branch=""

	if [ -d "$(git-dir)/rebase-merge" ]; then
		# TODO: implement
	else
		if [ -d "$(git-dir)/rebase-apply" ]; then
			# TODO: implement
		elif [ -f "$(git-dir)/MERGE_HEAD" ]; then
			# TODO: implement
		elif [ -f "$(git-dir)/CHERRY_PICK_HEAD" ]; then
			# TODO: implement
		elif [ -f "$(git-dir)/REVERT_HEAD" ]; then
			# TODO: implement
		elif [ -f "$(git-dir)/BISECT_LOG" ]; then
			# TODO: implement
		fi

		if [ -n "$b" ]; then
			:
		elif [ -h "$(git-dir)/HEAD" ]; then
			# symlink symbolic ref
			b="$(git symbolic-ref HEAD 2>/dev/null)"
		else
			local head;
			read head 2>/dev/null < "$(git-dir)/HEAD"
			branch="${head#ref: }"
		fi
	fi

	if [ -n "$step" ] && [ -n "$total" ]; then
		# TODO: implement
	fi
}

echo -n "is-inside-git-dir ? "; is-inside-git-dir && echo yes || echo no;
echo -n "is-bare-repository ? "; is-bare-repository && echo yes || echo no;
echo -n "is-inside-work-tree ? "; is-inside-work-tree && echo yes || echo no;
echo "git-dir: $(git-dir)"
echo "git-sha: $(git-sha)"
