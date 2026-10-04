# 🐧 Day 4

## for, while, function, grep/sed/awk

---

## 🍒​ 목표

1. 정해진 목록을 순회하는 **for**
2. 조건이 유지되는 동안 반복하는 **while**
3. 반복 코드를 이름 붙여 재사용하는 **function**
4. 텍스트를 검색·치환·추출하는 **grep/sed/awk**

---

## 🍒​ 핵심 개념

| 개념 | 영어 | 한 줄 정의 |
|---|---|---|
| **for** | for | 목록(파일, 숫자, 문자열)을 순회하며 반복 실행 |
| **while** | while | 조건이 참인 동안 반복 실행 |
| **function** | function | 반복되는 코드 블록을 이름 붙여 **재사용** |
| **grep** | grep | 텍스트에서 패턴 **검색** |
| **sed** | sed | 텍스트 **치환** |
| **awk** | awk | 필드(컬럼) 단위로 텍스트 **추출** |

---

## 🍒​ 내부 동작 원리

### ① for 문

```bash
services="sshd cron"
for s in $services; do
    echo "[$s] 상태 확인"
done
```

```text
for s in $services; do ... done

   services="sshd cron"
         │
         ▼
   공백 기준으로 쪼갬 → "sshd", "cron"
         │
    ┌────┴────┐
    ▼         ▼
 s=sshd     s=cron
 (1회 실행)  (2회 실행)
```

**왜 따옴표 없이 `$services`를 쓰는가?**

`for`문은 변수를 공백 기준으로 자동으로 단어 분리하기 때문이다.
"변수는 항상 따옴표로 감싸라"는 원칙의 **유일한 예외**다

### ② while 문

```bash
count=0
while [ $count -lt 3 ]; do
    echo "대기 중... ($count)"
    count=$((count+1))
    sleep 1
done
```


**for vs while**

| 상황 | 선택 |
|---|---|
| 이미 정해진 목록이 있다 (서비스 리스트, 파일 목록) | `for` |
| "언제 끝날지 모르지만 조건이 유지되는 동안" (서버가 응답할 때까지 대기, 모니터링 루프) | `while` |

### ③ function

```bash
func() {
    echo "=== $1 ==="
}

func "서비스 점검 시작"
```

**주의할 점:** 함수 안의 `$1`은 스크립트 전체의 `$1`(첫 번째 실행 인자)과 다르다. 함수를 호출할 때 넘긴 첫 번째 "인자"를 가리킨다.

### ④ grep / sed / awk 

```text
grep   →  "검색"     (이 줄에 패턴이 있는가?)
sed    →  "치환"     (이 패턴을 저걸로 바꿔라)
awk    →  "필드 추출" (이 줄의 2번째 컬럼만 뽑아라)
```

**grep** - 검색:

```bash
ps aux | grep sleep | grep -v sleep_test   # -v: 제외(invert)
grep -i error log.txt                       # -i: 대소문자 무시
```

**sed** — 패턴 치환:

```bash
echo "hello world" | sed 's/world/linux/'
```

```text
결과: hello linux
       ↑
     s(substitute)/찾을패턴/바꿀값/
```

**awk** — 필드(컬럼) 추출:

```bash
ps aux | grep sleep | awk '{print $2}'
```

```text
ps aux 출력 예시
USER  PID   %CPU  %MEM  COMMAND
user  12345  0.0   0.1  sleep

         awk '{print $2}'
              │
              ▼
         2번째 컬럼만 추출 → 12345 (PID)
```

---

## 🍒​ 실습

```bash
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
```

**예상 결과**

```text
=== 서비스 점검 시작 ===
[sshd] 상태 확인
active
[cron] 상태 확인
active
대기 중... (0)
대기 중... (1)
대기 중... (2)
```

---

## 🍒​ 심화 내용

### ⚠ 무한 루프 위험성

```bash
while true; do
    echo "체크중..."
    # sleep이 없으면?
done
```

`while true`를 쓸 때는 반드시 `sleep`과 종료 방법(Ctrl+C = `SIGINT`)을 함께 설계해야 함!!

### 함수의 반환값 (exit code)

```bash
check_service() {
    systemctl is-active --quiet "$1"
    return $?
}

if check_service sshd; then
    echo "정상"
fi
```

"if는 exit code를 본다"
`return`으로 함수도 성공/실패를 알릴 수 있다.
