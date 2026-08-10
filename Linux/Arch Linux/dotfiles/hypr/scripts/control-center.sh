#!/bin/sh

# ============================================
# Hyprland Control Center
# Wofi를 이용해 시스템 설정 메뉴를 표시
# ============================================

# Control Center 메뉴 항목
# 사용자가 하나를 선택하면 아래 case 문에서 해당 프로그램을 실행
choice=$(printf '%s\n' \
  'Wi-Fi' \
  'Sound' \
  'Bluetooth' \
  'Display' \
  'Power' \
  | wofi --dmenu --prompt 'Control Center')

# ============================================
# 선택한 메뉴에 따라 프로그램 실행
# ============================================

case "$choice" in

  # Wi-Fi / 네트워크 설정
  Wi-Fi)
    nm-connection-editor
    ;;

  # 사운드 / 오디오 장치 및 볼륨 설정
  Sound)
    pavucontrol
    ;;

  # Bluetooth 장치 관리
  Bluetooth)
    blueman-manager
    ;;

  # 디스플레이 설정
  Display)
    nwg-displays
    ;;

  # 전원 메뉴
  Power)
    wlogout
    ;;

  # Wofi에서 선택하지 않고 ESC 등으로 종료한 경우
  *)
    exit 0
    ;;

esac
