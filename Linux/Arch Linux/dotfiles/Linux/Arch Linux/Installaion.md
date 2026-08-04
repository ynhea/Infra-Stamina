# 🚀 Arch Linux 설치

## 📌 0단계. 라이브 USB로 굽기

- ISO를 다운로드하기
- USB에 굽기
- F12를 연타해 부팅설정 화면으로 들어간 후, 윈도우가 아닌 Arch Linux가 1순위로 부팅되도록 설정
- `root@archiso ~ #` 가 보임. 이는
**"USB로 만든 임시 리눅스가 잘 켜졌고, 지금부터 명령어를 입력할 수 있다"** 는 뜻임

설치 전까지의 모든 작업은 컴퓨터에 실제로 리눅스를 "설치"하는 준비 작업임.
아직 USB 안의 임시 프로그램일 뿐, 컴퓨터 하드디스크에는 아무것도 설치되지 않은 상태임!!!

---

## 📌 1단계. 부팅 모드가 UEFI인지 확인하기

```bash
cat /sys/firmware/efi/fw_platform_size
```

- **부팅모드**란 컴퓨터가 처음 켜질 때 운영체제를 실행하는 방식으로 UEFI, BIOS가 있음
- 이 명령이 `64` 또는 `32` 같은 숫자를 출력하면 → **UEFI 모드로 잘 부팅되었음을 의미**
- 아무것도 안 나오고 "No such file or directory" 라고 뜨면 → BIOS 모드로 부팅된 것임.
- UEFI임을 확인해야함!

---

## 📌 2단계. 인터넷이 연결되어 있는지 확인하기

```bash
ping -C 3 archlinux.org
```

- `ping` = "저쪽 서버한테 신호를 보내고, 잘 도착하는지 확인해줘" 라는 명령어.
- 3번만 Count해서 신호보냄

### 인터넷이 안 될 경우 (와이파이 연결하기)

```bash
iwctl
```
- `iwctl` = 와이파이를 조작하는 프로그램을 켜는 명령어. 치면 프롬프트가 `[iwd]#` 로 바뀜

그 안에서 순서대로:

```bash
device list
```
- 내 컴퓨터의 와이파이 장치 이름을 보여달라는 명령어.

```bash
station wlan0 scan
station wlan0 get-networks
```
- 주변 와이파이 신호를 찾고(scan), 목록을 보여달라는 명령(get-networks).

```bash
station wlan0 connect 와이파이이름
```
- 와이파이에 연결. (이후, 비밀번호 입력)

```bash
exit
```
- iwctl에서 나가서 다시 `root@archiso` 화면으로 돌아오기

연결됐으면 다시 `ping archlinux.org` 로 확인하기!

---

## 📌 3단계. 시간 동기화

```bash
timedatectl set-ntp true
```

- `timedatectl` = 시간을 관리하는 명령어
- `set-ntp true` = "인터넷 시간 서버랑 자동으로 시간 맞춰줘" 라는 뜻
- 시간이 안 맞으면 설치 도중 패키지 서명 검증 등에서 오류가 날 수 있어서 꼭 해줘야 함

---

## 📌 4단계. 디스크 확인하기

```bash
lsblk
```

- `lsblk` = "List Block devices"의 줄임말. Block Device는 리눅스가 연결된 저장장치를 부르는 말로, 따라서 연결된 저장장치 목록을 보여달라는 명령임.
- `sda`, `nvme0n1` 같은 이름을 찾으세요. 이게 여러분의 SSD/하드디스크 이름이에요.
- ⚠️ **이 이름을 정확히 확인해야 함!!**
- sda는 연결된 USB이므로 (용량확인해보면 알 수 있다) SSD로 설정해주기 위해 `/dev/nvme0n1`로 디스크를 정한다.

---

## 📌 5단계. 디스크 파티션(구역) 나누기

보통 아래와 같이 3개의 방이 필요함

| 방 이름 | 파티션 번호(예시) | 용도 | 크기 |
|---|---|---|---|
| EFI 방 | `/dev/nvme0n1p1` | 부팅 프로그램 두는 공간 | 512M |
| swap 방 | `/dev/nvme0n1p2` | 메모리(RAM)가 부족할 때 대신 쓰는 공간 | 4G |
| root 방 | `/dev/nvme0n1p3` | 실제 리눅스 프로그램/파일이 저장되는 공간 | 나머지 전체 |

```bash
cfdisk /dev/nvme0n1
```
- `cfdisk` = 화면으로 보면서 파티션을 쉽게 나눌 수 있는 프로그램

cfdisk 화면 안에서:
1. `[New]` 선택 → 크기 입력 → EFI 파티션 만들기 → Type을 `EFI System` 으로 지정
2. `[New]` 선택 → 크기 입력 → swap 파티션 만들기 → Type을 `Linux swap` 으로 지정
3. `[New]` 선택 → 남은 공간 전부 → root 파티션 만들기 (Type은 기본 `Linux filesystem`)
4. `[Write]` 선택 → `yes` 입력 (진짜 저장한다는 확인)
5. `[Quit]` 선택해서 나가기

