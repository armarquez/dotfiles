#!/bin/zsh
##
# Copyright 2020 Anthony Marquez <@boogeymarquez>
#
# BSD licensed, see LICENSE.txt in this repository.
#
# Base functions - loaded on all machines

# Check if a command exists
function can_haz() {
  which "$@" > /dev/null 2>&1
}

# General Update
function update_brew() {
    if [[ "$(uname -s)" == "Darwin" ]]; then
        if can_haz brew; then
            brew update
            brew upgrade
        fi
    fi
}

# Brew switch is deprecated, so here is an alternative
# specified here: https://github.com/Homebrew/discussions/discussions/339#discussioncomment-350814
function brew_switch() {
    if [[ "$(uname -s)" == "Darwin" ]]; then
        if can_haz brew; then
            pkg=$1
            version=$2

            brew unlink "$pkg"
            (
                pushd "$(brew --prefix)/opt"
                rm -f "$pkg"
                ln -s "../Cellar/$pkg/$version" "$pkg"
            )
            brew link "$pkg"
        fi
    fi
}
