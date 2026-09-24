#!/bin/bash

sudo useradd -m -s /bin/bash testuser
sudo groupadd testgroup

grep "testuser" /etc/passwd
grep "testgroup" /etc/group

sudo usermod -aG testgroup testuser
groups testuser

ps aux --sort=-%cpu | head -6

sleep 60 &
ps aux | grep sleep | grep -v grep
