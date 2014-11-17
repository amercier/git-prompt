#!/usr/bin/env bash
#
# Generic bash test runner
# ========================
#
# Run all *.sh scripts within the tests directory. All tests are run in a
# sub-shell in a temporary folder.
#
# Type of results
# ---------------
#
# - [.] Success. The test has passed
# - [F] Failure. The test has failed
# - [E] Exception. An error has occured during the test
#
# Test scripts requirements
# --------------------
#
# - Test must exit with 0 (success) or any other number (failure)
# - A test must not produce any output (neither on stdin or stdout)
# - Every time an output is produced on stdout or stderr, it is considered as a
#   failure

TESTS_DIR=tests

source src/colors.sh

cwd="$(pwd)"
stdout=$(mktemp 2>/dev/null || mktemp -t 'git-prompt-stdout')
stderr=$(mktemp 2>/dev/null || mktemp -t 'git-prompt-stderr')
tmpstdout=$(mktemp 2>/dev/null || mktemp -t 'git-prompt-stdout')
tmpstderr=$(mktemp 2>/dev/null || mktemp -t 'git-prompt-stderr')

declare -i tests_run=0
declare -i tests_failed=0
declare -i tests_exceptions=0

test_files="$(find "$cwd/tests" -type f -name '*.sh')"
echo
while read filename; do

  # Make a temporary directory
  # see http://unix.stackexchange.com/questions/30091/fix-or-alternative-for-mktemp-in-os-x
  tmpdir=$(mktemp -d 2>/dev/null || mktemp -d -t 'git-prompt')

  # Run test inside a separate shell, in the temp directory
  (cd "$tmpdir" && "$filename" "$cwd/src/git-prompt.sh" >"$tmpstdout" 2>"$tmpstderr")

  # Analyse result
  result="$?"
  if [ $(cat "$tmpstdout" "$tmpstderr" | wc -l) != 0 ]; then
    echo -en "${COLOR_TXTPUR}E${COLOR_TXTRST}"
    cat "$tmpstdout" >> "$stdout"
    cat "$tmpstderr" >> "$stderr"
    tests_exceptions=$(( tests_exceptions + 1 ))
  elif [ "$result" == "0" ]; then
    echo -en "${COLOR_TXTGRN}.${COLOR_TXTRST}"
  else
    echo -en "${COLOR_TXTRED}F${COLOR_TXTRST}"
    tests_failed=$(( tests_failed + 1 ))
  fi
  tests_run=$(( tests_run + 1 ))

done <<<"$test_files"

echo -e "\n"

# Display output collected on stdout and stderr (red)
cat "$stdout"
echo -en "$COLOR_TXTRED"
cat "$stderr" >&2
echo -en "$COLOR_TXTRST"

# Report status and exit
if [ "$tests_run" == "0" ]; then
  echo -e "${COLOR_TXTRED}No tests were run${COLOR_TXTRST}"
  exit 1
elif [ "$tests_failed" == "0" ] || [ "$tests_exceptions" == "0" ]; then
  echo -e "${COLOR_TXTGRN}All tests completed successfully${COLOR_TXTRST}"
  exit 0
else
  echo
  echo -e "${COLOR_TXTRED}Some tests failed${COLOR_TXTRST}"
  exit 1
fi
