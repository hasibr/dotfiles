#!/usr/bin/env bash
#
# Contains functions to set up dotfiles (tool configurations) by creating
# symbolic links between the configuration of each tool enumerated in
# folders in the root directory and their appropriate config locations on
# the system.

#######################################
# Create a symbolic link between files at the source path and the destination
# path. If a symbolic link already exists, it will present a prompt to:
#   1. overwrite the symbolic link
#   2. overwrite the symbolic link and all subsequent symbolic links that exist
#   3. back up the symbolic link to a file suffixed with ".backup" in the same
#      directory.
#   4. back up the symbolic link and all subsequent symbolic links that exist
#   5. skip creating the symbolic link
#   6. skip creating the symbolic link and all subsequent symbolink links that
#      exist.
# Globals:
#   overwrite_all   true/false. If set to true, it will overwrite an existing
#                   symbolic link.
#   backup_all      true/false. If set to true, it will back up an existing
#                   symbolic link to a file in the same location with ".backup"
#                   suffixed to the name.
#   skip_all        true/false. If set to true, it will skip creating the
#                   symbolic link.
# Arguments:
#   Source file / folder path.
#   Destination file / folder path.
# Returns:
#   0 if the symlink was created successfully, non-zero on error.
#######################################
link_file() {
  local src=$1 dst=$2
  printf "\rCreating symbolic link.\n  Source: %s\n  Destination: %s\n" "$src" "$dst"

  local overwrite=
  local backup=
  local skip=
  local action=

  # If file exists or directory exists or symbolic link exists
  if [ -f "$dst" ] || [ -d "$dst" ] || [ -L "$dst" ]; then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]; then

      # ignoring exit 1 from readlink in case where file already exists
      # shellcheck disable=SC2155
      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]; then

        printf "The symlink between the source and destination already exists.\n"
        skip=true

      else

        printf "\rFile already exists: %s. What would you like to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?: " "$dst"
        read -n 1 action </dev/tty

        case "$action" in
          o)
            overwrite=true
            ;;
          O)
            overwrite_all=true
            ;;
          b)
            backup=true
            ;;
          B)
            backup_all=true
            ;;
          s)
            skip=true
            ;;
          S)
            skip_all=true
            ;;
          *) ;;

        esac

        printf "\n"

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]; then
      rm -rf "$dst"
      printf "Removed %s\n" "$dst"
    fi

    if [ "$backup" == "true" ]; then
      mv "$dst" "${dst}.backup"
      printf "Backed up %s. Moved to %s.backup\n" "$dst" "$dst"
    fi

    if [ "$skip" == "true" ]; then
      printf "Skipped creating symbolic link.\n"
    fi
  fi

  if [ "$skip" != "true" ]; then # "false" or empty
    ln -s "$1" "$2"
    printf "Created symbolic link.\n"
  fi
}

#######################################
# Prints the value of a property given its key and the property file to search
# in. The property must be listed as key=value inside the file.
# Arguments:
#   The name of the property (key).
#   The path to the property file.
# Outputs:
#   Writes the value of the property to stdout.
# Returns:
#   0, non-zero on error.
#######################################
print_prop_value() {
  local prop_key
  local prop_file
  local prop_value
  prop_key=$1
  prop_file=$2
  prop_value=$(eval echo "$(cat $prop_file | grep "$prop_key" | cut -d'=' -f2)")
  echo $prop_value
}

#######################################
# Configures each tool listed as folders in the root directory by creating
# symbolic links between the configuration in the /config folder and the
# appropriate config location on the system.
#
# If a folder in the root directory has a property file named "links.prop",
# it will create a symbolic link between the source (left-hand side) and the
# destination (right-hand side). Each link to be made should be enumerated in
# the "links.prop" file as src_path=destination_path.
# Arguments:
#   None
# Returns:
#   0 if the symlinks were created successfully, non-zero on error.
#######################################
install_dotfiles() {
  local link_file_name="links.prop"
  local overwrite_all=false backup_all=false skip_all=false

  # Find folders in dotfiles directory with a links.prop file (returns list of paths)
  find -H "$DOTFILES" -maxdepth 2 -name "$link_file_name" | while read app_symlink_prop_fpath; do
    # Extract substring from second-last "/" to last "/" to get folder name (app name)
    local folder_name="${app_symlink_prop_fpath%/*}"
    folder_name="${folder_name##*/}"
    printf "Installing dotfiles for %s\n" "$folder_name"

    # Read each line of the links.prop file
    while IFS='=' read -r src dst; do
      # Skip lines starting with '#' or empty lines
      if [[ $src =~ ^#|^$ ]]; then
        continue
      fi

      # Remove leading whitespace characters
      src="${src#"${src%%[![:space:]]*}"}"
      dst="${dst#"${dst%%[![:space:]]*}"}"
      # Remove trailing whitespace characters
      src="${src%"${src##*[![:space:]]}"}"
      dst="${dst%"${dst##*[![:space:]]}"}"

      # Forcefully expand the entire path
      eval "src=$src"
      eval "dst=$dst"

      # Check if the src path is a file (ie. it is not a directory). If it is a file, we need to create
      # the directory that the file will live in before creating the symlink.
      if ! directory_exists "$src"; then
        # Create the directory for the file
        local dst_directory=$(dirname "$dst")
        mkdir -p "$dst_directory"
      fi

      # Create symbolic links from src to dst
      link_file "$src" "$dst"
    done <"$app_symlink_prop_fpath"
  done
}

#######################################
# Creates a dotenv (.env) file in the user's home directory. This file is
# sourced in the .zshrc. It is meant to contain custom ZSH configuration
# that will not be checked into source control.
# Arguments:
#   None
# Returns:
#   0 if the dotenv file was created successfully, non-zero on error.
#######################################
create_env_file() {
  local envfile="$HOME/.env.sh"
  if file_exists "$envfile"; then
    printf "%s file already exists, skipping creation.\n" "$envfile"
  else
    echo "export DOTFILES=$DOTFILES" >$envfile
    printf "Created file %s\n" "$envfile"
  fi
}

#######################################
# Sets up all dotfiles (tool configurations).
# Arguments:
#   None
# Returns:
#   0 if the dotfiles were set up successfully, non-zero on error.
#######################################
setup_dotfiles() {
  install_dotfiles
  create_env_file
}
