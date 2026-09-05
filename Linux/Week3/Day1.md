# 📘 Day 1 --- 사용자 관리

## 💀​ 1. 목표

리눅스에서 사용자(User)와 그룹(Group)이 어떻게 생성되고 관리되는지 이해한다.

-   `useradd`로 사용자 생성
-   `groupadd`로 그룹 생성
-   `usermod`로 사용자 계정 수정
-   Primary Group과 Supplementary Group 이해
-   `/etc/passwd`, `/etc/group`, `/etc/shadow`의 역할 이해
-   UID 의미 이해

------------------------------------------------------------------------

## 💀​ 2. 개념

### ① `useradd` · `userdel`

``` bash
sudo useradd -m -s /bin/bash <사용자명>
```

-   `-m` : 홈 디렉토리 생성
-   `-s` : 로그인 쉘 지정

``` text
useradd 실행
    │
    ├─▶ /etc/passwd에 사용자 정보 추가
    ├─▶ /etc/shadow에 비밀번호 관련 정보 추가
    ├─▶ 기본 그룹 정보 생성/설정
    └─▶ -m 옵션이 있으면 /home/devuser 생성
```

### ② `groupadd`

``` bash
sudo groupadd <그룹명>
```

### ③ `usermod`

기존 사용자 계정 정보를 수정한다.

``` bash
sudo usermod -aG dev devuser
```

-   `-G` : 보조 그룹(Supplementary Group) 지정
-   `-a` : 기존 그룹을 유지하면서 추가(append)
- <주의> `-a` 없이 `-G`만 사용하면 기존 Supplementary Group이 새 목록으로 덮어써질 수 있다!!

------------------------------------------------------------------------

## 💀​ 3. Primary Group vs Supplementary Group

### Primary Group

사용자 생성 시 기본으로 부여되는 그룹이다.
모든 파일은 그룹 소유권을 가져야 하므로 Supplementary Group이 아니여도, Primary Group이 필요하기 때문에 존재해야 한다.

### Supplementary Group

사용자가 추가로 소속되는 그룹이다.

``` text
Primary Group
└─ 사용자 생성 시 기본으로 부여되는 그룹

Supplementary Group
└─ 사용자가 추가로 소속되는 그룹
```

------------------------------------------------------------------------

## 💀​ 4. 사용자/그룹 정보 파일

### ① /etc/passwd (사용자 정보)

주요 필드:

``` text
devuser
└─ 사용자 이름

x
└─ 비밀번호 정보는 별도의 shadow 데이터에 있음

1001
└─ UID

1001
└─ GID

/home/devuser
└─ 홈 디렉토리

/bin/bash
└─ 로그인 쉘
```

### ② /etc/group (그룹 정보)

주요 필드:

``` text
dev
└─ 그룹 이름

x
└─ 그룹 비밀번호 필드

1002
└─ GID

devuser
└─ 해당 그룹의 구성원
```

## ③ /etc/shadow (비밀번호와 관련된 민감한 인증 정보)

`/etc/passwd`의 비밀번호 필드에 있는 `x`는 실제 비밀번호 정보가
`/etc/passwd`에 저장되지 않고 별도의 shadow 데이터에 있다는 의미다.

------------------------------------------------------------------------

## 💀​ 5. UID / GID

### UID

**User ID**

사용자를 숫자로 식별하는 ID이다.

0        → root (관리자)
1 ~ 999  → 시스템/서비스 계정 (예: sshd, www-data) (<주의!> 서비스도 각각 계정으로 분리되어, 서로 다른 권한을 가짐!!)
1000 ~   → 일반 사용자 계정 (Ubuntu 기준)

### GID

**Group ID**

그룹을 숫자로 식별하는 ID이다.

------------------------------------------------------------------------

## 💀​ 6. 핵심 명령어 표

  명령어                   역할
  ------------------------ -------------------
  `useradd`                사용자 생성
  `userdel`                사용자 삭제
  `groupadd`               그룹 생성
  `usermod`                사용자 계정 수정
  `id`                     UID/GID/그룹 확인
  `cat /etc/passwd`        사용자 정보 확인
  `cat /etc/group`         그룹 정보 확인
  `sudo cat /etc/shadow`   shadow 정보 확인
