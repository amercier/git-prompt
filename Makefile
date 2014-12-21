# git-prompt's Makefile
# =====================

.PHONY: test clean

vendor/roundup/Makefile:
	git clone git://github.com/bmizerany/roundup.git vendor/roundup

vendor/roundup/roundup: vendor/roundup/Makefile
	cd vendor/roundup && ./configure
	cd vendor/roundup && make

test: vendor/roundup/roundup
	cd tests && ../vendor/roundup/roundup
