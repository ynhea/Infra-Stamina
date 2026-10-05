#!/bin/bash

mkdir -p "$HOME/Workspace/Script"
LOG_FILE="$HOME/Workspace/Script/service_$(date "+%Y%m%d").txt"
services="sshd cron"

func () {
    echo "=== $1 ===" | tee -a "$LOG_FILE"
}

check_service() {
    systemctl is-active --quiet "$1"
}

while true; do
    for s in $services; do
    func "[$s] 상태 확인"
    if check_service "$s"; then
        echo "[$s] Active 상태" | tee -a "$LOG_FILE"
    else
        echo "[$s] Inactive 상태" | tee -a "$LOG_FILE"
    fi
    func "[$s] 최근 로그 중 error 확인"
    journalctl -u "$s" -n 10 | grep -i --color=always -E "error|failed" | tee -a "$LOG_FILE"
    sleep 10    # 이후 하루에 한 번으로 변경 필요 시, 1d로 바꾸기!!
    done
done
