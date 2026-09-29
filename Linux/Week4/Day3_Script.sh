#!/bin/bash

name="devuser"
echo "안녕하세요, $name 님"

if [ -z "$1" ]; then
	echo "인자를 입력해주세요!"
else
	echo "입력한 인자: $1"
fi

case "$1" in
	start) echo "서비스를 시작합니다!";;
	stop) echo "서비스를 종료합니다ㅠ";;
	*) echo "알 수 없는 명령입니다";;
esac
