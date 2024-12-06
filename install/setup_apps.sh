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
# Install asdf, a CLI tool for managing different runtime versions of software
# (Node, Java, etc).
# Links:
#   asdf tool: https://asdf-vm.com/
# Arguments:
#   None
# Returns:
#   0 if it was installed successfully, non-zero on error.
#######################################
install_asdf() {
  local asdf_dir
  local asdf_version
  asdf_dir="$HOME/.asdf"
  asdf_version="v0.12.0"
  if ! directory_exists "$asdf_dir"; then
    # Install asdf pre-requisities (https://asdf-vm.com/guide/getting-started.html#_1-install-dependencies)
    brew_install "coreutils"
    # Install asdf
    printf "Installing asdf\n"
    git clone https://github.com/asdf-vm/asdf.git "$asdf_dir" --branch "$asdf_version"
    source "$asdf_dir/asdf.sh"
  else
    printf "asdf is already installed at %s. To update it to the latest stable release, run: asdf update\n" "$asdf_dir"
  fi
}

#######################################
# Add a plugin to asdf.
# Arguments:
#   Plugin name.
#   Plugin URL.
# Returns:
#   0 if it was added successfully, non-zero on error.
#######################################
asdf_add_plugin() {
  local plugin
  local plugin_url
  plugin="$1"
  plugin_url="$2"

  # Check if the plugin exists with the same name and URL
  local existing_url
  existing_url=$(asdf plugin list --urls | grep "^$plugin" | awk '{print $2}')
  if [[ -n "$existing_url" && "$existing_url" != "$plugin_url" ]]; then
    printf "Plugin %s already exists with a different URL: %s\n" "$plugin" "$existing_url"
  elif [[ -n "$existing_url" && "$existing_url" == "$plugin_url" ]]; then
    asdf plugin update "$plugin"
    printf "Plugin %s (%s) is already added.\n" "$plugin" "$plugin_url"
  else
    asdf plugin add "$plugin" "$plugin_url"
    printf "Plugin %s (%s) added.\n" "$plugin_name" "$plugin_url"
  fi
}

#######################################
# Install Node.js using asdf.
# Links:
#   Tool: https://nodejs.org/en
#   asdf plugin: https://github.com/asdf-vm/asdf-nodejs
# Arguments:
#   Version to install.
# Returns:
#   0 if it was installed successfully, non-zero on error.
#######################################
install_nodejs_asdf() {
  local install_version
  install_version="$1"
  if asdf current nodejs >/dev/null 2>&1; then
    printf "Node.js is already installed with asdf. You can check installed versions using: asdf list nodejs\n"
  else
    printf "Installing Node.js\n"
    asdf_add_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"
    NODEJS_CHECK_SIGNATURES=no asdf install nodejs "$install_version"
    asdf global nodejs "$install_version"
    local current_version=$(asdf current nodejs | awk '{print $2}')
    printf "Global Node.js version set to: %s\n" "$current_version"
  fi
}

#######################################
# Install Java (JDK) using asdf.
# Links:
#   Tool: https://adoptium.net/
#   asdf plugin: https://github.com/halcyon/asdf-java.git
# Arguments:
#   Version to install.
# Returns:
#   0 if it was installed successfully, non-zero on error.
#######################################
install_java_asdf() {
  local install_version
  install_version="$1"
  if asdf current java >/dev/null 2>&1; then
    printf "Java is already installed with asdf. You can check installed versions using: asdf list java\n"
  else
    printf "Installing Java\n"
    asdf_add_plugin "java" "https://github.com/halcyon/asdf-java.git"
    asdf install java "$install_version"
    asdf global java "$install_version"
    local current_version=$(asdf current java | awk '{print $2}')
    printf "Global Java version set to: %s\n" "$current_version"
  fi
}

#######################################
# Install Golang using asdf.
# Links:
#   Tool: https://go.dev/
#   asdf plugin: https://github.com/kennyp/asdf-golang
# Arguments:
#   Version to install.
# Returns:
#   0 if it was installed successfully, non-zero on error.
#######################################
install_go_asdf() {
  local install_version
  install_version="$1"
  if asdf current golang >/dev/null 2>&1; then
    printf "Golang is already installed with asdf. You can check installed versions using: asdf list golang\n"
  else
    printf "Installing Golang\n"
    asdf_add_plugin "golang" "https://github.com/asdf-community/asdf-golang.git"
    asdf install golang "$install_version"
    asdf global golang "$install_version"
    local current_version=$(asdf current golang | awk '{print $2}')
    printf "Global Golang version set to: %s\n" "$current_version"
  fi
}

