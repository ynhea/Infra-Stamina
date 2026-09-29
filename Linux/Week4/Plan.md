# 이번 주 목표
 
이번 주는 **Linux 커리큘럼의 마지막 주차**로, 일곱 번째·여덟 번째 챕터인 **"systemd"**와 **"Shell Script"**를 다룬다. 3주차에서 Process와 Daemon 개념을 배웠다면, 이번 주는 그 데몬들을 실제로 어떤 시스템이 관리하는지(systemd)를 배우고, 후반부에서는 지금까지 손으로 한 줄씩 실행하던 명령어들을 변수와 제어문으로 자동화하는 방법(Shell Script)을 배운다. 지난 3주 동안 만든 프로젝트 스크립트들이 사실 전부 "순서대로 나열한 명령어"였다는 걸 돌아보면, 이번 주부터는 그 스크립트가 조건에 따라 판단하고 반복하는 진짜 "프로그램"이 되기 시작한다.
 
---
 
## 월요일
 
### 학습 목표
systemd가 무엇을 관리하는 시스템인지 이해하고, 서비스를 제어하는 기본 명령어 `systemctl`을 익힌다. 3주차에 배운 Daemon 개념이 실제로 어떻게 관리되는지 연결해서 이해한다.
 
### 배울 개념
- **Unit** : systemd가 관리하는 자원의 최소 단위 (service, socket, target 등 여러 종류가 있음)
- **Service** : 데몬 프로세스를 시작·중지·감시하는 유닛 타입 (`.service` 파일로 정의)
- **systemctl** : 서비스를 제어하는 명령어 (`start`, `stop`, `restart`, `status`, `enable`, `disable`)
### 실습
```bash
systemctl status sshd          # sshd 서비스 상태 확인
sudo systemctl restart sshd     # 서비스 재시작
sudo systemctl enable sshd      # 부팅 시 자동 시작 등록
systemctl list-units --type=service   # 현재 등록된 서비스 유닛 목록
```
 
**예상 결과**
```
$ systemctl status sshd
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled)
     Active: active (running) since ...
```
 
**왜 이렇게 되는가**
3주차에서 Daemon은 "로그인과 무관하게 백그라운드에서 계속 실행되는 프로세스"라고 배웠다. systemd는 그 데몬들을 PID 1로서 총괄 관리하는 시스템이다. `.service` 파일 안에는 `ExecStart`(실행할 명령), `Restart`(비정상 종료 시 재시작 정책) 같은 설정이 들어있어서, 데몬이 죽었을 때 사람이 직접 재실행하지 않아도 systemd가 알아서 정책에 따라 되살릴 수 있다.
 
### 오늘 꼭 기억해야 하는 내용
- **enable과 start는 다르다.** `enable`은 "부팅할 때 자동으로 켜지도록 등록"하는 것이고, `start`는 "지금 당장 켜는 것"이다. 둘 다 해야 "지금도 켜져 있고 재부팅해도 켜지는" 상태가 된다.
- 서비스를 만지기 전엔 항상 `systemctl status`로 현재 상태를 먼저 확인하는 습관을 들인다.
---
 
## 화요일
 
### 학습 목표
여러 서비스를 그룹으로 묶는 target 개념과, 서비스의 로그를 확인하는 `journalctl`을 익힌다.
 
### 배울 개념
- **target** : 여러 유닛을 묶어 정의하는 "목표 상태" (예: `multi-user.target`, `graphical.target`) — 과거 SysV init의 runlevel을 대체하는 개념
- **journalctl** : systemd가 관리하는 통합 로그(저널)를 조회하는 명령어 (`-u 서비스명`, `-f` 실시간, `--since`)
### 실습
```bash
systemctl get-default              # 현재 기본 target 확인
journalctl -u sshd --since "1 hour ago"   # 최근 1시간 sshd 로그
journalctl -f                       # 실시간 로그 스트리밍 (Ctrl+C로 종료)
```
 
**예상 결과**
```
$ systemctl get-default
graphical.target
 
$ journalctl -u sshd --since "1 hour ago"
Sep 27 10:03:12 host sshd[1234]: Server listening on 0.0.0.0 port 22.
```
 
**왜 이렇게 되는가**
target은 "이 상태가 되려면 어떤 서비스들이 실행되어 있어야 하는가"를 정의한 의존성 그래프다. `multi-user.target`은 콘솔 로그인만 가능한 서버용 상태, `graphical.target`은 그 위에 GUI까지 올라가는 상태를 의미한다. `journalctl`이 편리한 이유는, 예전처럼 `/var/log/` 아래 여러 파일을 뒤질 필요 없이 `-u` 옵션 하나로 특정 서비스의 로그만 정확히 필터링할 수 있기 때문이다.
 
