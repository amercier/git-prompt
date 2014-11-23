git-prompt.sh
=============

Highly configurable shell prompt helper for Git

[![Build Status](http://img.shields.io/travis/amercier/git-prompt.sh.svg?style=flat-square)](https://travis-ci.org/amercier/git-prompt.sh)

Installation
------------

TODO

Without git-prompt.sh:

    export $PS1='[\u@\h \[\033[1;36m\]\w\[\033[0m\]]\$ '

With git-prompt.sh:

    export $PS1='[\u@\h \[\033[1;36m\]\w\[\033[0m\]$(path/to/git/prompt.sh)]\$ '


Usage
-----

    git-prompt.sh [options]

### Options

    -p, --prefix   Prefix, defaults to ' '
    -s, --suffix   Prefix, defaults to ''

    -b, --branch   Customize branch




    #
# NAME
#        bash
#
# SYNOPSIS
#        
#
# DESCRIPTION
#        git-prompt.sh is a script to display the Git status on a shell prompt.
#        Typical usage is to add the following in ~/.bashrc:
#

#
# OPTIONS
#        By default, 
#       
#

