#!/bin/bash
# .init.sh - Runs ONCE at initial setup
# This script sets up the dotfiles environment
set -e

echo "==> Initializing dotfiles..."

# Define the dotfiles bare repo location
DOTFILES_DIR="$HOME/.dotfiles"

# Install zgenom if not present
if [ ! -d "$HOME/.zqs-zgenom" ] && [ ! -d "$HOME/zgenom" ]; then
    echo "==> Installing zgenom..."
    git clone https://github.com/jandamm/zgenom.git "$HOME/.zqs-zgenom"
fi

# Use stow to symlink zsh configuration files if stow is available
# Otherwise, create symlinks manually
cd "$HOME/.dotfiles" 2>/dev/null || cd "$(dirname "$0")"

if command -v stow &> /dev/null; then
    echo "==> Using stow to symlink zsh configuration..."
    # Stow the zsh directory - this symlinks files from zsh/zsh/ to ~/
    stow --target="$HOME" --dir=zsh zsh 2>/dev/null || {
        echo "==> Stow failed, falling back to manual symlinks..."
        _manual_symlinks=true
    }
else
    echo "==> GNU stow not found, using manual symlinks..."
    _manual_symlinks=true
fi

if [ "$_manual_symlinks" = true ]; then
    # Get the directory where this script lives (the dotfiles repo)
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

    # Create symlinks for zsh configuration files
    for file in .zshrc .zsh_aliases .zsh_functions .zgen-setup; do
        if [ -f "$SCRIPT_DIR/zsh/zsh/$file" ]; then
            # Backup existing file if it's not a symlink
            if [ -f "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
                echo "==> Backing up existing $file to ${file}.bak"
                mv "$HOME/$file" "$HOME/${file}.bak"
            fi
            # Remove existing symlink if present
            [ -L "$HOME/$file" ] && rm "$HOME/$file"
            ln -sf "$SCRIPT_DIR/zsh/zsh/$file" "$HOME/$file"
            echo "==> Linked $file"
        fi
    done

    # Create .zshrc.d directory and symlink contents
    mkdir -p "$HOME/.zshrc.d"
    if [ -d "$SCRIPT_DIR/zsh/zsh/.zshrc.d" ]; then
        for file in "$SCRIPT_DIR/zsh/zsh/.zshrc.d"/*; do
            if [ -f "$file" ]; then
                filename=$(basename "$file")
                [ -L "$HOME/.zshrc.d/$filename" ] && rm "$HOME/.zshrc.d/$filename"
                ln -sf "$file" "$HOME/.zshrc.d/$filename"
                echo "==> Linked .zshrc.d/$filename"
            fi
        done
    fi
fi

# Create necessary directories
mkdir -p "$HOME/.zshrc.d"
mkdir -p "$HOME/.zshrc.pre-plugins.d"
mkdir -p "$HOME/.zshrc.add-plugins.d"

# Create a pre-plugins file to configure settings before plugins load
cat > "$HOME/.zshrc.pre-plugins.d/000-workspace-config" << 'EOF'
# Workspace configuration
# Suppress powerlevel10k instant prompt warnings
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
EOF

# Disable SSH key listing/loading for cloud workspaces (uses different auth)
mkdir -p "$HOME/.zqs-settings"
echo "false" > "$HOME/.zqs-settings/list-ssh-keys"
echo "false" > "$HOME/.zqs-settings/load-ssh-keys"

# Install fzf if not present (required for history search)
if ! command -v fzf &> /dev/null; then
    echo "==> Installing fzf..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y fzf 2>/dev/null || true
    elif command -v brew &> /dev/null; then
        brew install fzf 2>/dev/null || true
    else
        # Manual install
        git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf" 2>/dev/null || true
        "$HOME/.fzf/install" --all --no-bash --no-fish 2>/dev/null || true
    fi
fi

# Install just command runner if not present
if ! command -v just &> /dev/null; then
    echo "==> Installing just command runner..."
    if command -v apt-get &> /dev/null; then
        # For Debian/Ubuntu - use prebuilt binary
        curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to "$HOME/.local/bin" 2>/dev/null || true
    elif command -v brew &> /dev/null; then
        brew install just 2>/dev/null || true
    else
        # Fallback: install to ~/.local/bin
        mkdir -p "$HOME/.local/bin"
        curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to "$HOME/.local/bin" 2>/dev/null || true
    fi
fi

echo "==> Dotfiles initialization complete!"
echo "==> Your zsh configuration will be loaded on next shell startup."