### ⚠ 위험한 명령어 주의
서비스 파일(`.service`)을 직접 수정한 뒤 `sudo systemctl daemon-reload`를 실행하지 않으면 변경 사항이 반영되지 않은 채로 서비스를 재시작하게 되어 "분명히 고쳤는데 왜 안 바뀌지?" 하는 혼란이 생긴다. 설정 파일을 만졌다면 반드시 `daemon-reload` → `restart` 순서를 지킨다.
 
### 오늘 꼭 기억해야 하는 내용
- target = 여러 서비스를 묶은 "목표 상태", 과거의 runlevel과 유사한 개념
- `journalctl -u 서비스명`으로 특정 서비스 로그만 빠르게 확인할 수 있다
---
 
## 수요일
 
### 학습 목표
지금까지 순서대로 명령어를 나열하기만 했던 스크립트에 변수와 조건 분기를 도입한다. 변수, `if`, `case` 문법을 익힌다.
 
### 배울 개념
- **Variable(변수)** : 값을 저장하고 재사용하는 문법 (`이름=값`으로 선언, `$이름`으로 참조)
- **if** : 조건에 따라 다른 명령을 실행 (`[ ]` 또는 `[[ ]]`로 조건 검사)
- **case** : 여러 조건을 패턴 매칭으로 깔끔하게 분기 처리
### 실습
```bash
#!/bin/bash
name="devuser"
echo "안녕하세요, $name 님"
 
if [ -z "$1" ]; then
  echo "인자를 입력해주세요."
else
  echo "입력한 인자: $1"
fi
 
case "$1" in
  start) echo "서비스를 시작합니다" ;;
  stop) echo "서비스를 중지합니다" ;;
  *) echo "알 수 없는 명령입니다" ;;
esac
```
 
**예상 결과**
```
$ ./test.sh
안녕하세요, devuser 님
인자를 입력해주세요.
알 수 없는 명령입니다
 
$ ./test.sh start
안녕하세요, devuser 님
입력한 인자: start
서비스를 시작합니다
```
 
**왜 이렇게 되는가**
지금까지의 프로젝트 스크립트는 사실 모든 명령이 항상 같은 순서로 실행되는 "일직선 나열"이었다. `if`가 들어가는 순간부터 스크립트는 상황에 따라 다르게 반응할 수 있게 된다. `[ -z "$1" ]`는 "첫 번째 인자가 비어있는가"를 검사하는 것으로, 지난 주 프로젝트에서 "인자를 안 주면 어떻게 될지 인지만 해두라"고 넘어갔던 문제를 이제 정식으로 처리할 수 있게 된다.
 
### ⚠ 위험한 명령어 주의
`if [ $1 = "x" ]`처럼 변수를 따옴표 없이 쓰면, `$1`이 비어있을 때 `[ = "x" ]`라는 문법 오류로 스크립트가 깨진다. 변수는 항상 `"$1"`처럼 따옴표로 감싸는 습관을 들여야 한다.
 
### 오늘 꼭 기억해야 하는 내용
- 변수는 `이름=값`으로 선언(등호 앞뒤 공백 없이), 사용할 땐 `$이름`
- 변수는 항상 따옴표로 감싸서 사용한다 (`"$1"`) — 빈 값일 때 오류를 방지
---
 
## 목요일
 
### 학습 목표
반복 작업을 자동화하는 `for`, `while`과, 코드 중복을 줄이는 `function`을 익힌다. 지난 2, 3주차 프로젝트에서 직접 타이핑했던 반복 패턴을 이제 코드로 만든다.
 
### 배울 개념
- **for** : 목록(파일, 숫자, 문자열 등)을 순회하며 반복 실행
- **while** : 조건이 참인 동안 반복 실행
- **function** : 반복해서 쓰는 코드 블록을 이름 붙여 재사용
- **grep/sed/awk** : 텍스트를 검색(grep)·치환(sed)·필드 추출(awk)하는 도구, 반복문과 결합해 로그 분석에 자주 쓰인다
### 실습
```bash
#!/bin/bash
 
func() {
    echo "=== $1 ==="
}
 
func "서비스 점검 시작"
 
services="sshd cron"
for s in $services; do
    echo "[$s] 상태 확인"
    systemctl is-active "$s"
done
 
count=0
while [ $count -lt 3 ]; do
    echo "대기 중... ($count)"
    count=$((count+1))
    sleep 1
done
```
 
