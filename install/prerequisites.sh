#!/usr/bin/env bash

install_prerequisities() {
    # If Homebrew package manager is not installed, install it. Otherwise update Homebrew itself.
    which -s brew
    if [[ $? != 0 ]] ; then
        printf "Installing Homebrew package manager\n"
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        printf "Installed Homebrew\n"
    else
        printf "Homebrew is already installed. Updating Homebrew\n"
        brew update
    fi

    # Install Homebrew cask if it is not installed.
    if [[! brew info cask >/dev/null 2>&1 ]] ; then
        printf "Installing Homebrew cask\n"
        brew install cask
    fi
}
