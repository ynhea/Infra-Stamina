#!/bin/bash

cd ~/Workspace

# 1. 백업 대상 파일 목록 확인
backup_dir=~/Workspace/practice
link=backup_$(date "+%Y%m%d").tar.gz
find $backup_dir

# 2. 압축
tar -czvf $link $backup_dir 
cp $link  BackUp/$link

# 3. 권한 제한
chmod 600 BackUp/$link

# 4. 백업 성공확인
ls -l BackUp
tar -tzf BackUp/$link

# 5. 임시 압축파일 삭제
rm $link
