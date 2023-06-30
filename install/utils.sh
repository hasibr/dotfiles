# Utility functions. Source this file before calling the functions.

# Prints informational message. Example:
# info "Installed dotfiles"
info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

# Prints a user prompt message. Example:
# user "What would you like to do? "
user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

# Prints success message. Example:
# success "Installed dotfiles"
success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

# Prints failure message and exits program. Example:
# fail "Failed to install dotfiles"
fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

# Returns true if a file exists. Example:
# if directory_exists "$HOME/dotfiles"; then
directory_exists() {
  if [[ -d "$1" ]] ; then
    true
  else
    false
  fi
}

# Returns true if a file exists. Example:
# if file_exists "$HOME/dotfiles/README.md"; then
file_exists() {
  if [[ -e "$1" ]] ; then
    true
  else
    false
  fi
}

# Installs package using Homebrew package manager (if not already installed). Example:
# brew_install "neovim"
brew_install() {
  if brew list $1 &>/dev/null; then
    echo "$1 is already installed."
  else
    echo "Installing $1..."
    brew install $1
    echo "Installed $1"
  fi
}

# Installs cask / application using Homebrew package manager (if not already installed). Example:
# brew_install_cask "google-chrome"
brew_install_cask() {
  if brew list --cask $1 &>/dev/null; then
    echo "$1 is already installed."
  else
    echo "Installing $1..."
    brew install --cask $1
    echo "Installed $1"
  fi
}