#!/usr/bin/env bash
#
# Install and configure tools and applications for development environment.
# Usage:
# 1. Make the script executable (first time usage):
#       chmod +x ./install/setup.sh
# 2. Run the script:
#       ./install/setup.sh

# Enable exiting immediately if a command exits with a non-zero status
set -e

#######################################
# Main function.
# Arguments:
#   All the arguments passed to the script (i.e. main "$@")
#######################################
main() {
  # ░░░  ░██████╗███████╗████████╗██╗░░░██╗██████╗░
  # ░░░  ██╔════╝██╔════╝╚══██╔══╝██║░░░██║██╔══██╗
  # ░░░  ╚█████╗░█████╗░░░░░██║░░░██║░░░██║██████╔╝
  # ░░░  ░╚═══██╗██╔══╝░░░░░██║░░░██║░░░██║██╔═══╝░
  # ██╗  ██████╔╝███████╗░░░██║░░░╚██████╔╝██║░░░░░
  # ╚═╝  ╚═════╝░╚══════╝░░░╚═╝░░░░╚═════╝░╚═╝░░░░░
  echo -e "\n░░░  ░██████╗███████╗████████╗██╗░░░██╗██████╗░\n░░░  ██╔════╝██╔════╝╚══██╔══╝██║░░░██║██╔══██╗\n░░░  ╚█████╗░█████╗░░░░░██║░░░██║░░░██║██████╔╝\n░░░  ░╚═══██╗██╔══╝░░░░░██║░░░██║░░░██║██╔═══╝░\n██╗  ██████╔╝███████╗░░░██║░░░╚██████╔╝██║░░░░░\n╚═╝  ╚═════╝░╚══════╝░░░╚═╝░░░░╚═════╝░╚═╝░░░░░\n"

  # Set DOTFILES variable for the current shell session
  cd "$(dirname "$0")/.."
  export DOTFILES=$(pwd -P)

  source "$DOTFILES/install/utils.sh"
  source "$DOTFILES/install/setup_prerequisites.sh"
  source "$DOTFILES/install/setup_fonts.sh"
  source "$DOTFILES/install/setup_apps.sh"
  source "$DOTFILES/install/setup_dotfiles.sh"
  source "$DOTFILES/install/setup_post.sh"

  info "Installing prerequisties"
  install_all_prerequisities
  success "Prerequisites installed"

  info "Installing fonts"
  install_fonts
  success "Fonts installed"

  info "Installing tools configured in root directory"
  install_tools_in_root_directory
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

  info "Running post-setup for tools configured in root directory"
  run_post_setup_for_tools_in_root_directory
  success "Post-setup completed"

  info "Configuring system"
  if [ "$(uname)" == "Darwin" ]; then
    source "$(dirname "${BASH_SOURCE[0]}")/setup_system_macos.sh"
  elif [ "$(uname)" == "Linux" ]; then
    echo "System configuration for Linux not supported at the moment."
  fi
  success "System configured. Note that some of these changes require a logout/restart to take effect."

  success "Setup complete!"
}

# Invoke main function with all script arguments
main "$@"
