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
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

#######################################
# Prints a user prompt message.
# Arguments:
#   The message to print.
# Outputs:
#   Writes message to stdout.
#######################################
user() {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

#######################################
# Prints success message.
# Arguments:
#   The message to print.
# Outputs:
#   Writes message to stdout.
#######################################
success() {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

#######################################
# Prints failure message and exits program.
# Arguments:
#   The message to print.
# Outputs:
#   Writes message to stdout.
#######################################
fail() {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
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
    echo "$1 is already installed.\n"
  else
    echo "Installing $1...\n"
    brew install $1
    echo "Installed $1\n"
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
    printf "Uninstalling $1\n"
    brew uninstall $1
  else
    printf "$1 is not installed using Homebrew.\n"
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
    echo "$1 is already installed.\n"
  else
    echo "Installing $1...\n"
    brew install --cask $1
    echo "Installed $1\n"
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
    printf "Uninstalling $1\n"
    brew uninstall --cask $1
  else
    printf "$1 is not installed using Homebrew.\n"
  fi
}
