# 😳​ Day 4 — 고급 권한

> 핵심: **SUID · SGID · Sticky Bit · ACL**

---

## 🚩​ 1. SUID

**SUID (Set User ID)**

- 파일을 실행하면 **실행한 사용자가 아니라, 파일 소유자의 권한으로 실행**된다.
- 특히 파일 소유자가 `root`인 경우, 일반 사용자가 해당 프로그램을 실행할 때 잠시 `root` 권한이 필요한 상황에서 사용된다.

### SUID 확인

```bash
find / -perm -4000 -type f
```

- `/` : 루트 디렉토리부터 검색
- `-perm -4000` : SUID 권한이 설정된 파일 검색
- `-type f` : 일반 파일만 검색

> 시스템 전체를 검색하므로 `sudo` 권한이 필요할 수 있다.

### SUID 표시

```text
-rwsr-xr-x
   ↑
   s = SUID
```

일반적인 실행 권한의 `x` 위치에 `s`가 표시된다.

### 핵심

```text
일반 실행
사용자 → 자신의 권한으로 파일 실행

SUID 실행 파일
사용자 → 파일 소유자의 권한으로 파일 실행
```

---

## 2. SGID

**SGID (Set Group ID)**

SGID는 파일과 디렉토리에서 의미가 조금 다르다.

### 디렉토리에 SGID 설정

공유 디렉토리에 SGID를 설정하면 해당 디렉토리에서 새로 생성되는 파일은 **디렉토리의 그룹을 상속**받는다.

```text
공유 디렉토리
      ↓
사용자가 파일 생성
      ↓
파일의 그룹 = 공유 디렉토리의 그룹
```

따라서 여러 사용자가 함께 사용하는 **공유 디렉토리**에서 유용하다.

### SGID 설정

```bash
chmod g+s shared_dir
```

### SGID 표시

```text
drwxrwsr-x
     ↑
     s = SGID
```

---

## 3. Sticky Bit

**Sticky Bit**

- 주로 **공유 디렉토리**에 사용
- 여러 사용자가 파일을 생성할 수 있음
- 하지만 파일 삭제는 **파일 소유자만 가능**하도록 제한

### 핵심

```text
공유 디렉토리

생성 → 누구나 가능
삭제 → 파일 소유자만 가능
```

대표적인 예가 `/tmp`와 같은 공용 디렉토리다.

### Sticky Bit 표시

```text
drwxrwxrwt
        ↑
        t = Sticky Bit
```

### 왜 필요한가?

공유 디렉토리에 여러 사용자가 쓰기 권한을 가지고 있으면 다른 사용자의 파일까지 삭제할 수 있는 문제가 생길 수 있다.

Sticky Bit를 사용하면:

```text
같은 디렉토리의 파일에 접근 가능
        ↓
하지만 다른 사용자의 파일을 삭제할 수는 없음
```

---

## 4. SGID + Sticky Bit

공유 디렉토리에서는 **SGID와 Sticky Bit를 함께 사용할 수도 있다.**

```text
SGID
↓
새로 생성되는 파일이 디렉토리의 그룹을 상속

Sticky Bit
↓
다른 사용자의 파일을 삭제하지 못하도록 제한
```

즉,

```text
공유 디렉토리
 ├─ 그룹 소유권은 동일하게 유지
 └─ 다른 사용자의 파일 삭제는 제한
```

---

## 5. ACL

**ACL (Access Control List)**

기본적인 Linux 권한은 다음 세 가지로 나뉜다.

```text
사용자(owner)
그룹(group)
기타(other)
```

하지만 특정 사용자에게만 **예외적인 권한**을 주고 싶을 때는 기본 권한만으로 부족할 수 있다.

이때 사용하는 것이 **ACL**이다.

### ACL 설정

```bash
setfacl -m u:사용자명:권한 파일명
```

예시:

```bash
setfacl -m u:user2:rwx report.txt
```

→ `user2`에게 `report.txt`의 `rwx` 권한을 추가

### ACL 확인

```bash
getfacl 파일명
```

예시:

```bash
getfacl report.txt
```

### 핵심

```text
기본 권한
사용자 / 그룹 / 기타

ACL
특정 사용자나 그룹에 추가적인 권한을 지정
```

---

## 6. 특수 권한 숫자 표기 ⭐

`chmod`의 가장 앞쪽 숫자를 이용하여 특수 권한을 지정할 수 있다.

| 숫자 | 특수 권한 |
|---:|---|
| `4` | SUID |
| `2` | SGID |
| `1` | Sticky Bit |

### 예시

```bash
chmod 4755 file
```

→ `4` = SUID

```bash
chmod 2775 directory
```

→ `2` = SGID

```bash
chmod 1777 directory
```

→ `1` = Sticky Bit

여러 특수 권한은 조합할 수도 있다.

```text
4 = SUID
2 = SGID
1 = Sticky Bit
```

예를 들어:

```bash
chmod 3770 shared_dir
```

→ `3 = 2 + 1`

→ SGID + Sticky Bit

---

## 7. 한눈에 정리

| 권한 | 의미 | 주로 사용하는 곳 |
|---|---|---|
| **SUID** | 파일 소유자의 권한으로 실행 | 실행 파일 |
| **SGID** | 디렉토리의 그룹을 새 파일이 상속 | 공유 디렉토리 |
| **Sticky Bit** | 파일 삭제를 소유자 중심으로 제한 | 공유 디렉토리 |
| **ACL** | 특정 사용자/그룹에 예외적인 권한 부여 | 세밀한 권한 관리 |

### 특수 권한 숫자

```text
4 → SUID
2 → SGID
1 → Sticky Bit
```

---

## 8. 오늘 기억할 명령어

```bash
# SUID 파일 찾기
find / -perm -4000 -type f

# SGID 설정
chmod g+s shared_dir

# Sticky Bit 설정
chmod +t shared_dir

# ACL 설정
setfacl -m u:사용자명:권한 파일명

# ACL 확인
getfacl 파일명
```

---

## 9. 핵심 요약

> **SUID** → 파일을 **소유자의 권한으로 실행**

> **SGID** → 디렉토리에서 생성되는 파일이 **디렉토리의 그룹을 상속**

> **Sticky Bit** → 공유 디렉토리에서 **다른 사용자의 파일 삭제를 제한**

> **ACL** → 특정 사용자나 그룹에게 **예외적인 권한을 추가**

```text
특수 권한 숫자

4 = SUID
2 = SGID
1 = Sticky Bit
```
