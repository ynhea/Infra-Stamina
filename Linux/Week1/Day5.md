# Linux System Shell Script 만들기

## 1. 구현 기능

- 커널 버전, 배포판 정보, 현재 쉘을 출력
- 현재 마운트된 파일시스템 목록과 사용량을 출력
- 지정한 디렉토리(`~/Workspace`) 하위 파일들의 inode 번호를 나열
- 하드링크와 심볼릭 링크를 하나씩 만들어 두 링크의 차이를 실행 결과로 증명

---

## 2. 환경

| 항목 | 내용 |
|---|---|
| **OS** | Arch Linux |
| **Shell** | Bash |
| **Kernel** | `7.1.8-arch1-3` |
| **Filesystem** | ext4 |
| **Script** | `system_script.sh` |

---

## 3. 스크립트

```bash
#!/bin/bash

echo "=== 커널 버전 ==="
uname -r

echo "=== 배포판 정보 ==="
cat /etc/os-release

echo "=== 현재 쉘 ==="
echo $SHELL

echo "=== 파일시스템 목록 ==="
mount

echo "=== 사용량 ==="
df -h

echo "=== inode번호 ==="
touch ~/Workspace/example
ls -li ~/Workspace

echo "=== 하드링크 생성 ==="
rm -f ~/Workspace/hard_example
ln ~/Workspace/example ~/Workspace/hard_example

echo "=== 심볼릭 링크 생성 ==="
rm -f ~/Workspace/soft_example
ln -s ~/Workspace/example ~/Workspace/soft_example

echo "=== 하드링크 vs 심볼릭링크 차이 ==="
ls -li ~/Workspace

echo "=== 원본 삭제 후 링크 상태 비교 ==="
rm ~/Workspace/example

echo "-- 하드링크 (정상출력) --"
cat ~/Workspace/hard_example

echo "-- 심볼릭링크 (에러발생) --"
cat ~/Workspace/soft_example
```

---

## 4. 실행 방법

### ① 실행 권한을 부여

```bash
chmod 755 system_script.sh
```

### ② 권한의 의미

| 권한 | 값 | 의미 |
|---|---:|---|
| `r` | 4 | 읽기 |
| `w` | 2 | 쓰기 |
| `x` | 1 | 실행 |

### `755` 권한

```text
7 (소유자) = 4 + 2 + 1
           = rwx
           = 읽기, 쓰기, 실행 모두 가능

5 (그룹)   = 4 + 1
           = r-x
           = 읽기와 실행 가능

5 (기타)   = 4 + 1
           = r-x
           = 읽기와 실행 가능

755 = rwxr-xr-x
```

### ③ 스크립트를 실행

```bash
./system_script.sh
```
