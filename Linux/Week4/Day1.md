# 🐧 4주차 Day 1 — systemd

## 1. 흐름

```text
부팅
  ↓
Kernel
  ↓
systemd (PID 1)
  ↓
서비스 관리
  ↓
sshd / nginx / docker / cron ...
```

**systemd = Linux에서 시스템과 서비스를 관리하는 관리자**

---

## 2. Unit이란?

**Unit = systemd가 관리하는 대상**

대표적인 Unit:

| Unit       | 역할                |
| ---------- | ----------------- |
| `.service` | 서비스/데몬 관리         |
| `.socket`  | 네트워크 소켓 관리        |
| `.target`  | 여러 Unit을 묶은 목표 상태 |
| `.timer`   | 일정 시간에 작업 실행      |

가장 중요한 것은 **`.service`**다.

---

## 3. Service란?

`.service` 파일은 **특정 서비스를 어떻게 실행하고 관리할지 정의**한다.

예:

```ini
[Service]
ExecStart=/usr/sbin/sshd -D
Restart=on-failure
```

* `ExecStart` → 실제 실행할 명령
* `Restart=on-failure` → 비정상 종료 시 다시 실행

<흐름도 연결>

```text
systemd
   ↓
.service 파일 확인
   ↓
ExecStart 실행
   ↓
프로세스 실행 및 감시
```

---

## 4. systemctl

**systemctl = systemd를 제어하는 명령어**

```bash
systemctl status <서비스>
```

현재 상태 확인

```bash
sudo systemctl start <서비스>
```

지금 실행

```bash
sudo systemctl stop <서비스>
```

지금 중지

```bash
sudo systemctl restart <서비스>
```

재시작

```bash
sudo systemctl enable <서비스>
```

부팅할 때 자동 실행하도록 등록

```bash
sudo systemctl disable <서비스>
```

부팅 시 자동 실행 등록 해제

---

## 5. ⭐ start vs enable

### start

> **지금 실행됨!**
* 재부팅하면 다시 실행된다는 보장 X

### enable

> **부팅할 때 실행하도록 등록해!**
* 지금 당장 실행하는 명령이 아님
* 다음 부팅부터 자동 실행되도록 설정

---

## 6. status에서 꼭 볼 것

주요 정보:

### Loaded

서비스 파일을 systemd가 인식하고 있는가?

```text
Loaded: loaded
```

### Active

현재 서비스 상태

```text
active (running)
```

### Main PID

서비스의 **대표 프로세스 PID**

```text
Main PID: 612 (sshd)
```

---

# ⭐ 한 줄 정리

```text
systemd = Linux의 시스템/서비스 관리자 (PID 1)

Unit = systemd가 관리하는 대상

Service = 데몬 프로세스를 관리하는 Unit

systemctl = systemd를 제어하는 명령어

start = 지금 실행
stop = 지금 중지
restart = 재시작
enable = 부팅 시 자동 실행 등록
disable = 부팅 시 자동 실행 해제

status = 서비스 상태 확인

ExecStart = 실제 실행할 명령
Restart=on-failure = 비정상 종료 시 재시작
```
