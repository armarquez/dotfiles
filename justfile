# Dotfiles management justfile

# Default recipe - show available commands
default:
    @just --list

# Run the init script (one-time setup)
init:
    ./.init.sh

# Run the startup script
startup:
    ./.startup.sh

# Symlink dotfiles using stow
stow:
    cd zsh && stow --target="$HOME" zsh

# Remove symlinks created by stow
unstow:
    cd zsh && stow --delete --target="$HOME" zsh

# Re-stow (useful after adding new files)
restow:
    cd zsh && stow --restow --target="$HOME" zsh

# Add zsh-quickstart-kit as a remote (safe to run multiple times)
setup-zsh-remote:
    #!/usr/bin/env bash
    if git remote get-url zsh-quickstart-kit &>/dev/null; then
        echo "Remote 'zsh-quickstart-kit' already exists"
        git remote get-url zsh-quickstart-kit
    else
        git remote add zsh-quickstart-kit git@github.com:unixorn/zsh-quickstart-kit.git
        echo "Added remote 'zsh-quickstart-kit'"
    fi

# Fetch zsh-quickstart-kit without merging (safe, just updates remote refs)
fetch-zsh:
    git fetch zsh-quickstart-kit main

# Update zsh-quickstart-kit subtree from upstream (may require conflict resolution)
update-zsh: setup-zsh-remote fetch-zsh
    @echo "Pulling zsh-quickstart-kit subtree. If conflicts occur, resolve them and run 'git commit'"
    git subtree pull --prefix zsh zsh-quickstart-kit main --squash

# Update zgenom plugins
update-plugins:
    zsh -c 'source ~/.zshrc && zgenom update'

# Clean unused zgenom plugins
clean-plugins:
    zsh -c 'source ~/.zshrc && zgenom clean'

# Regenerate zgenom init.zsh
regen:
    rm -f ~/.zgenom/init.zsh
    zsh -c 'source ~/.zshrc'

# Show current git status
status:
    @git status --short

# Reconfigure powerlevel10k prompt
p10k:
    zsh -c 'p10k configure'
