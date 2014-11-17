#!/usr/bin/env bash

# git_status="?"
# git_dirty="?"

# # see $git_status
# function git-status {
#   if [ "$git_status" == "?" ]; then
#     git_status="$(git status 2>&1)"
#   fi
#   echo -n "$git_status"
# }

# function is-git-repo {
#   if [ "$(git-status | grep 'Not a git repository') | wc -l" == "0" ]; then
#     return 0
#   else
#     return 1
#   fi
# }

# # see $git_dirty
# # function git-dirty {
# #   if is-git-repo && [ "$(git-status | tail -n 1)" != "nothing to commit, working directory clean" ]; then
# #     echo '*'
# #   fi
# # }

# git-ahead

function git-prompt {
  echo -n ""
}
