#!/usr/bin/env bash

cd "$(dirname "$0")/.."
DOTFILES=$(pwd -P)

install_tpm_plugins() {
    local tpm_install_plugins_bin_path="$DOTFILES/tmux/config/plugins/tpm/bin/install_plugins"
    chmod +x "$tpm_install_plugins_bin_path"
    "$tpm_install_plugins_bin_path"
}

main() {
    printf "Installing tmux plugins with tpm\n"
    install_tpm_plugins
}

main