#!/bin/bash

LOG_FILE=~/Workspace/Script/service_$(date "+%Y%m%d").txt
func () {
    echo "=== $1 ===" | tee -a "$LOG_FILE"
}

check_service() {
    systemctl is-active --quiet "$1"
}

services="sshd cron"
for s in $services; do
    func "[$s] 상태 확인"
    if check_service "$s"; then
        echo "[$s] Active 상태" | tee -a "$LOG_FILE"
    else
        echo "[$s] Inactive 상태" | tee -a "$LOG_FILE"
    fi
    func "[$s] 최근 로그 확인"
    journalctl -u "$s" -n 10 | tee -a "$LOG_FILE"
done
