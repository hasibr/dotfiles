#!/usr/bin/env bash
#
# Contains functions to install tools and applications.

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

#######################################
# Install each tool listed as folders in the root directory. If the folder has
# a install.sh shell script, run the script to install the tool. Otherwise,
# skip it.
# Arguments:
#   None
# Returns:
#   0 if each tool was installed successfully, non-zero on error.
#######################################
install_tools_in_root_directory() {
  local install_script
  local skip_folders
  install_script="install.sh"
  skip_folders=("bin" "install" "scripts")

  # Find folders in dotfiles directory with a install.sh file (returns list of paths)
  find -H "$DOTFILES" -maxdepth 2 -name "$install_script" | while read app_install_file_path; do
    # Extract substring from second-last "/" to last "/" to get folder name (app name)
    local folder_name
    folder_name="${app_install_file_path%/*}"
    folder_name="${folder_name##*/}"

    # If folder is in skip_folders array, skip this iteration
    if [[ " ${skip_folders[@]} " =~ " ${folder_name} " ]]; then
      continue
    fi

    printf "Installing %s\n" "$folder_name"
    # Make install script executable and run
    chmod +x "$app_install_file_path"
    "$app_install_file_path"
  done
}

#######################################
# Installs a tool using mise-en-place.
# Globals:
#   None
# Arguments:
#   $1 - The tool and optional version in format "tool" or "tool@version". If
#        no version is specified, it will install "tool@latest".
#   $2 - Whether to set the global tool version (true/false). Defaults to false.
# Returns:
#   0 - If the tool was installed successfully or already present
#   1 - If the installation failed
#######################################
mise_install() {
  local input="$1"
  local install_global="${2:-false}"
  local tool
  local version
  local tool_version

  # Extract tool and version (default to latest if not specified)
  if [[ "${input}" =~ ^([^@]+)@(.+)$ ]]; then
    tool="${BASH_REMATCH[1]}"
    version="${BASH_REMATCH[2]}"
  else
    tool="${input}"
    version="latest"
  fi

  tool_version="${tool}@${version}"

  printf "Installing %s with mise-en-place\\n" "${tool_version}"

  if [[ "${install_global}" == "true" ]]; then
    if mise use --global "${tool_version}"; then
      return 0
    else
      printf "Failed to install %s globally with mise-en-place\\n" "${tool_version}" >&2
      return 1
    fi
  else
    if mise install "${tool_version}"; then
      return 0
    else
      printf "Failed to install %s with mise-en-place\\n" "${tool_version}" >&2
      return 1
    fi
  fi
}

#######################################
# Install an Npm package globally using the current Npm installation.
# Arguments:
#   Name of package.
# Returns:
#   0 if it was installed successfully, non-zero on error.
#######################################
install_npm_package_globally() {
  local package
  local npm_version
  package="$1"
  npm_version=$(npm --version)
  # Check if package is installed globally
  if npm list -g "$package" &>/dev/null; then
    printf "Npm package %s is already installed globally with npm %s.\n" "$package" "$npm_version"
  else
    # Install package globally
    npm install -g "$package"
    printf "Npm package %s has been installed globally with npm %s.\n" "$package" "$npm_version"
  fi
}

#######################################
# Install tools for Go development.
# Arguments:
#   None.
# Returns:
#   0 if it was installed successfully, non-zero on error.
#######################################
install_go_tools() {
  if command -v go >/dev/null 2>&1; then
    printf "Installing tools for Go development.\n"

    # Check and install gofumpt, a stricter code formatter than gofmt
    if ! command -v gofumpt >/dev/null 2>&1; then
      printf "Installing gofumpt...\n"
      go install mvdan.cc/gofumpt@latest
    else
      printf "gofumpt is already installed.\n"
    fi

    # Check and install goimports-reviser, tool for Golang to sort imports
    if ! command -v goimports-reviser >/dev/null 2>&1; then
      printf "Installing goimports-reviser...\n"
      go install -v github.com/incu6us/goimports-reviser/v3@latest
    else
      printf "goimports-reviser is already installed.\n"
    fi

    # Check and install golines, a Go code formatter that shortens long lines
    if ! command -v golines >/dev/null 2>&1; then
      printf "Installing golines...\n"
      go install github.com/segmentio/golines@latest
    else
      printf "golines is already installed.\n"
    fi
  else
    printf "Go is not installed. Skipping installation of tools for Go development.\n"
  fi
}

#######################################
# Install other tools.
# Arguments:
#   None
# Returns:
#   0 if tools were installed successfully, non-zero on error.
#######################################
install_other_tools() {
  # Basic file, shell and text manipulation utilities of the GNU operating
  # system. These are the core utilities which are expected to exist on every
  # operating system.
  brew_install "coreutils"
  # jq: a lightweight command-line JSON processor
  brew_install "jq"
  # fzf: a general-purpose command-line fuzzy finder (https://github.com/junegunn/fzf)
  brew_install "fzf"
  # ripgrep: a line-oriented search tool (https://github.com/BurntSushi/ripgrep)
  # Required for Telescope in Neovim
  brew_install "ripgrep"
  # zoxide: a smart cd command that can be used to jump to most frequently used
  # directories
  brew_install "zoxide"
  # eza (https://github.com/eza-community/eza): a replacement for ls
  brew_install "eza"
  # Redis server and redis-cli
  brew_install "redis"
  # Postgresql server and psql cli
  brew_install "postgresql@17"

  # Install tools with mise
  mise_install "node@22" true
  mise_install "dotnet-core@8" true
  mise_install "dotnet-core@6" false
  mise_install "go-sdk" true
  mise_install "java@temurin-17" true
  mise_install "kubectl@1.30" true
  mise_install "kustomize" true
  mise_install "skaffold" true
#  mise_install_global "terraform" true

  # Install awsp (AWS profile switcher) tool: https://github.com/johnnyopao/awsp
  install_npm_package_globally "awsp"
  install_go_tools
}

#######################################
# Install desktop applications.
# Arguments:
#   None
# Returns:
#   0 if applications were installed successfully, non-zero on error.
#######################################
install_other_apps() {
  #    brew_install_cask "istat-menus"
  brew_install_cask "alfred"
  brew_install_cask "spotify"
  brew_install_cask "hiddenbar"
}
