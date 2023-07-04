#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

# Install tools configured in the dotfiles folder
install_configured_tools() {
    local install_script="install.sh"
    local skip_folders=("bin" "install" "scripts")

    # Find folders in dotfiles directory with a install.sh file (returns list of paths)
    find -H "$DOTFILES" -maxdepth 2 -name "$install_script" | while read app_install_file_path
    do
        # Extract substring from second-last "/" to last "/" to get folder name (app name)
        local folder_name="${app_install_file_path%/*}"
        folder_name="${folder_name##*/}"

        # If folder is in skip_folders array, skip this iteration
        if [[ " ${skip_folders[@]} " =~ " ${folder_name} " ]]; then
            continue
        fi

        printf "Installing $folder_name\n"
        # Make install script executable and run
        chmod +x "$app_install_file_path"
        "$app_install_file_path"
    done
}

# Install asdf, a CLI tool for managing different runtime versions (node, java, etc)
install_asdf() {
    # Install oh-my-zsh
    local asdf_dir="$HOME/.asdf"
    local asdf_version="v0.12.0"
    if ! directory_exists "$asdf_dir"; then
        # Install asdf pre-requisities (https://asdf-vm.com/guide/getting-started.html#_1-install-dependencies)
        brew_install "coreutils"
        # Install asdf
        printf "Installing asdf\n"
        git clone https://github.com/asdf-vm/asdf.git "$asdf_dir" --branch "$asdf_version"
        source "$asdf_dir/asdf.sh"
    else
        printf "asdf is already installed at $asdf_dir\n"
    fi
}

# Adds a plugin to asdf.
# Arguments:
#   Plugin name.
#   Plugin url.
asdf_add_plugin() {
    local plugin="$1"
    local plugin_url="$2"

    # Check if the plugin exists with the same name and URL
    local existing_url=$(asdf plugin list --urls | grep "^$plugin" | awk '{print $2}')
    if [[ -n "$existing_url" && "$existing_url" != "$plugin_url" ]]; then
        printf "Plugin $plugin already exists with a different URL: $existing_url\n"
    elif [[ -n "$existing_url" && "$existing_url" == "$plugin_url" ]]; then
        asdf plugin update "$plugin"
        printf "Plugin $plugin ($plugin_url) is already added.\n"
    else
        asdf plugin add "$plugin" "$plugin_url"
        printf "Plugin $plugin_name ($plugin_url) added.\n"
    fi
}

# Install Node.js with asdf
install_nodejs_asdf() {
    # Check if Node.js is already installed with asdf
    if asdf list nodejs >/dev/null 2>&1; then
        printf "Node.js is already installed with asdf. You can check installed versions using: asdf list nodejs\n"
    else
        local install_version="latest:18"
        printf "Installing Node.js\n"
        asdf_add_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"
        NODEJS_CHECK_SIGNATURES=no asdf install nodejs "$install_version"
        asdf global nodejs "$install_version"
        local current_version=$(asdf current nodejs | awk '{print $2}')
        printf "Global Node.js version set to: $current_version\n"
    fi
}

# Install Java (JDK) with asdf
install_java_asdf() {
    if asdf list java >/dev/null 2>&1; then
        printf "Java is already installed with asdf. You can check installed versions using: asdf list java\n"
    else
        local install_version="latest:adoptopenjdk-17"
        printf "Installing Java\n"
        asdf_add_plugin "java" "https://github.com/halcyon/asdf-java.git"
        asdf install java "$install_version"
        asdf global java "$install_version"
        local current_version=$(asdf current java | awk '{print $2}')
        printf "Global Java version set to: $current_version\n"
    fi
}

# Install other tools
install_other_tools() {
    # jq, a lightweight command-line JSON processor
    brew_install "jq"
    # fzf, a general-purpose command-line fuzzy finder (https://github.com/junegunn/fzf)
    brew_install "fzf"
    $(brew --prefix)/opt/fzf/install
    # exa, a replacement for ls
    brew_install "exa"

    # Install asdf and software tools with asdf
    install_asdf
    install_nodejs_asdf
    install_java_asdf
}

# Install applications
install_other_apps() {
    brew_install_cask "istat-menus"
    brew_install_cask "alfred"
    brew_install_cask "spotify"
    brew_install_cask "hiddenbar"
}