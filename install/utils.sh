#!/usr/bin/env bash
#
# Collection of utility functions.

#######################################
# Prints informational message.
# Arguments:
#   The message to print.
# Outputs:
#   Writes message to stdout.
#######################################
info() {
  printf "\r  [ \033[00;34m..\033[0m ] %s\n" "$1"
}

#######################################
# Prints a user prompt message.
# Arguments:
#   The message to print.
# Outputs:
#   Writes message to stdout.
#######################################
user() {
  printf "\r  [ \033[0;33m??\033[0m ] %s\n" "$1"
}

#######################################
# Prints success message.
# Arguments:
#   The message to print.
# Outputs:
#   Writes message to stdout.
#######################################
success() {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] %s\n" "$1"
}

#######################################
# Prints failure message and exits program.
# Arguments:
#   The message to print.
# Outputs:
#   Writes message to stdout.
#######################################
fail() {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] %s\n" "$1"
  echo ""
  exit
}

#######################################
# Checks if a directory exists.
# Arguments:
#   The directory path.
# Returns:
#   0 if the directory exists, 1 if it does not.
#######################################
directory_exists() {
  if [[ -d "$1" ]]; then
    true
  else
    false
  fi
}

#######################################
# Checks if a file exists.
# Arguments:
#   The file path.
# Returns:
#   0 if the file exists, 1 if it does not.
#######################################
file_exists() {
  if [[ -e "$1" ]]; then
    true
  else
    false
  fi
}

#######################################
# Checks if a package or cask was installed using Homebrew.
# Arguments:
#   The name of the package or cask.
# Returns:
#   0 if the package or cask was installed using Homebrew, 1 if it was not.
#######################################
is_installed_with_brew() {
  if brew list $1 &>/dev/null; then
    true
  elif brew list --cask $1 &>/dev/null; then
    true
  else
    false
  fi
}

#######################################
# Installs package using Homebrew package manager (if not already installed).
# Arguments:
#   The name of the package.
# Returns:
#   0 if the package was installed successfully, non-zero if there was an error.
#######################################
brew_install() {
  if is_installed_with_brew "$1"; then
    printf "%s is already installed with Homebrew.\n" "$1"
  else
    printf "Installing %s with Homebrew.\n" "$1"
    brew install $1
    printf "Installed %s with Homebrew.\n" "$1"
  fi
}

#######################################
# Uninstalls a package that was installed using Homebrew.
# Arguments:
#   The name of the package.
# Returns:
#   0 if the package was uninstalled successfully, non-zero if there was an error.
#######################################
brew_uninstall() {
  if is_installed_with_brew "$1"; then
    printf "Uninstalling %s with Homebrew.\n" "$1"
    brew uninstall $1
  else
    printf "%s is not installed using Homebrew.\n" "$1"
  fi
}

#######################################
# Installs a cask/application using Homebrew package manager (if not already installed).
# Arguments:
#   The name of the cask/application.
# Returns:
#   0 if the cask/application was installed successfully, non-zero if there was an error.
#######################################
brew_install_cask() {
  if is_installed_with_brew "$1"; then
    printf "%s is already installed with Homebrew Cask.\n" "$1"
  else
    printf "Installing %s with Homebrew Cask.\n" "$1"
    brew install --cask $1
    printf "Installed %s with Homebrew Cask.\n" "$1"
  fi
}

#######################################
# Uninstalls a cask/application that was installed using Homebrew.
# Arguments:
#   The name of the cask/application.
# Returns:
#   0 if the cask/application was uninstalled successfully, non-zero if there was an error.
#######################################
brew_uninstall_cask() {
  if is_installed_with_brew "$1"; then
    printf "Uninstalling %s with Homebrew Cask.\n" "$1"
    brew uninstall --cask $1
  else
    printf "%s is not installed using Homebrew Cask.\n" "$1"
  fi
}
