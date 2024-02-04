#!/usr/bin/env bash
#
# Contains functions to perform post-setup.

#######################################
# Run a post-setup script for each tool listed as folders in the root directory.
# If the folder has a post-setup.sh shell script, run the script. Otherwise,
# skip it.
# Arguments:
#   None
# Returns:
#   0 if the post-setup for each tool completed successfully, non-zero on error.
#######################################
run_post_setup_for_tools_in_root_directory() {
  local post_setup_script="post-setup.sh"
  local skip_folders=("bin" "install" "scripts")

  # Find folders in dotfiles directory with a post-setup.sh file (returns list of paths)
  find -H "$DOTFILES" -maxdepth 2 -name "$post_setup_script" | while read app_post_setup_path; do
    # Extract substring from second-last "/" to last "/" to get folder name (app name)
    local folder_name="${app_post_setup_path%/*}"
    folder_name="${folder_name##*/}"

    # If folder is in skip_folders array, skip this iteration
    if [[ " ${skip_folders[@]} " =~ " ${folder_name} " ]]; then
      continue
    fi

    printf "Running post-setup for $folder_name\n"
    chmod +x "$app_post_setup_path"
    "$app_post_setup_path"
  done
}
