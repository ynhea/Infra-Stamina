# 📘 Day 5 — 프로젝트: 사용자 및 프로세스 진단 스크립트

## 🚩​ 1. 목표

**사용자 관리와 프로세스 관리 명령어**를 하나의 Shell Script로 연결해본다.

<구현 기능>

* `groupadd`, `useradd`, `usermod`를 이용한 사용자 및 그룹 생성
* `/etc/passwd`, `/etc/group`을 이용한 생성 결과 확인
* `ps`를 이용한 CPU 사용량이 높은 프로세스 확인
* `grep`을 이용한 특정 프로세스 검색
* `kill`을 이용해 프로세스를 제어했던 내용을 하나의 흐름으로 연결

---

## 🚩​ 2. 프로젝트 요구사항

### ① 사용자와 그룹 생성

* `testgroup` 그룹 생성
* `testuser` 사용자 생성
* `testuser`를 `testgroup`에 추가

### ② 생성 결과 확인

* `/etc/passwd`에서 `testuser` 확인
* `/etc/group`에서 `testgroup` 확인
* `groups` 명령어를 이용해 `testuser`의 그룹 확인

### ③ CPU 사용량 상위 프로세스 확인

현재 실행 중인 프로세스를 CPU 사용량 기준으로 정렬하고 상위 5개의 프로세스를 출력

### ④ 특정 프로세스 검색

`sleep`이라는 이름을 가진 프로세스를 찾아 PID를 확인

---

# 🚩​ 3. 최종 스크립트

```bash
#!/bin/bash

echo "=== 1. 사용자/그룹 생성 ==="

sudo groupadd testgroup
sudo useradd -m -s /bin/bash testuser
sudo usermod -aG testgroup testuser

echo "=== 2. 생성 결과 확인 ==="

grep "testuser" /etc/passwd
grep "testgroup" /etc/group
groups testuser

echo "=== 3. CPU 상위 5개 프로세스 ==="

ps aux --sort=-%cpu | head -6

echo "=== 4. sleep 프로세스 찾기 ==="

ps aux | grep sleep | grep -v grep
```

---

# 🚩​ 4. 실행 및 테스트

```bash
./u_p_script.sh
```

처음 실행할 때 `sudo`가 비밀번호를 요구하면 현재 사용자의 비밀번호를 입력한다.
