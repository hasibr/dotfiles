#!/usr/bin/env bash

# Setup script

# ░░░  ░██████╗███████╗████████╗██╗░░░██╗██████╗░
# ░░░  ██╔════╝██╔════╝╚══██╔══╝██║░░░██║██╔══██╗
# ░░░  ╚█████╗░█████╗░░░░░██║░░░██║░░░██║██████╔╝
# ░░░  ░╚═══██╗██╔══╝░░░░░██║░░░██║░░░██║██╔═══╝░
# ██╗  ██████╔╝███████╗░░░██║░░░╚██████╔╝██║░░░░░
# ╚═╝  ╚═════╝░╚══════╝░░░╚═╝░░░░╚═════╝░╚═╝░░░░░
echo -e "\n░░░  ░██████╗███████╗████████╗██╗░░░██╗██████╗░\n░░░  ██╔════╝██╔════╝╚══██╔══╝██║░░░██║██╔══██╗\n░░░  ╚█████╗░█████╗░░░░░██║░░░██║░░░██║██████╔╝\n░░░  ░╚═══██╗██╔══╝░░░░░██║░░░██║░░░██║██╔═══╝░\n██╗  ██████╔╝███████╗░░░██║░░░╚██████╔╝██║░░░░░\n╚═╝  ╚═════╝░╚══════╝░░░╚═╝░░░░╚═════╝░╚═╝░░░░░\n"

# Enable interpretation of backslash escapes
set -e

# Set DOTFILES variable for the current shell session
cd "$(dirname "$0")/.."
export DOTFILES=$(pwd -P)

source "$DOTFILES/install/utils.sh"
source "$DOTFILES/install/prerequisites.sh"
source "$DOTFILES/install/install-fonts.sh"
source "$DOTFILES/install/install-apps.sh"
source "$DOTFILES/install/setup-dotfiles.sh"
source "$DOTFILES/install/post-setup.sh"

info "Installing prerequisties"
install_prerequisities
success "Prerequisites installed"

info "Installing fonts"
install_fonts
success "Fonts installed"

info "Installing configured tools"
install_configured_tools
success "Tools installed"

info "Setting up configurations / dotfiles (creating symbolic links to application config files)"
setup_dotfiles
success "Configurations (dotfiles) are set up"

info "Installing other tools"
install_other_tools
success "Tools installed"

info "Installing other applications"
install_other_apps
success "Applications installed"

info "Running post-setup"
run_post_setup_for_configured_apps
success "Post-setup completed"

info "Configuring system"
if [ "$(uname)" == "Darwin" ]; then
  source "$(dirname "${BASH_SOURCE[0]}")/configure-system-macos.sh"
elif [ "$(uname)" == "Linux" ]; then
  echo "System configuration for Linux not supported."
fi
success "System configured. Note that some of these changes require a logout/restart to take effect."

success "Setup complete!"