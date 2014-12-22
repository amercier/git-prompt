# git-prompt's Makefile
# =====================

.PHONY: test clean

clean:
	rm -rf vendor

vendor/roundup/Makefile:
	git clone git://github.com/bmizerany/roundup.git vendor/roundup
	cd vendor/roundup && git config --add remote.origin.fetch '+refs/pull/*/head:refs/remotes/origin/pr/*'
	cd vendor/roundup && git fetch origin
	cd vendor/roundup && git checkout pr/30

vendor/roundup/roundup: vendor/roundup/Makefile
	cd vendor/roundup && ./configure
	cd vendor/roundup && make

test: vendor/roundup/roundup
	cd tests && ../vendor/roundup/roundup
