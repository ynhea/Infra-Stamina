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
