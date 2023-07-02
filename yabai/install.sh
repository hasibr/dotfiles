source "$(dirname "${BASH_SOURCE[0]}")/../install/utils.sh"
brew_install "koekeishiya/formulae/yabai"
# Start service after installation
yabai --start-service &>/dev/null
