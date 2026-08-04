# 📘 Day 4 - Partition · Filesystem · Link

> **디스크가 어떻게 구성되고, 파일이 어떻게 연결되는지 이해하기**
>
> Partition, Filesystem, Hard Link, Symbolic Link

---

# 1️⃣ 핵심 개념

| 개념 | 영어 | 한 줄 정의 |
|------|------|-----------|
| **파티션** | Partition | 물리 디스크를 논리적으로 나눈 저장 공간 |
| **파일시스템** | Filesystem | 파티션 위에서 데이터를 저장·관리하는 규칙 (ext4, XFS 등) |
| **하드 링크** | Hard Link | 동일한 inode를 공유하는 또 다른 파일명 |
| **심볼릭 링크** | Symbolic Link | 원본 파일의 경로를 저장하는 링크 파일 |

---

# 2️⃣ 시스템 동작 구조

## ① Partition과 Filesystem
하나의 파티션에는 하나의 파일시스템이 존재

```text
물리 디스크 (/dev/sda)

        │
        ▼

┌──────────────────────────────┐
│ Partition 1 (/dev/sda1)      │
│ Filesystem : ext4            │
└──────────────────────────────┘

┌──────────────────────────────┐
│ Partition 2 (/dev/sda2)      │
│ Filesystem : XFS             │
└──────────────────────────────┘
```

---

## ② Hard Link vs Symbolic Link

### Hard Link

```text
test.txt ─────┐
              ├── inode 2621447
hard.txt ─────┘
```

### 핵심 원리

- 같은 inode 공유
- 원본 삭제 후에도 데이터 유지
- Link Count가 0이 되어야 실제 삭제됨

---

### Symbolic Link

```text
symlink.txt
      │
      ▼
test.txt
```

### 핵심 원리

- 원본 경로를 저장
- 별도의 inode 생성
- 원본 삭제 시 Broken Link 발생

---

# 3️⃣ 실무 활용

### 무중단 배포
Symbolic Link만 변경하여 서비스 중단 없이 배포한다.

---

### 스냅샷 백업

Hard Link를 이용하여

변경되지 않은 파일은 중복 저장하지 않는다.

---

# 4️⃣ 위험 명령어

```bash
rm -rf
```

### 주의사항

- 삭제 전 경로 확인
- `ls`로 대상 확인 후 실행
- 변수 사용 시 빈 값 검증

---

# 5️⃣ 꼭 기억할 것

✅ **Partition**

- 디스크 공간 분할

✅ **Filesystem**

- 데이터 저장 규칙

✅ **Hard Link**

- 동일 inode 공유
- 원본 삭제 후에도 사용 가능

✅ **Symbolic Link**

- 원본 경로 저장
- 원본 삭제 시 링크 깨짐

---

# 💡 한 줄 요약

> **Partition은 저장 공간을 나누고, Filesystem은 데이터를 관리한다. Hard Link는 같은 데이터를 공유하는 또 다른 이름이며, Symbolic Link는 원본을 가리키는 경로이다.**
