source "$(dirname "${BASH_SOURCE[0]}")/../install/utils.sh"
brew_install "koekeishiya/formulae/skhd"
# Start service after installation
skhd --start-service &>/dev/null
