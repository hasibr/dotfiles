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

    printf "Installing $folder_name"
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
    printf "Installing asdf"
    git clone https://github.com/asdf-vm/asdf.git "$asdf_dir" --branch "$asdf_version"
    source "$asdf_dir/asdf.sh"
  else
    printf "asdf is already installed at $asdf_dir. To update it to the latest stable release, run: asdf update"
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
    printf "Plugin $plugin already exists with a different URL: $existing_url"
  elif [[ -n "$existing_url" && "$existing_url" == "$plugin_url" ]]; then
    asdf plugin update "$plugin"
    printf "Plugin $plugin ($plugin_url) is already added."
  else
    asdf plugin add "$plugin" "$plugin_url"
    printf "Plugin $plugin_name ($plugin_url) added."
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
  # Check if Node.js is already installed with asdf
  if asdf current nodejs >/dev/null 2>&1; then
    printf "Node.js is already installed with asdf. You can check installed versions using: asdf list nodejs"
  else
    printf "Installing Node.js"
    asdf_add_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"
    NODEJS_CHECK_SIGNATURES=no asdf install nodejs "$install_version"
    asdf global nodejs "$install_version"
    local current_version=$(asdf current nodejs | awk '{print $2}')
    printf "Global Node.js version set to: $current_version"
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
    printf "Java is already installed with asdf. You can check installed versions using: asdf list java"
  else
    printf "Installing Java"
    asdf_add_plugin "java" "https://github.com/halcyon/asdf-java.git"
    asdf install java "$install_version"
    asdf global java "$install_version"
    local current_version=$(asdf current java | awk '{print $2}')
    printf "Global Java version set to: $current_version"
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
    printf "Golang is already installed with asdf. You can check installed versions using: asdf list golang"
  else
    printf "Installing Golang"
    asdf_add_plugin "golang" "https://github.com/kennyp/asdf-golang.git"
    asdf install golang "$install_version"
    asdf global golang "$install_version"
    local current_version=$(asdf current golang | awk '{print $2}')
    printf "Global Golang version set to: $current_version"
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
    printf ".NET Core is already installed with asdf. You can check installed versions using: asdf list dotnet-core"
  else
    printf "Installing .NET Core"
    asdf_add_plugin "dotnet-core" "https://github.com/emersonsoares/asdf-dotnet-core.git"
    asdf install dotnet-core "$install_version"
    asdf global dotnet-core "$install_version"
    local current_version=$(asdf current dotnet-core | awk '{print $2}')
    printf "Global .NET Core version set to: $current_version"
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
    printf "Kubectl is already installed with asdf. You can check installed versions using: asdf list kubectl"
  else
    printf "Installing Kubernetes CLI (kubectl)"
    asdf_add_plugin "kubectl" "https://github.com/asdf-community/asdf-kubectl.git"
    asdf install kubectl "$install_version"
    asdf global kubectl "$install_version"
    local current_version=$(asdf current kubectl | awk '{print $2}')
    printf "Global kubectl version set to: $current_version"
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
    printf "Kustomize is already installed with asdf. You can check installed versions using: asdf list kustomize"
  else
    printf "Installing Kustomize"
    asdf_add_plugin "kustomize" "https://github.com/Banno/asdf-kustomize.git"
    asdf install kustomize "$install_version"
    asdf global kustomize "$install_version"
    local current_version=$(asdf current kubectl | awk '{print $2}')
    printf "Global Kustomize version set to: $current_version"
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
    printf "Skaffold is already installed with asdf. You can check installed versions using: asdf list skaffold"
  else
    printf "Installing Skaffold"
    asdf_add_plugin "skaffold" "https://github.com/nklmilojevic/asdf-skaffold.git"
    asdf install skaffold "$install_version"
    asdf global skaffold "$install_version"
    local current_version=$(asdf current kubectl | awk '{print $2}')
    printf "Global Skaffold version set to: $current_version"
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
    printf "Terraform is already installed with asdf. You can check installed versions using: asdf list terraform"
  else
    printf "Installing Terraform"
    asdf_add_plugin "terraform" "https://github.com/asdf-community/asdf-hashicorp.git"
    asdf install terraform "$install_version"
    asdf global terraform "$install_version"
    local current_version=$(asdf current terraform | awk '{print $2}')
    printf "Global Terraform version set to: $current_version"
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
  package="$1"
  # Check if package is installed globally
  if npm list -g "$package" &>/dev/null; then
    printf "Npm package $package is already installed globally."
  else
    # Install package globally
    npm install -g "$package"
    printf "Npm package $package has been installed globally."
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
  # jq, a lightweight command-line JSON processor
  brew_install "jq"
  # fzf, a general-purpose command-line fuzzy finder (https://github.com/junegunn/fzf)
  brew_install "fzf"
  $(brew --prefix)/opt/fzf/install
  # exa, a replacement for ls
  brew_install "exa"
  # Redis server and redis-cli
  brew_install "redis"
  # Postgresql server and psql cli
  brew_install "postgresql@16"

  # Install asdf and software tools with asdf
  install_asdf
  install_nodejs_asdf "latest:18"
  install_java_asdf "latest:temurin-17"
  # install_go_asdf "latest"
  install_dotnet_core_asdf "latest:6"
  # install_kubectl_asdf "latest:1.26"
  # Kustomize is blocked on releasing for windows and darwin ARM until #5220 (https://github.com/kubernetes-sigs/kustomize/issues/5220) is resolved.
  # install_kustomize_asdf "latest"
  # install_terraform_asdf "latest"

  # Install awsp (AWS profile switcher) tool: https://github.com/johnnyopao/awsp
  install_npm_package_globally "awsp"
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
