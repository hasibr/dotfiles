# Utility functions. Source this file before calling the functions.

# Prints informational message.
# Arguments:
#   Informational message.
info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

# Prints a user prompt message.
# Arguments:
#   User prompt message.
user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

# Prints success message.
# Arguments:
#   Success message.
success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

# Prints failure message and exits program.
# Arguments:
#   Failure message.
fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

# Returns true if a directory exists.
# Arguments:
#   Directory path.
directory_exists() {
  if [[ -d "$1" ]] ; then
    true
  else
    false
  fi
}

# Returns true if a file exists.
# Arguments:
#   File path.
file_exists() {
  if [[ -e "$1" ]] ; then
    true
  else
    false
  fi
}

# Returns true if a package / cask was installed using Homebrew.
# Arguments:
#   Package name.
is_installed_with_brew() {
  if brew list $1 &>/dev/null; then
    true
  elif brew list --cask $1 &>/dev/null; then
    true
  else
    false
  fi
}

# Installs package using Homebrew package manager (if not already installed).
# Arguments:
#   Package name.
brew_install() {
  if is_installed_with_brew "$1"; then
    echo "$1 is already installed."
  else
    echo "Installing $1..."
    brew install $1
    echo "Installed $1"
  fi
}

# Uninstalls package that was installed using Homebrew.
# Arguments:
#   Package name.
brew_uninstall() {
  if is_installed_with_brew "$1"; then
    printf "Uninstalling $1\n"
    brew uninstall $1
  else
    printf "$1 is not installed using Homebrew."
  fi
}

# Installs cask / application using Homebrew package manager (if not already installed).
# Arguments:
#   Package name.
brew_install_cask() {
  if is_installed_with_brew "$1"; then
    echo "$1 is already installed."
  else
    echo "Installing $1..."
    brew install --cask $1
    echo "Installed $1"
  fi
}

# Uninstalls cask / application that was installed using Homebrew.
# Arguments:
#   Package name.
brew_uninstall_cask() {
  if is_installed_with_brew "$1"; then
    printf "Uninstalling $1\n"
    brew uninstall --cask $1
  else
    printf "$1 is not installed using Homebrew."
  fi
}