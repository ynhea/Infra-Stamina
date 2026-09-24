#!/bin/bash

USER_NAME=$1
PROCESS_NAME=$2

LOG_FILE=~/Workspace/report_u_p_$(date "+%Y%m%d").txt
func() {
	echo "=== $1 ===" | tee -a $LOG_FILE
}


func "0. 새 사용자와 그룹 생성"
sudo useradd -m -s /bin/bash "$USER_NAME"
sudo groupadd testgroup

grep "$USER_NAME" /etc/passwd | tee -a "$LOG_FILE"
grep "testgroup" /etc/group | tee -a "$LOG_FILE"


func "1. 그룹 추가"
sudo usermod -aG testgroup "$USER_NAME"
groups "$USER_NAME" | tee -a "$LOG_FILE"


func "2. CPU 사용량 상위 5개 프로세스"
ps aux --sort=-%cpu | head -6 | tee -a "$LOG_FILE"

func "3. 검색한 이름을 가진 프로세스의 PID"
pid=$(ps aux | grep "$PROCESS_NAME" | grep -v grep | awk '{print $2}')
if [ -n "$pid" ]; then
    echo "프로세스 '$PROCESS_NAME'가 발견되었습니다." | tee -a "$LOG_FILE"
    echo "PID : $pid" | tee -a "$LOG_FILE"
    echo "종료하시겠습니까?"
else
    echo "프로세스 '$PROCESS_NAME'가 발견되지 않았습니다." | tee -a "$LOG_FILE"
fi

echo "실행 결과가 $LOG_FILE 에 저장되었습니다."
