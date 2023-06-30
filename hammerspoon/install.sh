source "$(dirname "${BASH_SOURCE[0]}")/../install/utils.sh"
brew_install "hammerspoon"
# Hammerspoon places its config files in ~/.hammerspoon. Override the default with:
defaults write org.hammerspoon.Hammerspoon MJConfigFile "$HOME/.config/hammerspoon/init.lua"
