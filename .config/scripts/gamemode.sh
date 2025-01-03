#!/bin/sh

services="ollama transmission" # System services to turn off
uservices="syncthing" # User services to turn off

user=$SUDO_USER
uid=$(id -u "$user")

function notify() {
    #Detect the id of the user

    sudo -u "$user" DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/"$uid"/bus $(command -v notify-send) "$@"
}

apply() {
  # send notification
  notify "GameMode started"

  # stop mpvpaper
  echo '{ "command": ["set_property", "pause", true] }' | socat - /tmp/mpv-socket
  
  echo "--- Stopping system services ---"
  for i in $services; do
    systemctl is-active $i > /dev/null
    case "$?" in
      0) echo "$i - Stopping service"
      sudo systemctl stop $i &
      ;;
      4) echo "$i - Service not found"
      ;;
      *) echo "$i - Not active, skipping"
      ;;
    esac
  done

  echo "--- Stopping user services ---"

  for i in $uservices; do
    sudo -u "$user" DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/"$uid"/bus systemctl --user is-active $i > /dev/null
    case "$?" in
      0) echo "$i - Stopping service"
      sudo -u "$user" DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/"$uid"/bus systemctl --user stop $i &
      ;;
      4) echo "$i - Service not found"
      ;;
      *) echo "$i - Not active, skipping"
      ;;
    esac
  done

  systemctl --user stop $uservices &
}

revert() {
  # send notification
  notify "GameMode ended"

  # start wallpaper
  echo '{ "command": ["set_property", "pause", false] }' | socat - /tmp/mpv-socket

  echo "--- Starting system services ---"

  for i in $services; do
    systemctl is-enabled $i > /dev/null
    case "$?" in
      0) echo "$i - Starting service"
      sudo systemctl start $i &
      ;;
      4) echo "$i - Service not found"
      ;;
      *) echo "$i - Not enabled, skipping"
      ;;
    esac
  done

  echo "--- Starting user services ---"

  for i in $uservices; do
    sudo -u "$user" DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/"$uid"/bus systemctl --user is-enabled $i > /dev/null
    case "$?" in
      0) echo "$i - Starting service"
      sudo -u "$user" DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/"$uid"/bus systemctl --user start $i &
      ;;
      4) echo "$i - Service not found"
      ;;
      *) echo "$i - Not enabled, skipping"
      ;;
    esac
  done
}

help() {
  echo ""
  echo "gamemode OPTION"
  echo ""
  echo "Options:"
  echo "-a || --apply           Apply gamemode settings"
  echo "-r || --revert          Revert to default settings"
  echo "-h || --help            Show this help message"
}

if [[ $# -lt 1 ]]; then
  echo "Too few args!"
  help
  exit 1
elif [[ $# -gt 1 ]]; then
  echo "Too many args!"
  help
  exit 1
fi

case $1 in
  -a|--apply)
    apply
    ;;
  -r|--revert)
    revert
    ;;
  -h|--help)
    help
    ;;
  *)
    echo "Unknown option $1"
    help
    exit 1
    ;;
esac

echo ""
echo "Done!"
