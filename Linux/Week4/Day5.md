# 🐧 Day 5

## 프로젝트: 서비스 및 로그 진단 자동화 스크립트

---

## 🎯 목표

```text
systemctl (월)
+
journalctl (화)
+
변수 / if / case (수)
+
for / while / function (목)
↓
서비스 및 로그 진단 자동화 스크립트 생성
```

---

## 💡​ 프로젝트 요구사항

### 구현해야 하는 기능

1. 점검할 서비스 이름들을 **변수(리스트)** 로 지정한다.
   - 예: `sshd`, `cron`
2. **for문**으로 각 서비스를 순회한다.
3. `systemctl is-active`로 서비스 실행 상태를 확인한다.
4. 서비스가 비활성 상태라면 **if문**으로 분기하여 경고 메시지를 출력한다.
   - 자동 재시작은 하지 않는다.
5. 각 서비스마다 `journalctl -u 서비스명 -n 10`으로 최근 로그 10줄을 출력한다.
6. 반복되는 섹션 제목 출력은 **function**으로 묶는다.
7. `tee -a`를 이용해 화면 출력과 로그 파일 저장을 함께 처리한다.

---

## 💡​ 전체 흐름

```text
services="ssh cron"
        │
        ▼
   for s in $services
        │
        ├── func "[$s] 상태 확인"
        │
        ├── check_service "$s"
        │       │
        │       └── systemctl is-active --quiet
        │
        ├── if
        │    ├── 성공 → Active 상태
        │    └── 실패 → Inactive 상태
        │
        ▼
   다음 서비스
        │
        ▼
   두 번째 for
        │
        ├── func "[$s] 최근 로그 확인"
        │
        └── journalctl -u "$s" -n 10
```

---

## 💡​ 실행 결과

```text
=== [ssh] 상태 확인 ===
[ssh] Active 상태

=== [cron] 상태 확인 ===
[cron] Active 상태

=== [ssh] 최근 로그 확인 ===
... 최근 로그 10줄 ...

=== [cron] 최근 로그 확인 ===
... 최근 로그 10줄 ...
```

서비스가 "비활성 상태"일 경우:

```text
[서비스명] Inactive 상태
```
