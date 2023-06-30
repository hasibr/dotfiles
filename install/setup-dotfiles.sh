#!/usr/bin/env bash

# Create symbolic links between the dotfiles in this directory to where the config files
# for each application should be.

pwd
cd "$(dirname "$0")/.."
DOTFILES=$(pwd -P)

link_file () {
  local src=$1 dst=$2
  printf "\rCreating symbolic link.\n  source: $src\n  destination: $dst\n"

  local overwrite=
  local backup=
  local skip=
  local action=

  # If file exists or directory exists or symbolic link exists
  if [ -f "$dst" ] || [ -d "$dst" ] || [ -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      # ignoring exit 1 from readlink in case where file already exists
      # shellcheck disable=SC2155
      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

        printf "\rFile already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?: "
        read -n 1 action  < /dev/tty

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

        printf "\n"

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      printf "Removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      printf "Backed up $dst. Moved to ${dst}.backup\n"
    fi

    if [ "$skip" == "true" ]
    then
      printf "Skipped creating symbolic link for $src\n"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
    printf "Created symbolic link from $1 to $2\n"
  fi
}


prop () {
   PROP_KEY=$1
   PROP_FILE=$2
   PROP_VALUE=$(eval echo "$(cat $PROP_FILE | grep "$PROP_KEY" | cut -d'=' -f2)")
   echo $PROP_VALUE
}

install_dotfiles () {
  local link_file_name="links.prop"
  local overwrite_all=false backup_all=false skip_all=false

  # Find folders in dotfiles directory with a links.prop file (returns list of paths)
  find -H "$DOTFILES" -maxdepth 2 -name "$link_file_name" | while read app_link_file_path
  do
    # Extract substring from second-last "/" to last "/" to get folder name (app name)
    local folder_name="${app_link_file_path%/*}"
    folder_name="${folder_name##*/}"
    printf "Installing dotfiles for $folder_name\n"

    # Read each line of the links.prop file
    cat "$app_link_file_path" | while read line
    do
        local src dst dir
        src=$(eval echo "$line" | cut -d '=' -f 1)
        dst=$(eval echo "$line" | cut -d '=' -f 2)
        dir=$(dirname $dst)
        
        if ! directory_exists "$dir"; then
          mkdir -p "$dir"
        fi
        link_file "$src" "$dst"
    done
  done
}

create_env_file () {
    local envfile="$HOME/.env.sh"
    if file_exists "$envfile"; then
        printf "$envfile file already exists, skipping\n"
    else
       echo "export DOTFILES=$DOTFILES" > $envfile
       printf "Created $envfile\n"
    fi
}

setup_dotfiles() {
  install_dotfiles
  create_env_file
}