> 💡 이미 윈도우가 설치되어 있는 경우 **듀얼부팅**을 고려할 수 있으나, 초보자에겐 어렵다하여... 윈도우를 지우고 진행함

---

## 📌 6단계. 파티션 포맷하기 (파티션에 이름표 붙이기)

```bash
mkfs.fat -F32 /dev/nvme0n1p1
```
- `mkfs.fat` = FAT 형식으로 포맷하는 명령어 (EFI 방은 이 형식이어야 함)
- `-F32` = FAT32 버전

```bash
mkswap /dev/nvme0n1p2
swapon /dev/nvme0n1p2
```
- `mkswap` = swap 방으로 만들기
- `swapon` = swap 방을 지금부터 켜서 써라는 명령

```bash
mkfs.ext4 /dev/nvme0n1p3
```
- `mkfs.ext4` = 리눅스가 가장 많이 쓰는 ext4 형식으로 포맷

---

## 📌 7단계. 파티션을 연결(마운트)하기

지금까지 방만 만든 상태로, 이를 연결해주는 마운트 과정을 진행함

```bash
mount /dev/nvme0n1p3 /mnt
```
- root 파티션을 `/mnt` 라는 임시 작업 폴더에 연결

```bash
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```
- `mkdir -p` = 폴더가 없으면 새로 만들어라
- EFI 파티션을 `/mnt/boot` 폴더에 연결 (부팅 관련 파일이 여기 저장됨)

> 참고: swap 파티션은 이미 6단계에서 `swapon`으로 켜둔 상태라 별도로 mount할 필요없음

> 파티션3(nvme0n1p3)의 빈 방(boot)안에 파티션1(nvme0n1p1)을 연결하는 것

---

## 🚀 8단계. 실제 리눅스 시스템 설치 (가장 중요한 단계!)

```bash
pacstrap -K /mnt base linux linux-firmware
```

- `pacstrap` = 아치리눅스의 기본 프로그램들을 `/mnt` (root 파티션)에 깔아주는 명령어
- `-K` = 패키지 서명 검증용 열쇠 꾸러미를 만드는 옵션(바이러스 방지)
- `base` = 리눅스가 돌아가기 위한 최소한의 필수 프로그램 모음
- `linux` = 리눅스 커널
- `linux-firmware` = 그래픽카드/와이파이 등 하드웨어를 인식하게 해주는 드라이버 모음

---

## 📌 9단계. fstab 만들기 (방을 연결하는 방법을 적어둔 파일)

EFI로 리눅스가 켜진 후, fstab을 보면서 저장된 방을 연결해서 쓸 수 있게 해줌.

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

- `genfstab` = 지금 마운트된 파티션 정보를 자동으로 읽어서 정리해주는 명령어
- `-U` = 디스크 이름 대신 고유번호(UUID)로 기록 (디스크 순서가 바뀌어도 안전)
- `>> /mnt/etc/fstab` = 결과를 `fstab` 파일에 저장

---

## 📌 10단계. 새로 설치한 시스템 안으로 들어가기

```bash
arch-chroot /mnt
```

- `arch-chroot` = "이제부터 명령어는 USB 안의 임시 리눅스가 아니라, 방금 새로 설치한 진짜 리눅스 기준으로 실행해줘" 라는 명령

---

## 📌 11단계. 시간대 설정

```bash
ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
hwclock --systohc
```

- `ln -sf` = 바로가기 파일을 만드는 명령어. `/usr/share/zoneinfo/Asia/Seoul`은 서울 시간대 정보 파일이에요.
- `hwclock --systohc` = 지금 설정한 시간을 컴퓨터 내부 하드웨어 시계(클럭)에도 저장 (컴퓨터를 꺼도 시간이 유지되게)

> timedatectl로 시간 설정한 것은 USB에서 임시로 맞춘 것이므로, 다시 설정해줘야함

---

## 📌 12단계. 언어 설정

```bash
nano /etc/locale.gen
```

- `nano` = 텍스트 편집 프로그램을 여는 명령어
- 파일 안에서 `en_US.UTF-8 UTF-8` 줄을 찾아서 맨 앞의 `#`을 지우기. (`#`은 주석 표시이므로, 지우면 "이 기능을 켠다"는 뜻이 됨)
- 한글도 쓰고 싶으면 `ko_KR.UTF-8 UTF-8` 줄도 찾아서 `#`을 지우기.
- 저장: `Ctrl + O` → `Enter` → 나가기: `Ctrl + X`

```bash
locale-gen
```
- nano로 쓸 거라고 체크표시했으므로, 컴퓨터가 진짜 쓸 수 있게 파일로 만들어내야됨

```bash
echo "LANG=en_US.UTF-8" > /etc/locale.conf
```
- `echo` = 기본 모국어를 지정하는 명령어
- `>` = 그 내용을 파일에 저장 (기존 내용은 덮어씀)