**예상 결과**
```
=== 서비스 점검 시작 ===
[sshd] 상태 확인
active
[cron] 상태 확인
active
대기 중... (0)
대기 중... (1)
대기 중... (2)
```
 
**왜 이렇게 되는가**
2, 3주차 프로젝트에서 `echo "=== ... ==="`를 매번 직접 타이핑했던 걸 기억하는가? 그게 바로 `function`으로 묶어야 할 반복 패턴이었다. `for`는 "이미 정해진 목록"을 순회할 때, `while`은 "조건이 유지되는 동안" 반복할 때 사용한다는 차이를 구분해야 한다. `grep`은 로그에서 `error`나 `failed` 같은 패턴을 찾을 때, `awk`는 `ps aux`처럼 여러 컬럼으로 된 출력에서 특정 필드(예: PID)만 뽑아낼 때 유용하다.
 
### 오늘 꼭 기억해야 하는 내용
- `for` = 정해진 목록을 순회, `while` = 조건이 참인 동안 반복
- `function`으로 반복되는 코드(특히 섹션 제목 출력 같은 패턴)를 하나로 통일하면 유지보수가 쉬워진다
- `grep`은 검색, `sed`는 치환, `awk`는 필드 추출 — 로그 분석의 기본 3인방
---
 
## 금요일
 
### 프로젝트 제목
**"서비스 및 로그 진단 자동화 스크립트"**
 
### 프로젝트 목표
월~목에 배운 `systemctl`, `journalctl`과 변수·조건문·반복문·함수를 결합해, 여러 서비스의 상태를 자동으로 점검하고 로그를 출력하는 진단 스크립트를 만든다.
 
### 구현해야 하는 기능
1. 점검할 서비스 이름들을 변수(리스트)로 지정 (예: `sshd`, `cron`)
2. `for`문으로 각 서비스를 순회하며 `systemctl is-active`로 실행 상태 확인
3. 서비스가 비활성(inactive) 상태라면 `if`문으로 분기해 경고 메시지 출력 (자동 재시작은 하지 않음)
4. 각 서비스마다 `journalctl -u 서비스명 -n 10`으로 최근 로그 10줄 출력
5. 반복되는 섹션 제목 출력을 `function`으로 리팩토링
힌트: 서비스 목록은 `services="sshd cron"`처럼 공백으로 구분된 문자열로 만들고 `for s in $services`로 순회하면 된다. `systemctl is-active`의 반환값이 "active"인지 아닌지를 `if`로 비교해보자.
 
### 사용해야 하는 Linux 기술
`systemctl`, `journalctl`, 변수, `if`, `for`, `function`
 
---
 
## 토요일
 
### 프로젝트 확장
금요일 스크립트를 **지속적으로 모니터링하고, 문제 있는 로그만 강조해서 보여주는 도구**로 발전시킨다.
 
### 추가 기능
- `while`문을 이용해 사용자가 종료(Ctrl+C 등)할 때까지 일정 주기로 서비스 상태를 반복 점검
- `grep`으로 로그에서 `error`, `failed` 같은 패턴만 필터링해서 별도로 강조 출력
- 점검할 서비스 목록을 스크립트 상단의 변수 하나로만 관리하도록 통일 (하드코딩 최소화)
- 실행 결과를 `service_check_날짜.txt`로 저장
힌트: `while true; do ... sleep 5; done` 형태로 무한 반복 점검 루프를 만들 수 있다. 다만 무한 루프는 반드시 종료 방법(Ctrl+C 또는 반복 횟수 제한)을 마련해두어야 한다는 점을 3주차에 배운 kill/시그널 개념과 연결해서 생각해보자.
 
### 리팩토링 포인트
- 서비스 목록이 스크립트 여러 곳에 흩어져 있지 않고 변수 하나로 관리되는지
- `function`으로 묶을 수 있는 반복 패턴이 더 있는지 다시 살펴보기
- 무한 루프에 탈출 조건이나 최소한의 안내 문구가 있는지 (본격적인 예외 처리는 계속 실무에서 다듬어 나가는 영역이다)
---
 
## 일요일
 
