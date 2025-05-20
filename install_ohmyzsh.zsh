#!/usr/bin/env zsh

OHMYZSH_URL="http://install.ohmyz.sh/"

# Remove any existing oh-my-zsh installation
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Removing existing oh-my-zsh installation..."
    rm -rf $HOME/.oh-my-zsh
fi

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    echo "curl is not installed. Please install curl and try again."
    exit 1
fi

# Check if zsh is installed
if ! command -v zsh &> /dev/null; then
    echo "zsh is not installed. Please install zsh and try again."
    exit 1
fi

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "git is not installed. Please install git and try again."
    exit 1
fi

# Install oh my zsh via curl
(curl -k -fsSL $OHMYZSH_URL | zsh) \
    || { echo "Failed to install oh-my-zsh. Exiting."; exit 1; }

# Install .zshrc and .zsh_aliases if have the install_dotfiles command
if ! command -v install_dotfiles &> /dev/null; then
    git clone http.sslVerify=false http://github.com/aaweaver-actuary/dotfiles
    cp ./dotfiles/install_dotfiles /usr/bin/install_dotfiles
    rm -rf ./dotfiles
fi
chmod +x /usr/bin/install_dotfiles
install_dotfiles ~ .zshrc .zsh_aliases

# Reload the shell
exec zsh