#!/bin/zsh
##
# Copyright 2020 Anthony Marquez <@boogeymarquez>
#
# BSD licensed, see LICENSE.txt in this repository.
#
# Airbnb-specific configuration
# This file auto-detects if you're in an Airbnb environment and only loads if so

# Check if a command exists
function can_haz() {
  which "$@" > /dev/null 2>&1
}

# Detect Airbnb environment
_is_airbnb_env() {
    # Check for yak CLI (AirDev workspaces)
    can_haz yak && return 0
    # Check for Airbnb dev directory
    [[ -d "$HOME/dev/airbnb" ]] && return 0
    # Check for airlab
    can_haz airlab && return 0
    # Check for Airbnb git config
    [[ -d "$HOME/.airlab" ]] && return 0
    return 1
}

# Only load if in Airbnb environment
if ! _is_airbnb_env; then
    return 0
fi

# --- Airbnb Configuration Starts Here ---

unset -f watch

# Conditional PATH additions
for path_candidate in /usr/local/bin
do
  if [ -d ${path_candidate} ]; then
    export PATH="${path_candidate}:${PATH}"
  fi
done

export ONETOUCHGEN_LDAP_USER=anthony_marquez
export ONETOUCHGEN_ACCEPT_EULA=y
export DATA_DIR=$HOME/dev/airbnb/data

# Load zsh completions
autoload -U compinit; compinit

# Yak CLI completions
if can_haz yak; then
    source <(yak completion zsh)
fi

# GVM (Go Version Manager)
if [ -s ~/.gvm/scripts/gvm ]; then
  source ~/.gvm/scripts/gvm
fi

# Mise activation
if can_haz mise; then
    eval "$(mise activate zsh)"
    # Ensure mise shims take priority over Homebrew for tools like Go
    export PATH="$HOME/.local/share/mise/shims:$PATH"
fi
