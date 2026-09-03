# 📘 2주차 Day 6 — 백업 도구 확장 (인자 처리, 리팩토링)

## 🎯 목표

압축(백업) 대상 디렉토리와 보관 위치를 **인자로 받아서 어떤 디렉토리든 백업할 수 있는 범용 도구**로 발전시킨다.


## 📋 추가한 기능

1. 백업 대상 디렉토리를 첫 번째 인자로 받기
   ```bash
   ./backup.sh ~/practice
   ```

2. 백업 보관 디렉토리를 두 번째 인자로 받기
   ```bash
   ./backup.sh ~/practice ~/Backup
   ```

3. `umask 077` 설정

4. `chown`, `chgrp`로 백업 파일의 소유자/그룹 명시적 지정

5. 실행 결과를 `report_backup_날짜.txt`에 저장



## ✍️ 작성한 스크립트

```bash
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
```

---

## 🔎 핵심 흐름도

```text
$1 → 백업 대상
$2 → 백업 보관 위치
    ↓
새 파일의 기본 접근 권한 제한 (umask)
    ↓
백업 대상 확인 (find)
    ↓
대상 압축 (tar)
    ↓
보관 위치로 복사 (cp)
    ↓
접근 권한 제한 (chmod, chown, chgrp)
    ↓
임시 압축파일 삭제 (rm)
```
