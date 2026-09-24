#!/bin/bash

useradd -m -s /bin/bash testuser
groupadd testgroup

grep "testuser" /etc/passwd
grep "testgroup" /etc/group

usermod -aG testgroup testuser
groups testuser

ps aux --sort=-%cpu | head -6
ps aux | grep sleep | grep -v grep
