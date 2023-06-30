#!/usr/bin/env bash

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
        # Make install script executable
        chmod +x "$app_install_file_path"
        # Run install script
        "$app_install_file_path"
    done
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
}

# Install applications
install_other_apps() {
    brew_install_cask "istat-menus"
    brew_install_cask "alfred"
    brew_install_cask "slack"
    brew_install_cask "notion"
    brew_install_cask "spotify"
    brew_install_cask "readdle-spark"
    brew_install_cask "rancher"
}