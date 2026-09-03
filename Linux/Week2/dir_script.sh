#!/bin/bash

txt_link=~/Workspace/report_backup_$(date "+%Y%m%d").txt
func() {
	echo "=== $1 ===" | tee -a "$txt_link"
}

func "0. umask 설정"
cd ~/Workspace
umask 077 
umask | tee -a "$txt_link"

func "1. 백업 대상 파일 목록 확인"
find "$1" | tee -a "$txt_link"
link="backup_$(date "+%Y%m%d").tar.gz"

func "2. 압축"
mkdir -p "$2"
tar -czvf "$link" "$1"
cp "$link" "$2/$link"
ls -l "$2" | tee -a "$txt_link"

func "3. 권한 설정"
chmod 600 "$2/$link"
sudo chown "$(whoami)" "$2/$link"
sudo chgrp "$(whoami)" "$2/$link"
ls -l "$2/$link" | tee -a "$txt_link"

func "4. 백업 성공확인"
ls -l "$2" | tee -a "$txt_link"

func "5. 백업 내용확인" 
tar -tzf "$2/$link" | tee -a "$txt_link"

func "6. 임시 압축파일 삭제"
rm -f "$link"
