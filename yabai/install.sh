source "$(dirname "${BASH_SOURCE[0]}")/../install/utils.sh"

# Configure scripting addition for yabai.
# See: https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)
# yabai uses the macOS Mach APIs to inject code into Dock.app;
# this requires elevated (root) privileges. You can configure
# your user to execute yabai --load-sa as the root user without
# having to enter a password. To do this, we add a new configuration
# entry that is loaded by /etc/sudoers.
configure_scripting_addition() {
  local yabai_sa_file_path
  yabai_sa_file_path="/private/etc/sudoers.d/yabai"
  printf "Configuring scripting addition. Please enter sudo password to create / update file: %s\n" "$yabai_sa_file_path"
  if [ ! -f $yabai_sa_file_path ]; then
    sudo touch $yabai_sa_file_path
  fi
  # Update file (replace contents)
  echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee $yabai_sa_file_path
}

brew_install "koekeishiya/formulae/yabai"
configure_scripting_addition
# Start service after installation
yabai --start-service &>/dev/null
# Load scripting addition manually
sudo yabai --load-sa
