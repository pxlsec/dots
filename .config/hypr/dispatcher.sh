#!/bin/zsh


current_display=$(hyprctl -j activeworkspace | jq -c " .monitor" | tr -d '"')
current_id=$(hyprctl -j activeworkspace | jq -c " .id" | tr -d '"')
other_display=$( hyprctl -j workspaces | jq -c ".[$1-1] | .monitor" | tr -d '"')

echo $other_display $current_id $current_display

# hyprctl dispatch moveworkspacetomonitor $current_id $other_display
hyprctl dispatch moveworkspacetomonitor $1 $current_display # Move the workspace to the current monitor
hyprctl dispatch workspace $1


# workspaces
# activeworkspace


# dispatches
#
# movecurrentworkspacetomonitor
# moveworkspacetomonitor
# swapactiveworkspaces
