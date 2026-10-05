# 🐧 Day 6

## 프로젝트: 지속 모니터링 + 로그 필터링 도구

---

## 🎯 목표

### 추가 기능

1. `while`문으로 사용자가 종료할 때까지 일정 주기로 반복 점검
2. `grep`으로 로그에서 `error`, `failed` 같은 패턴만 필터링
3. `Ctrl+C`를 이용해 실행 중인 스크립트 종료

---

## 🎯 전체 구조

```bash
while true; do

    for s in $services; do
        # 서비스 상태 확인
        # 로그 확인
    done

    sleep 10

done
```

## 🎯 흐름도

```text
while true
    ↓
서비스 목록 확인
    ↓
for문으로 서비스 하나씩 검사
    ↓
서비스 상태 확인
    ↓
최근 로그에서 error/failed 검색
    ↓
모든 서비스 검사 완료
    ↓
10초 대기
    ↓
다시 while 처음으로
    ↓
반복
```

---

```bash
journalctl -u "$s" -n 10 |
grep -i --color=always -E "error|failed"
```

### 사용한 옵션

| 옵션 | 의미 |
|---|---|
| `-i` | 대소문자를 구분하지 않음 |
| `--color=always` | 검색된 패턴을 색상으로 강조 |
| `-E` | 확장 정규식 사용 |
| `error|failed` | `error` 또는 `failed` 검색 |


> `sleep 10`은 실습에서 반복 동작을 확인하기 위한 값입니다!
>  실제 운영 환경에서는 서비스 특성에 맞는 점검 주기를 정해야 한다. (ex. 1d 등..)

> **`while`로 계속 감시하고, `for`로 서비스를 하나씩 검사하며, `grep`으로 문제 로그만 골라내는 자동화 도구를 만든다.**
