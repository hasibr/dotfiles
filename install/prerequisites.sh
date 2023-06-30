#!/usr/bin/env bash

install_prerequisities() {
    # If Homebrew package manager is not installed, install it. Otherwise update Homebrew itself.
    if which brew >/dev/null 2>&1; then
        printf "Homebrew is already installed. Updating Homebrew\n"
        brew update
    else
        printf "Installing Homebrew package manager\n"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        # Add brew to PATH
        (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> $HOME/.zprofile
        # Reload shell to have brew in PATH
        source ~/.zshrc
        eval "$(/opt/homebrew/bin/brew shellenv)"
        printf "Installed Homebrew\n"
    fi

    # Install Homebrew cask if it is not installed.
    if [[! brew info cask >/dev/null 2>&1 ]] ; then
        printf "Installing Homebrew cask\n"
        brew install cask
    fi
}