### 복습 체크리스트
- [ ] `systemctl enable`과 `systemctl start`의 차이를 설명할 수 있는가
- [ ] target이 무엇을 묶는 개념인지, 과거 runlevel과 어떻게 연결되는지 설명할 수 있는가
- [ ] `journalctl -u`로 특정 서비스 로그만 필터링하는 방법을 알고 있는가
- [ ] 변수를 따옴표 없이 쓰면 왜 위험한지 예시를 들어 설명할 수 있는가
- [ ] `for`와 `while`을 각각 언제 써야 하는지 구분할 수 있는가
### 암기 키워드
`Unit` · `Service` · `systemctl` · `target` · `journalctl` · `Variable` · `if` · `case` · `for` · `while` · `function` · `grep/sed/awk`
 
### 셀프 테스트 (5문제)
1. `systemctl enable`과 `systemctl start`는 각각 무엇을 하는 명령인가?
2. `journalctl -u sshd`가 `/var/log`를 직접 뒤지는 것보다 편리한 이유는 무엇인가?
3. `if [ $1 = "x" ]`처럼 변수를 따옴표 없이 사용하면 어떤 문제가 생길 수 있는가?
4. `for`문과 `while`문을 사용해야 하는 상황을 각각 예시로 들어보라.
5. `function`으로 반복 패턴을 묶으면 어떤 실무적 이점이 있는가?
### Linux 마무리
 
이번 주를 끝으로 **Linux 기초 커리큘럼을 마무리한다.**
 
지금까지 배운 내용을 다음 흐름으로 연결해서 이해하는 것이 목표다.
 
**파일·권한 → Process → Daemon → systemd → 로그 확인 → Shell Script → 자동화**
 
특히 이번 주에 배운 `systemctl`, `journalctl`, 변수, 조건문, 반복문, 함수는 이후 **Network, Docker, AWS, Kubernetes**를 공부할 때도 계속 활용하게 된다.
 
다음 단계에서는 Linux에서 익힌 기본기를 바탕으로 **Network**를 본격적으로 학습한다. Linux를 완전히 끝내고 새로운 것을 시작한다기보다, Linux 서버 위에서 실제로 통신이 어떻게 이루어지는지를 확장해서 배우는 단계라고 생각하면 된다.
 
---
 
# 이번 주 핵심 개념 5가지
 
> **Linux 마지막 주차:** 이번 주는 Linux에서 배운 개념을 서비스 관리와 자동화까지 연결하며 마무리한다.
1. **Unit / Service / systemctl** — systemd가 데몬을 유닛 단위로 관리하고 제어하는 방식
2. **enable vs start** — 부팅 시 자동 실행 등록 vs 지금 당장 실행하는 것의 차이
3. **target / journalctl** — 여러 서비스를 묶은 목표 상태와, 통합 로그를 필터링해서 보는 방법
4. **Variable / if / case** — 값을 저장하고, 조건에 따라 스크립트가 다르게 반응하게 만드는 기초 문법
5. **for / while / function** — 반복 작업 자동화와 코드 재사용을 위한 제어 구조
# 실무 활용 사례
- 배포 자동화 스크립트에서 애플리케이션을 `.service` 파일로 등록해, 서버가 재부팅돼도 `systemctl enable` 덕분에 자동으로 다시 켜지게 만든다.
- 장애 대응 시 `journalctl -u 서비스명 --since "10 min ago"`로 최근 로그만 빠르게 확인해 원인을 좁힌다.
- 여러 대의 서버에서 특정 서비스 상태를 점검하는 헬스체크 스크립트를 `for`문으로 서버 목록을 순회하며 자동화한다.
- 크론 잡이나 배포 스크립트에서 실행 결과에 따라 `if`로 성공/실패를 분기해 알림(Slack, 이메일)을 다르게 보낸다.
- 반복되는 로깅/알림 로직을 `function`으로 공통 모듈화해, 여러 스크립트에서 재사용하며 유지보수 비용을 줄인다.
# 예상 면접 질문 5개
1. systemd와 기존 SysV init 방식의 차이를 설명해보세요.
2. `systemctl enable`만 하고 `start`를 하지 않으면 어떤 상태가 되는지 설명해보세요.
3. `journalctl`이 기존 `/var/log` 파일 기반 로깅에 비해 갖는 장점을 설명해보세요.
4. Shell Script에서 변수를 따옴표로 감싸지 않았을 때 발생할 수 있는 문제를 예시와 함께 설명해보세요.
5. `for`문과 `while`문의 차이를 실제 자동화 스크립트 사례와 함께 설명해보세요.
 
