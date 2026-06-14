#!/bin/zsh
##
# Copyright 2020 Anthony Marquez <@boogeymarquez>
#
# BSD licensed, see LICENSE.txt in this repository.
#
# Base aliases - loaded on all machines

# Check if a command exists
function can_haz() {
  which "$@" > /dev/null 2>&1
}

# icalBuddy
if [[ -x /usr/local/bin/icalBuddy ]]; then
  alias today="icalBuddy -f -sc -eep \"notes\" -ec \"Contacts\" eventsToday "
fi

# URL decoding and encoding
if can_haz python3 > /dev/null; then
  alias urldecode='python3 -c "import sys, urllib.parse as ul; \
    print(ul.unquote_plus(sys.argv[1]))"'

  alias urlencode='python3 -c "import sys, urllib.parse as ul; \
    print (ul.quote_plus(sys.argv[1]))"'
fi

if is_wsl; then
  # Access Windows VBoxManage if available
  if [[ -x "/mnt/c/Program Files/Oracle/VirtualBox/VBoxManage.exe" ]]; then
    alias vboxmanage="/mnt/c/Program\ Files/Oracle/VirtualBox/VBoxManage.exe"
  fi

  # Use Windows vagrant.exe if present
  if can_haz vagrant.exe; then
    alias vagrant="vagrant.exe"
  fi

  if can_haz op.exe; then
    alias op="op.exe"
  fi
fi