---

## 📌 13단계. 호스트네임 (컴퓨터 이름) 설정

```bash
echo "palace" > /etc/hostname
```

---

## 📌 14단계. 네트워크 관리 프로그램 설치

```bash
pacman -S networkmanager
systemctl enable NetworkManager
```

- `pacman -S` = 프로그램을 설치하는 명령어
- `networkmanager` = 와이파이/인터넷을 쉽게 관리해주는 프로그램
- `systemctl enable` = 컴퓨터를 켤 때마다 이 프로그램이 자동 실행되게 해줘라는 명령어

---

## 📌 15단계. 루트(관리자) 비밀번호 설정

```bash
passwd
```

---

## 📌 16단계. 부트로더(운영체제 선택) 설치 

```bash
pacman -S grub efibootmgr
```

- `grub` = 부트로더
- `efibootmgr` = EFI와 GRUB를 연결해주는 것

```bash
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

- `grub-install` = grub을 실제로 설치. `--target=x86_64-efi`는 UEFI용 설치 옵션, `--efi-directory=/boot`는 EFI 파일 위치, `--bootloader-id=GRUB`는 부팅 메뉴에 표시될 이름
- `grub-mkconfig -o /boot/grub/grub.cfg` = 부팅 메뉴 설정 파일을 자동 생성

---

## 📌 17단계. 일반 사용자 계정 만들기 (매번 root로 로그인하면 위험해서 필요)

```bash
useradd -m -G wheel talju
passwd talju
```

- `useradd -m -G wheel talju` = `talju`이라는 사용자를 만들고(`-m`: 홈 폴더도 같이 생성), `wheel` 그룹에 넣음 (이 그룹에 속하면 나중에 sudo, 즉 관리자 권한을 잠깐씩 빌려 쓸 수 있음)
- `passwd yourname` = 해당 사용자의 비밀번호 설정

```bash
pacman -S sudo
EDITOR=nano visudo
```

- `sudo` = 일반 사용자가 잠깐 관리자 권한으로 명령어를 실행할 수 있게 해주는 프로그램
- `visudo` = sudo 권한 설정 파일을 안전하게 편집하는 명령어
- 열리면 `# %wheel ALL=(ALL:ALL) ALL` 줄을 찾아서 맨 앞의 `#`을 지우기 (wheel 그룹은 sudo권한 갖게 설정)

---

## 📌 18단계. chroot에서 나와서 재부팅

```bash
exit
umount -R /mnt
reboot
```

- `exit` = chroot(새 시스템)에서 나와서 다시 USB의 임시 리눅스로 돌아감
- `umount -R /mnt` = 마운트했던 파티션들을 하위 폴더까지 한 번에 해제 (`-R`)
- `reboot` = 컴퓨터를 다시 시작. 이때 **USB를 뽑기!!**

> 리눅스 설치(8단계) 전 mount했던 것들을 참고해 컴퓨터에 리눅스를 설치완료했으므로, 임시 USB와 SSD방들을 연결한 mnt를 umount해줘야 함.

---

## 📌 19단계. 재부팅 후 로그인

- 로그인 성공하면 아치리눅스 설치 완료!!!

---

## 🎉 요약

- **1~7단계** = 설치 전 설정 (임시 USB와 SSD연결)
- **8단계** = 임시 설정(↑)을 참고하여 Arch Linux설치
- **9~19단계** = 설치 후 설정

| 단계 | 내용 | 핵심 명령어 |
|---|---|---|
| 1 | UEFI 모드 확인 | `cat /sys/firmware/efi/fw_platform_size` |
| 2 | 인터넷 연결 확인/와이파이 연결 | `ping`, `iwctl` |
| 3 | 시간 동기화 | `timedatectl set-ntp true` |
| 4 | 디스크 이름 확인 | `lsblk` |
| 5 | 파티션 나누기 | `cfdisk` |
| 6 | 파티션 포맷 | `mkfs.fat`, `mkswap`, `mkfs.ext4` |
| 7 | 파티션 마운트 | `mount` |
| 8 | 시스템 설치 | `pacstrap` |
| 9 | fstab 생성 | `genfstab` |
| 10 | chroot 진입 | `arch-chroot` |
| 11 | 시간대 설정 | `ln -sf`, `hwclock` |
| 12 | 로케일 설정 | `locale-gen` |
| 13 | 호스트네임 설정 | `echo > /etc/hostname` |
| 14 | 네트워크 매니저 설치 | `pacman -S networkmanager` |
| 15 | root 비밀번호 설정 | `passwd` |
| 16 | 부트로더(grub) 설치 | `grub-install`, `grub-mkconfig` |
| 17 | 일반 사용자 계정 생성 + sudo | `useradd`, `visudo` |
| 18 | chroot 나가기 → 마운트 해제 → 재부팅 | `exit`, `umount -R`, `reboot` |
| 19 | 새 계정으로 로그인 | - |
