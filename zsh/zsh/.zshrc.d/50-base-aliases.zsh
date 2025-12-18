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
