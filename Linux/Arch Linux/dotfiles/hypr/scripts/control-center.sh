#!/bin/sh

choice=$(printf 'Wi-Fi\nSound\nBluetooth\nDisplay\nPower' | wofi --dmenu --prompt 'Control Center')

case "$choice" in
  Wi-Fi) nm-connection-editor ;;
  Sound) pavucontrol ;;
  Bluetooth) blueman-manager ;;
  Display) nwg-displays ;;
  Power) wlogout ;;
esac
