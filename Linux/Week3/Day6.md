# 📘 Day 6 — 프로젝트 확장: 재사용 가능한 진단 도구로 발전

## 🎯 목표

스크립트를 확장하여, **인자로 사용자명과 프로세스 검색어를 받는 재사용 가능한 진단 도구**로 발전시킨다.

---

## 📋 추가 기능

1. 생성할 사용자 이름을 첫 번째 인자로 받는다.
2. 검색할 프로세스 이름을 두 번째 인자로 받는다.
3. 해당 프로세스가 발견되면 PID와 함께 **"종료하시겠습니까?"라는 안내 메시지만 출력**한다.
4. 실행 결과를 날짜별 로그 파일에 저장한다.
---

# 💡 `kill`을 자동 실행하지 않은 이유!!!

스크립트가 프로세스를 발견했다고 해서 자동으로 종료해버린다면 위험할 수 있다.

### ❌ 위험한 설계

```text
스크립트가 "sleep"이라는 프로세스를 찾음
              ↓
          자동으로 kill
              ↓
     사용자의 확인 없이 종료
              ↓
        예상하지 못한 장애 발생 가능
```

예를 들어 `sleep`이라는 이름을 가진 프로세스가 다른 중요한 작업의 일부일 수도 있다.

---

### ✅ 안전한 설계

```text
스크립트가 프로세스를 찾음
              ↓
PID와 프로세스 정보를 출력
              ↓
"종료하시겠습니까?" 안내
              ↓
사람이 상황을 확인
              ↓
필요한 경우 사람이 직접 종료
```

예:

```text
프로세스 'sleep'가 발견되었습니다.
PID : 1234
종료하시겠습니까?
```

---

# 📝​ 최종 스크립트

```bash
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
```

---

# 📝 흐름도

```text
$1
 ↓
사용자 이름

$2
 ↓
프로세스 검색어

       ↓

진단
 ├─ 사용자/그룹 생성
 ├─ 생성 결과 확인
 ├─ CPU 상위 프로세스 확인
 └─ 특정 프로세스 PID 검색

       ↓

로그 저장
 └─ diagnose_log_YYYYMMDD.txt

       ↓

파괴적 동작
 └─ kill 자동 실행 X
       ↓
사람이 최종 판단
```
