# 🐧 4주차 Day 2 — target & journalctl

## 1. 핵심

```text
target     → 여러 Unit을 묶어 시스템의 목표 상태를 관리
journalctl → systemd가 모아둔 로그를 조회
```

---

# 2. target

**여러 Unit을 묶어 하나의 "목표 상태"로 정의한 것**

target 자체가 프로그램을 실행하는 것은 아님!!

```text
multi-user.target
 ├── ssh.service
 ├── cron.service
 ├── network 관련 Unit
 └── 기타 필요한 Unit
```

> **"시스템이 이 상태가 되려면 어떤 Unit들이 필요한가?"를 묶어놓은 것**

---

## 주요 target

### `multi-user.target`

* 여러 서비스가 실행되는 일반적인 서버 환경
* GUI가 없는 서버에서 주로 사용

### `graphical.target`

* GUI 환경까지 포함한 상태
* `multi-user.target`을 포함한다.

```text
graphical.target
       ↓
multi-user.target
       ↓
basic.target
```

---

## 기본 target 확인

```bash
systemctl get-default
```

기본 target 변경:

```bash
sudo systemctl set-default multi-user.target
```

---

## target에 어떤 Unit이 연결되어 있는지 확인

```bash
systemctl list-dependencies multi-user.target
```

→ 해당 target의 의존 관계를 트리 형태로 확인한다.

---

# 3. journal

**systemd가 관리하는 통합 로그 저장소**

여러 곳에서 발생하는 로그를 모아서 관리한다.

```text
서비스 로그
커널 메시지
systemd 이벤트
      ↓
   journald (저장)
      ↓
    journal (조회)
```

---

# 4. journalctl

**journal에 저장된 로그를 조회하는 명령어**

| 옵션 | 의미 |
|---|---|
| `-u <서비스명>` | 특정 유닛 로그만 |
| `-f` | 실시간 스트리밍 |
| `--since "1 hour ago"` | 특정 시간 이후 |
| `-p err` | 특정 우선순위(에러) 이상만 |
| `-b` | 이번 부팅 이후 로그만 |
| `--disk-usage` | 저널이 디스크를 얼마나 차지하는지 |

---

# 5. ⭐ 서비스 장애 발생 시

```text
서비스 이상
    ↓
systemctl status
    ↓
현재 상태 확인
    ↓
journalctl -u 서비스
    ↓
오류 로그 확인
    ↓
원인 분석
```

---

# 6. ⭐ daemon-reload

`.service` 파일을 직접 수정했다면 반드시 아래의 순서를 지킬 것!!:

```text
.service 수정
    ↓
daemon-reload
    ↓
systemd가 변경된 설정 다시 읽음
    ↓
restart
```

`daemon-reload`를 하지 않으면 systemd가 기존 설정을 계속 사용할 수 있다.

---

# 7. ⭐ 명령어

| 명령어                                    | 의미                |
| -------------------------------------- | ----------------- |
| `systemctl get-default`                | 기본 target 확인      |
| `systemctl set-default <target>`       | 기본 target 변경      |
| `systemctl list-dependencies <target>` | target의 의존 관계 확인  |
| `journalctl -u <서비스>`                  | 특정 서비스 로그         |
| `journalctl -f`                        | 실시간 로그            |
| `journalctl --since "1 hour ago"`      | 특정 시간 이후 로그       |
| `journalctl -p err`                    | 에러 로그             |
| `journalctl -b`                        | 이번 부팅 로그          |
| `journalctl --disk-usage`              | 로그 저장 공간 확인       |
| `systemctl daemon-reload`              | 변경된 Unit 설정 다시 읽기 |

---

# ⭐ 최종 정리

```text
target
→ 여러 Unit을 묶은 "목표 상태"

multi-user.target
→ GUI 없는 서버 환경

graphical.target
→ GUI까지 포함하는 환경

journal
→ systemd가 관리하는 통합 로그

journalctl
→ journal을 조회하는 명령어

-u
→ 특정 서비스 로그

-f
→ 실시간 로그

-b
→ 이번 부팅 로그

daemon-reload
→ 수정한 .service 설정을 systemd가 다시 읽게 함
```

### 한 문장으로

> **target은 시스템이 어떤 상태가 되어야 하는지를 정의하고, journalctl은 문제가 발생했을 때 시스템과 서비스의 로그를 확인하는 도구다.**