#######################################
# Install .NET Core SDK using asdf.
# Links:
#   Tool: https://github.com/dotnet/core
#   asdf plugin: https://github.com/emersonsoares/asdf-dotnet-core
# Arguments:
#   Version to install.
# Returns:
#   0 if it was installed successfully, non-zero on error.
#######################################
install_dotnet_core_asdf() {
  local install_version
  install_version="$1"
  if asdf current dotnet-core >/dev/null 2>&1; then
    printf ".NET Core is already installed with asdf. You can check installed versions using: asdf list dotnet-core\n"
  else
    printf "Installing .NET Core\n"
    asdf_add_plugin "dotnet-core" "https://github.com/emersonsoares/asdf-dotnet-core.git"
    asdf install dotnet-core "$install_version"
    asdf global dotnet-core "$install_version"
    local current_version=$(asdf current dotnet-core | awk '{print $2}')
    printf "Global .NET Core version set to: %s\n" "$current_version"
  fi
}

#######################################
# Install Kubernetes CLI (kubectl) using asdf.
# Links:
#   Tool: https://kubernetes.io/docs/reference/kubectl/
#   asdf plugin: https://github.com/asdf-community/asdf-kubectl.git
# Arguments:
#   Version to install.
# Returns:
#   0 if it was installed successfully, non-zero on error.
#######################################
install_kubectl_asdf() {
  local install_version
  install_version="$1"
  if asdf current kubectl >/dev/null 2>&1; then
    printf "Kubectl is already installed with asdf. You can check installed versions using: asdf list kubectl\n"
  else
    printf "Installing Kubernetes CLI (kubectl)\n"
    asdf_add_plugin "kubectl" "https://github.com/asdf-community/asdf-kubectl.git"
    asdf install kubectl "$install_version"
    asdf global kubectl "$install_version"
    local current_version=$(asdf current kubectl | awk '{print $2}')
    printf "Global kubectl version set to: %s\n" "$current_version"
  fi
}

#######################################
# Install Kustomize using asdf.
# Links:
#   Tool: https://kustomize.io/
#   asdf plugin: https://github.com/Banno/asdf-kustomize.git
# Arguments:
#   Version to install.
# Returns:
#   0 if it was installed successfully, non-zero on error.
#######################################
install_kustomize_asdf() {
  local install_version
  install_version="$1"
  if asdf current kustomize >/dev/null 2>&1; then
    printf "Kustomize is already installed with asdf. You can check installed versions using: asdf list kustomize\n"
  else
    printf "Installing Kustomize\n"
    asdf_add_plugin "kustomize" "https://github.com/Banno/asdf-kustomize.git"
    asdf install kustomize "$install_version"
    asdf global kustomize "$install_version"
    local current_version=$(asdf current kubectl | awk '{print $2}')
    printf "Global Kustomize version set to: %s\n" "$current_version"
  fi
}

#######################################
# Install Skaffold using asdf.
# Links:
#   Tool: https://github.com/GoogleContainerTools/skaffold
#   asdf plugin: https://github.com/nklmilojevic/asdf-skaffold
# Arguments:
#   Version to install.
# Returns:
#   0 if it was installed successfully, non-zero on error.
#######################################
install_skaffold_asdf() {
  local install_version
  install_version="$1"
  if asdf current skaffold >/dev/null 2>&1; then
    printf "Skaffold is already installed with asdf. You can check installed versions using: asdf list skaffold\n"
  else
    printf "Installing Skaffold\n"
    asdf_add_plugin "skaffold" "https://github.com/nklmilojevic/asdf-skaffold.git"
    asdf install skaffold "$install_version"
    asdf global skaffold "$install_version"
    local current_version=$(asdf current skaffold | awk '{print $2}')
    printf "Global Skaffold version set to: %s\n" "$current_version"
  fi
}

#######################################
# Install Terraform using asdf.
# Links:
#   Tool: https://github.com/hashicorp/terraform
#   asdf plugin: https://github.com/asdf-community/asdf-hashicorp.git
# Arguments:
#   Version to install.
# Returns:
#   0 if it was installed successfully, non-zero on error.
#######################################
install_terraform_asdf() {
  local install_version
  install_version="$1"
  if asdf current terraform >/dev/null 2>&1; then
    printf "Terraform is already installed with asdf. You can check installed versions using: asdf list terraform\n"
  else
    printf "Installing Terraform\n"
    asdf_add_plugin "terraform" "https://github.com/asdf-community/asdf-hashicorp.git"
    asdf install terraform "$install_version"
    asdf global terraform "$install_version"
    local current_version=$(asdf current terraform | awk '{print $2}')
    printf "Global Terraform version set to: %s\n" "$current_version"
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
  # jq: a lightweight command-line JSON processor
  brew_install "jq"
  # fzf: a general-purpose command-line fuzzy finder (https://github.com/junegunn/fzf)
  brew_install "fzf"
  $(brew --prefix)/opt/fzf/install
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

  # Install asdf and software tools with asdf
  install_asdf
  install_nodejs_asdf "latest:18"
  install_java_asdf "latest:temurin-17"
  install_go_asdf "latest:1.23"
  install_dotnet_core_asdf "latest:8"
  install_kubectl_asdf "latest:1.29"
  install_skaffold_asdf "latest"
  # Kustomize is blocked on releasing for windows and darwin ARM until #5220 (https://github.com/kubernetes-sigs/kustomize/issues/5220) is resolved.
  # install_kustomize_asdf "latest"
  # install_terraform_asdf "latest"

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
