# 📘 3주차 Day 2 --- passwd, sudo, su

## 1. 오늘의 목표

-   `passwd`로 비밀번호를 설정·변경하는 원리 이해
-   `passwd`와 SUID의 관계 이해
-   `sudo`를 이용한 임시 권한 상승 이해
-   `su -`를 이용한 사용자 전환 이해
-   `/etc/sudoers`와 `visudo`의 역할 이해

## 2. 핵심 개념

  개념             역할
  ---------------- ---------------------------------------
  `passwd`         사용자 비밀번호 설정/변경
  `sudo`           특정 명령을 다른 권한으로 실행
  `su`             다른 사용자로 전환
  `/etc/sudoers`   sudo 권한 정책을 정의
  `visudo`         sudoers를 안전하게 편집하고 문법 검사

## 3. passwd와 SUID

어제 배운 `/etc/shadow`는 일반 사용자가 직접 수정하기 어렵다. 그런데
일반 사용자는 자신의 비밀번호를 바꿀 수 있다.

`passwd`에는 SUID가 설정되어 있는 경우가 많다.

``` bash
ls -l /usr/bin/passwd
```

예:

``` text
-rwsr-xr-x 1 root root ... /usr/bin/passwd
   ↑
   SUID
```

SUID가 설정된 실행 파일은 실행 시 파일 소유자의 권한을 이용할 수 있다.

``` text
devuser
   ↓
passwd 실행
   ↓
SUID
   ↓
필요한 권한으로 비밀번호 변경 작업
   ↓
프로그램 종료
```

## 4. sudo

`sudo`는 허용된 사용자가 특정 명령을 다른 권한으로 실행하게 해준다.

``` bash
sudo whoami
```

결과:

``` text
root
```

즉, 일반 사용자로 로그인한 상태에서도 해당 명령만 관리자 권한으로 실행할
수 있다.

## 5. sudo와 su -

### sudo

``` bash
sudo apt update
```

특정 명령을 높은 권한으로 실행한 뒤 다시 현재 사용자로 돌아온다.

### su -

``` bash
su -
```

다른 사용자, 특히 root 계정으로 세션 자체를 전환한다.

### 비교

  `sudo`                  `su -`
  ----------------------- --------------------------------
  특정 명령에 권한 부여   사용자/세션 자체를 전환
  필요한 순간에 사용      전환된 사용자 셸에서 계속 작업
  명령 단위로 권한 사용   관리자 세션을 유지

## 6. /etc/sudoers와 visudo

sudo 사용 권한은 `/etc/sudoers` 등의 sudo 정책으로 관리한다.

확인:

``` bash
sudo cat /etc/sudoers
```

편집할 때는:

``` bash
sudo visudo
```

`visudo`는 저장 과정에서 sudoers 문법을 검사하여 잘못된 설정으로 sudo가
동작하지 않는 사고를 예방한다.

## 7. sudo 권한 실습

``` bash
whoami
sudo whoami
```

다른 사용자로 전환:

``` bash
su - devuser
```

다시 확인:

``` bash
sudo whoami
```

예상 결과:

``` text
root
```

Ubuntu 계열에서 `devuser`를 sudo 그룹에 추가하는 예:

``` bash
sudo usermod -aG sudo devuser
```

확인:

``` bash
id devuser
```

## 8. 위험한 sudo 설정

``` text
devuser ALL=(ALL) NOPASSWD:ALL
```

이 설정은 매우 강한 권한을 부여한다. 계정이 탈취되면 비밀번호 확인 없이
높은 권한의 명령을 실행할 수 있으므로 주의해야 한다.

권한은 필요한 범위로 제한하는 **최소 권한 원칙(Principle of Least
Privilege)**을 적용하는 것이 중요하다.

## 9. 오늘의 핵심 정리

``` text
passwd
→ 비밀번호 설정/변경

SUID
→ 실행 파일 소유자의 권한으로 실행

sudo
→ 특정 명령을 다른 권한으로 실행

su -
→ 다른 사용자로 세션 전환

/etc/sudoers
→ sudo 권한 정책

visudo
→ sudoers 안전 편집 + 문법 검사
```

## 10. 면접 대비

1.  `passwd`가 일반 사용자에 의해 실행될 수 있는 이유를 SUID와 연결해서
    설명해보세요.
2.  `sudo`와 `su -`의 차이는 무엇인가요?
3.  `/etc/sudoers`를 `visudo`로 편집하는 이유는 무엇인가요?
4.  `NOPASSWD:ALL`이 위험한 이유는 무엇인가요?
5.  SUID와 sudo의 공통점과 차이점은 무엇인가요?

## 11. 퀴즈

1.  `/usr/bin/passwd`에 SUID가 설정되어 있으면 어떤 효과가 있는가?
2.  `sudo whoami`가 `root`를 출력하는 이유는?
3.  `sudo`와 `su -`는 어떻게 다른가?
4.  `visudo`를 사용하는 이유는?
5.  `NOPASSWD:ALL`이 위험한 이유는?
6.  `/etc/shadow`와 `passwd` 명령은 어떤 관계가 있는가?

## 📝 학습 체크

-   [ ] `passwd`의 역할을 설명할 수 있다.
-   [ ] SUID와 `passwd`의 관계를 설명할 수 있다.
-   [ ] `sudo`의 역할을 설명할 수 있다.
-   [ ] `sudo`와 `su -`의 차이를 설명할 수 있다.
-   [ ] `/etc/sudoers`의 역할을 설명할 수 있다.
-   [ ] `visudo`를 사용하는 이유를 설명할 수 있다.
-   [ ] `sudo whoami`가 `root`를 출력하는 이유를 설명할 수 있다.
-   [ ] 최소 권한 원칙을 설명할 수 있다.
