#!/usr/bin/env sh

# Load the scripting addition
# Requires script that configures your user to execute
# yabai --load-sa as the root user without password.
# This script must be in: /private/etc/sudoers.d/yabai
# See: https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)
yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
sudo yabai --load-sa

# global settings
yabai -m config mouse_follows_focus off
yabai -m config focus_follows_mouse off
yabai -m config window_origin_display default
yabai -m config window_placement second_child
yabai -m config window_topmost off
yabai -m config window_shadow on
yabai -m config window_opacity off
yabai -m config window_opacity_duration 0.0
yabai -m config active_window_opacity 1.0
yabai -m config normal_window_opacity 0.90
yabai -m config window_border off
yabai -m config window_border_width 6
yabai -m config active_window_border_color 0xff775759
yabai -m config insert_feedback_color 0xffd75f5f
yabai -m config split_ratio 0.50
yabai -m config auto_balance off
yabai -m config mouse_modifier fn
yabai -m config mouse_action1 move
yabai -m config mouse_action2 resize
yabai -m config mouse_drop_action swap

# general space settings
yabai -m config layout bsp
yabai -m config top_padding 0
yabai -m config bottom_padding 0
yabai -m config left_padding 0
# NOTE: for OBS floating head
# yabai -m config left_padding                 450
yabai -m config right_padding 0
yabai -m config window_gap 0

# apps to not manage (ignore)
yabai -m rule --add app="^System Settings$" manage=off
yabai -m rule --add app="^Alfred Preferences$" manage=off
yabai -m rule --add app="^Rancher Desktop$" manage=off
yabai -m rule --add app="^Docker Desktop$" manage=off
yabai -m rule --add app="^Finder$" manage=off
yabai -m rule --add app="^iStat Menus$" manage=off
# Disable window management of Alacritty by yabai since hammerspoon manages it
# appearing / disappearing quake-style on active window in full-screen.
yabai -m rule --add app="^Alacritty$" manage=off
yabai -m rule --apply

echo "yabai configuration loaded.."
