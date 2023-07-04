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

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"
source "$(dirname "${BASH_SOURCE[0]}")/prerequisites.sh"
source "$(dirname "${BASH_SOURCE[0]}")/install-fonts.sh"
source "$(dirname "${BASH_SOURCE[0]}")/install-apps.sh"
source "$(dirname "${BASH_SOURCE[0]}")/setup-dotfiles.sh"
source "$(dirname "${BASH_SOURCE[0]}")/post-setup.sh"

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
if [[ "$OSTYPE" == "darwin"* ]]; then
  source "$(dirname "${BASH_SOURCE[0]}")/configure-system-macos.sh"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo "System configuration for Linux not supported."
fi
success "System configured. Note that some of these changes require a logout/restart to take effect."

success "Setup complete!"