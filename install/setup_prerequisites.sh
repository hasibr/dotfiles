#!/usr/bin/env bash
#
# Contains function to install prerequisites for environment setup.

#######################################
# Install Homebrew package manager and Homebrew Cask.
# Arguments:
#   None
# Returns:
#   0 if Homebrew and Homebrew Cask was installed successfully, non-zero on error.
#######################################
install_homebrew_and_cask() {
  # If Homebrew package manager is not installed, install it. Otherwise update Homebrew itself.
  if which brew >/dev/null 2>&1; then
    printf "Homebrew is already installed. Updating Homebrew"
    brew update
  else
    printf "Installing Homebrew package manager"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    # Add brew to PATH
    (
      echo
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
    ) >>$HOME/.zprofile
    # Reload shell to have brew in PATH
    source ~/.zshrc
    eval "$(/opt/homebrew/bin/brew shellenv)"
    printf "Installed Homebrew"
  fi

  # Install Homebrew cask if it is not installed.
  if [[! brew info cask ]] >/dev/null 2>&1; then
    printf "Installing Homebrew cask"
    brew install cask
  fi
}

#######################################
# Install all prerequisites for environment setup.
# Arguments:
#   None
# Returns:
#   0 if all prerequisites were installed successfully, non-zero on error.
#######################################
install_all_prerequisities() {
  install_homebrew_and_cask
}
