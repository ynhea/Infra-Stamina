#!/bin/bash

func() {
	echo "=== $1 ==="
}

func "서비스 점검 시작"

services="sshd cron"
for s in $services; do
	echo "[$s] 상태 확인"
	systemctl is-active "$s"
done

count=0
while [ $count -lt 3 ]; do
	echo "대기 중... ($count)"
	count=$((count+1))
	sleep 1
done
