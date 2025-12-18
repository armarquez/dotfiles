#!/bin/zsh
##
# Copyright 2020 Anthony Marquez <@boogeymarquez>
#
# BSD licensed, see LICENSE.txt in this repository.
#
# Airbnb-specific aliases
# This file auto-detects if you're in an Airbnb environment and only loads if so

# Check if a command exists
function can_haz() {
  which "$@" > /dev/null 2>&1
}

# Detect Airbnb environment
_is_airbnb_env() {
    can_haz yak && return 0
    [[ -d "$HOME/dev/airbnb" ]] && return 0
    can_haz airlab && return 0
    [[ -d "$HOME/.airlab" ]] && return 0
    return 1
}

# Only load if in Airbnb environment
if ! _is_airbnb_env; then
    return 0
fi

# --- Airbnb Aliases Start Here ---

alias just_my_branches='git config --add remote.origin.fetch "+refs/heads/amarquez--*:refs/remote/origin/amarquez--*"'
