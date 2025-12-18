#!/bin/zsh
##
# Copyright 2020 Anthony Marquez <@boogeymarquez>
#
# BSD licensed, see LICENSE.txt in this repository.
#
# Airbnb-specific functions
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

# --- Airbnb Functions Start Here ---

# Clean up dead branches (squash-merged to main)
# From https://gist.git.musta.ch/bruce-sherrod/ad232024768413dad95f2a009b39852c
function delete_dead_branches() {
    # Thanks Toland.Hon@airbnb.com for finding this:
    # https://github.com/not-an-aardvark/git-delete-squashed

    local default_branch="${1:-main}"

    git checkout -q "$default_branch"

    git for-each-ref refs/heads/ "--format=%(refname:short)" | while read -r branch; do
        mergebase=$(git merge-base "$default_branch" "$branch")
        mergepoint=$(git rev-parse "$branch^{tree}")
        tempcommit=$(git commit-tree "$mergepoint" -p "$mergebase" -m _)
        cherry=$(git cherry "$default_branch" "$tempcommit")
        if [[ $cherry == "-"* ]] ; then
            if [ "$2" == "-f" ]; then
                git branch -D "$branch"
            else
                echo git branch -D "$branch"
            fi
        fi
    done

    git checkout -q -
}

# Gradlew wrapper - runs gradlew from repo root
function gwr () {
    $(git rev-parse --show-toplevel)/gradlew $@
}
